#!/usr/bin/env python3
"""
MakinMoves Autonomous Orchestrator
Executes content posting, metrics tracking, and work queue management
Runs on schedule (GitHub Actions, local cron, or AWS Lambda)
"""

import os
import json
import re
from datetime import datetime
from pathlib import Path
from typing import Optional, Dict, List
import requests
import tweepy
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configuration
GUMROAD_TOKEN = os.getenv("GUMROAD_ACCESS_TOKEN")
TWITTER_API_KEY = os.getenv("TWITTER_API_KEY")
TWITTER_API_SECRET = os.getenv("TWITTER_API_SECRET")
TWITTER_ACCESS_TOKEN = os.getenv("TWITTER_ACCESS_TOKEN")
TWITTER_ACCESS_TOKEN_SECRET = os.getenv("TWITTER_ACCESS_TOKEN_SECRET")
TWITTER_BEARER_TOKEN = os.getenv("TWITTER_BEARER_TOKEN")

PROJECT_ROOT = Path(__file__).parent.parent.parent
SHARED = PROJECT_ROOT / "shared"
QUEUE_DIR = SHARED / "queue"
CONTENT_DIR = SHARED / "content"
LOGS_DIR = SHARED / "logs"
METRICS_DIR = SHARED / "metrics"

# Ensure directories exist
for d in [QUEUE_DIR, CONTENT_DIR, LOGS_DIR, METRICS_DIR]:
    d.mkdir(parents=True, exist_ok=True)


class TwitterClient:
    """Handle Twitter API interactions"""
    def __init__(self):
        # Debug: Check if env vars are loaded
        print(f"[Twitter] Bearer token exists: {bool(TWITTER_BEARER_TOKEN)}")
        print(f"[Twitter] API Key exists: {bool(TWITTER_API_KEY)}")

        try:
            self.client = tweepy.Client(
                bearer_token=TWITTER_BEARER_TOKEN,
                consumer_key=TWITTER_API_KEY,
                consumer_secret=TWITTER_API_SECRET,
                access_token=TWITTER_ACCESS_TOKEN,
                access_token_secret=TWITTER_ACCESS_TOKEN_SECRET,
                wait_on_rate_limit=True
            )
            print(f"[Twitter] Client initialized successfully")
        except Exception as e:
            print(f"[Twitter] Auth failed: {e}")
            self.client = None

    def post_tweet(self, text: str) -> Optional[str]:
        """Post a single tweet, return tweet ID"""
        if not self.client:
            print(f"[Twitter] Client is None, cannot post tweet")
            return None
        try:
            print(f"[Twitter] Posting tweet ({len(text)} chars)")
            response = self.client.create_tweet(text=text)
            tweet_id = response.data.get("id") if response.data else None
            print(f"[Twitter] Tweet posted: {tweet_id}")
            return tweet_id
        except Exception as e:
            print(f"[Twitter] Tweet post failed: {type(e).__name__}: {e}")
            return None

    def post_thread(self, tweets: List[str]) -> List[Optional[str]]:
        """Post a thread of tweets, return list of tweet IDs"""
        if not self.client:
            print(f"[Twitter] Client is None, cannot post thread")
            return [None] * len(tweets)

        print(f"[Twitter] Starting thread with {len(tweets)} tweets")
        tweet_ids = []
        reply_to_id = None
        for i, tweet in enumerate(tweets):
            try:
                print(f"[Twitter] Posting tweet {i+1}/{len(tweets)} ({len(tweet)} chars)")
                response = self.client.create_tweet(
                    text=tweet,
                    reply_settings="everyone",
                    in_reply_to_tweet_id=reply_to_id
                )
                tweet_id = response.data.get("id") if response.data else None
                tweet_ids.append(tweet_id)
                reply_to_id = tweet_id
                print(f"[Twitter] Tweet {i+1} posted: {tweet_id}")
            except Exception as e:
                print(f"[Twitter] Tweet {i+1} failed: {type(e).__name__}: {e}")
                tweet_ids.append(None)
        return tweet_ids


class GumroadClient:
    """Handle Gumroad API interactions"""
    def __init__(self):
        self.token = GUMROAD_TOKEN
        self.base_url = "https://api.gumroad.com/v2"

    def get_sales(self) -> Dict:
        """Fetch recent sales data"""
        try:
            headers = {"Authorization": f"Bearer {self.token}"}
            response = requests.get(
                f"{self.base_url}/sales",
                headers=headers,
                timeout=10
            )
            return response.json() if response.status_code == 200 else {}
        except Exception as e:
            print(f"Gumroad sales fetch failed: {e}")
            return {}

    def get_products(self) -> List[Dict]:
        """Fetch all products"""
        try:
            headers = {"Authorization": f"Bearer {self.token}"}
            response = requests.get(
                f"{self.base_url}/products",
                headers=headers,
                timeout=10
            )
            return response.json().get("products", []) if response.status_code == 200 else []
        except Exception as e:
            print(f"Gumroad products fetch failed: {e}")
            return []


