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
        try:
            self.client = tweepy.Client(
                bearer_token=TWITTER_BEARER_TOKEN,
                consumer_key=TWITTER_API_KEY,
                consumer_secret=TWITTER_API_SECRET,
                access_token=TWITTER_ACCESS_TOKEN,
                access_token_secret=TWITTER_ACCESS_TOKEN_SECRET,
                wait_on_rate_limit=True
            )
        except Exception as e:
            print(f"Twitter auth failed: {e}")
            self.client = None

    def post_tweet(self, text: str) -> Optional[str]:
        """Post a single tweet, return tweet ID"""
        if not self.client:
            return None
        try:
            response = self.client.create_tweet(text=text)
            return response.data.get("id") if response.data else None
        except Exception as e:
            print(f"Tweet post failed: {e}")
            return None

    def post_thread(self, tweets: List[str]) -> List[Optional[str]]:
        """Post a thread of tweets, return list of tweet IDs"""
        if not self.client:
            return [None] * len(tweets)

        tweet_ids = []
        reply_to_id = None
        for tweet in tweets:
            try:
                response = self.client.create_tweet(
                    text=tweet,
                    reply_settings="everyone",
                    in_reply_to_tweet_id=reply_to_id
                )
                tweet_id = response.data.get("id") if response.data else None
                tweet_ids.append(tweet_id)
                reply_to_id = tweet_id
            except Exception as e:
                print(f"Thread tweet failed: {e}")
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

        # Parse "READY TO POST" section
        ready_section = re.search(
            r"## READY TO POST\n(.*?)(?=\n##|\Z)",
            content,
            re.DOTALL
        )

        if not ready_section:
            return {}

        items = {}
        for line in ready_section.group(1).strip().split("\n"):
            if line.startswith("- "):
                # Parse: "- Twitter thread on [topic] (shared/content/twitter_*.md)"
                match = re.search(r"- (.+?) \((.*?)\)", line)
                if match:
                    item_type = match.group(1)
                    file_path = SHARED / match.group(2).lstrip("/")

                    if file_path.exists():
                        items[item_type] = {
                            "path": file_path,
                            "content": file_path.read_text()
                        }

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
        # Split by tweet markers (usually line breaks or "---")
        tweets = re.split(r"\n(?:---|==)\n|\n\n", content.strip())
        tweets = [t.strip() for t in tweets if t.strip() and len(t.strip()) <= 280]

        if not tweets:
            self.issues.append(f"{item_name}: No valid tweets found")
            return

        # Post as thread
        tweet_ids = self.twitter.post_thread(tweets)
        successful = len([t for t in tweet_ids if t])

        self.completed.append(f"{item_name} ({successful}/{len(tweets)} tweets)")
        self.metrics[f"{item_name} tweets"] = successful

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