class WorkQueueManager:
    """Manage work queue state and execution"""
    def __init__(self):
        self.queue_file = QUEUE_DIR / "CURRENT_WORKQUEUE.md"
        self.execution_log = LOGS_DIR / "BLOCK_EXECUTION_LOG.md"
        self.content_queue = CONTENT_DIR / "CONTENT_QUEUE.md"
        self.metrics_file = METRICS_DIR / "DAILY_METRICS.md"

        # Debug paths
        print(f"[Paths] PROJECT_ROOT: {PROJECT_ROOT}")
        print(f"[Paths] SHARED: {SHARED}")
        print(f"[Paths] CONTENT_DIR: {CONTENT_DIR}")
        print(f"[Paths] content_queue path: {self.content_queue}")
        print(f"[Paths] content_queue exists: {self.content_queue.exists()}")

    def read_queue(self) -> Dict:
        """Parse work queue markdown"""
        if not self.queue_file.exists():
            return {"tasks": [], "blocked_issues": []}

        content = self.queue_file.read_text()
        tasks = re.findall(r"- \[ \] (.+?)(?:\(|$)", content)
        issues = re.findall(r"- (.+?) \(blocker", content)

        return {
            "tasks": tasks[:5],  # Next 5 tasks
            "blocked_issues": issues,
            "raw": content
        }

    def get_ready_content(self) -> Dict[str, List[str]]:
        """Parse content queue for ready-to-post items"""
        if not self.content_queue.exists():
            print(f"Warning: {self.content_queue} not found, skipping content posting")
            return {}

        try:
            content = self.content_queue.read_text()
        except Exception as e:
            print(f"Error reading content queue: {e}")
            return {}

        # Normalize line endings to handle both Windows (CRLF) and Unix (LF)
        content = content.replace("\r\n", "\n")

        # Parse "READY TO POST" section
        ready_section = re.search(
            r"## READY TO POST\n(.*?)(?=\n##|\Z)",
            content,
            re.DOTALL
        )

        if not ready_section:
            print("Warning: No READY TO POST section found")
            print(f"[Content Parse] Content preview: {content[:200]}")
            return {}

        items = {}
        for line in ready_section.group(1).strip().split("\n"):
            if line.startswith("- "):
                # Parse: "- Twitter thread on [topic] (content/twitter_*.md)"
                match = re.search(r"- (.+?) \((.*?)\)", line)
                if match:
                    item_type = match.group(1)
                    relative_path = match.group(2).lstrip("/")
                    file_path = SHARED / relative_path

                    print(f"[Content Parse] Item: {item_type}")
                    print(f"[Content Parse] Relative path: {relative_path}")
                    print(f"[Content Parse] Full path: {file_path}")
                    print(f"[Content Parse] Exists: {file_path.exists()}")

                    if file_path.exists():
                        items[item_type] = {
                            "path": file_path,
                            "content": file_path.read_text()
                        }
                        print(f"[Content Parse] ✅ Loaded {item_type}")
                    else:
                        print(f"[Content Parse] ❌ File not found: {file_path}")

        print(f"[Content Parse] Total items loaded: {len(items)}")
        return items

    def log_execution(self, block_name: str, completed: List[str],
                     metrics: Dict, issues: List[str] = None):
        """Log block execution"""
        timestamp = datetime.now().isoformat()

        log_entry = f"""
## {block_name} [{timestamp}]
### Completed
"""
        for task in completed:
            log_entry += f"- {task}: ✅\n"

        log_entry += f"\n### Metrics\n"
        for key, val in metrics.items():
            log_entry += f"- {key}: {val}\n"

        if issues:
            log_entry += f"\n### Blocking Issues\n"
            for issue in issues:
                log_entry += f"- {issue}\n"

        # Append to log
        if self.execution_log.exists():
            existing = self.execution_log.read_text()
            self.execution_log.write_text(existing + log_entry)
        else:
            self.execution_log.write_text(log_entry)

    def update_metrics(self, metrics: Dict):
        """Update daily metrics"""
        if not self.metrics_file.exists():
            self.metrics_file.write_text("# Daily Metrics\n\n")

        content = self.metrics_file.read_text()
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")

        metric_line = f"\n## Block [{timestamp}]\n"
        for key, val in metrics.items():
            metric_line += f"- {key}: {val}\n"

        self.metrics_file.write_text(content + metric_line)

    def update_queue(self, completed_tasks: List[str], next_tasks: List[str]):
        """Remove completed tasks, add next tasks"""
        if not self.queue_file.exists():
            return

        content = self.queue_file.read_text()

        # Remove completed tasks
        for task in completed_tasks:
            content = re.sub(
                rf"- \[ \] {re.escape(task)}.*?\n",
                "",
                content
            )

        # Update next section
        updated = content.replace(
            "## MORNING BLOCK",
            f"## MORNING BLOCK (updated {datetime.now().isoformat()})"
        )

        self.queue_file.write_text(updated)


class Orchestrator:
    """Main orchestration logic"""
    def __init__(self):
        self.twitter = TwitterClient()
        self.gumroad = GumroadClient()
        self.queue = WorkQueueManager()
        self.metrics = {}
        self.completed = []
        self.issues = []

    def execute_block(self):
        """Execute a single work block"""
        try:
            print(f"[{datetime.now().isoformat()}] Starting block execution...")

            # Read work queue
            work = self.queue.read_queue()
            print(f"Found {len(work['tasks'])} tasks, {len(work['blocked_issues'])} blockers")

            # Get ready content
            content_items = self.queue.get_ready_content()
            print(f"Found {len(content_items)} ready content items")

            # Execute posting tasks
            if content_items:
                self._post_content(content_items)
            else:
                print("No content ready to post")
                self.completed.append("Content queue empty")

            # Fetch Gumroad metrics
            self._update_gumroad_metrics()

            # Log execution
            self.queue.log_execution(
                f"Execution Block {datetime.now().strftime('%Y-%m-%d %H:%M')}",
                self.completed,
                self.metrics,
                self.issues
            )

            # Update metrics file
            self.queue.update_metrics(self.metrics)

            print(f"Block complete. Completed {len(self.completed)} tasks.")
        except Exception as e:
            print(f"Error in execute_block: {e}")
            self.issues.append(f"Block execution error: {str(e)}")
            raise

    def _post_content(self, content_items: Dict):
        """Post content to platforms"""
        for item_name, item_data in content_items.items():
            try:
                if "twitter" in item_name.lower():
                    self._post_twitter(item_data["content"], item_name)
                elif "email" in item_name.lower():
                    self._queue_email(item_data["content"], item_name)
                elif "medium" in item_name.lower():
                    self._log_medium(item_name)
                # Add more platforms as needed
            except Exception as e:
                self.issues.append(f"{item_name}: {str(e)}")
                print(f"Error posting {item_name}: {e}")

    def _post_twitter(self, content: str, item_name: str):
        """Parse and post Twitter thread"""
        print(f"[Twitter Parse] Starting for {item_name}")
        # Split by --- separator (each section = one tweet)
        sections = re.split(r"\n-{3,}\n", content.strip())
        print(f"[Twitter Parse] Found {len(sections)} sections")

        # Clean up sections (remove title line if present, trim whitespace)
        tweets = []
        for i, section in enumerate(sections):
            lines = section.strip().split('\n')
            # Skip title lines (starting with #)
            tweet_text = '\n'.join([l for l in lines if not l.startswith('#')]).strip()
            if tweet_text:
                tweets.append(tweet_text)
                print(f"[Twitter Parse] Section {i}: {len(tweet_text)} chars")

        print(f"[Twitter Parse] Total tweets ready: {len(tweets)}")
        if not tweets:
            self.issues.append(f"{item_name}: No valid tweets found after parsing")
            print(f"[Twitter Parse] ERROR: No tweets extracted from content")
            return

        # Post as thread
        print(f"[Twitter Post] Posting {len(tweets)} tweets for {item_name}")
        tweet_ids = self.twitter.post_thread(tweets)
        successful = len([t for t in tweet_ids if t])
        print(f"[Twitter Post] Result: {successful}/{len(tweets)} tweets posted")

        if successful > 0:
            self.completed.append(f"{item_name} ({successful}/{len(tweets)} tweets posted)")
            self.metrics[f"{item_name}"] = f"{successful} tweets"
        else:
            self.issues.append(f"{item_name}: Posted but no tweet IDs returned (check Twitter API)")
            self.completed.append(f"{item_name} (attempted {len(tweets)} tweets)")

    def _queue_email(self, content: str, item_name: str):
        """Queue email for manual send or API integration"""
        # For now, just log it
        self.completed.append(f"{item_name} (queued)")
        self.metrics[item_name] = "queued"

    def _log_medium(self, item_name: str):
        """Log Medium posting (manual step for now)"""
        self.completed.append(f"{item_name} (logged for manual posting)")
        self.metrics[item_name] = "pending_manual"

    def _update_gumroad_metrics(self):
        """Fetch and log Gumroad sales"""
        try:
            sales = self.gumroad.get_sales()
            if sales:
                self.metrics["gumroad_sales"] = sales.get("total_sales", 0)
                self.completed.append("Gumroad metrics updated")
        except Exception as e:
            self.issues.append(f"Gumroad metrics: {str(e)}")


def main():
    """Entry point"""
    orchestrator = Orchestrator()
    orchestrator.execute_block()


if __name__ == "__main__":
    main()
