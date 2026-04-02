#!/usr/bin/env python3
"""
CFO CASH POSITION MONITORING SCRIPT
Purpose: Daily tracking of burn rate, runway, cash alerts
Owner: CFO (run daily at 23:59 UTC)
Deployment: March 31, 2026
"""

import psycopg2
from datetime import datetime, timedelta
import json
import sys

# Database connection (config via environment or hardcode for testing)
DB_CONFIG = {
    'host': 'localhost',  # Update to actual host
    'database': 'makinmoves_financial',
    'user': 'cfo_user',
    'password': 'CHANGE_ME',
    'port': 5432
}

class CashPositionMonitor:
    def __init__(self, db_config):
        self.conn = psycopg2.connect(**db_config)
        self.cursor = self.conn.cursor()
        self.alerts = []
        self.timestamp = datetime.utcnow()

    def get_current_cash_position(self):
        """
        Calculate: Total revenue - Total costs = Current cash position
        Also: Starting seed budget - costs spent = Available cash
        """
        query = """
        SELECT
            COALESCE(SUM(amount), 0) as total_revenue,
            COALESCE((SELECT SUM(amount) FROM costs.expenses), 0) as total_costs,
            1000 as seed_budget  -- Hardcoded $1000 seed
        FROM revenue.transactions;
        """
        self.cursor.execute(query)
        result = self.cursor.fetchone()
        revenue, costs, seed = result

        # Cash position = seed budget - costs spent (only costs, not offset by revenue yet)
        # For March 29-31 pre-launch, this is mainly seed depletion
        cash_available = seed - costs
        cumulative_profit = revenue - costs

        return {
            'total_revenue': float(revenue),
            'total_costs': float(costs),
            'seed_budget': float(seed),
            'cash_available': float(cash_available),
            'cumulative_profit': float(cumulative_profit),
            'timestamp': self.timestamp.isoformat()
        }

    def calculate_burn_rate(self):
        """
        Calculate: Daily burn rate based on this month's expenses
        Returns: $/day and projected runway
        """
        query = """
        SELECT
            DATE_TRUNC('month', CURRENT_DATE)::date as month_start,
            SUM(amount) as month_costs_so_far,
            DAY(CURRENT_DATE) as days_elapsed,
            ROUND(SUM(amount) / NULLIF(DAY(CURRENT_DATE), 0), 2) as daily_burn_rate
        FROM costs.expenses
        WHERE DATE_TRUNC('month', cost_date) = DATE_TRUNC('month', CURRENT_DATE);
        """
        self.cursor.execute(query)
        result = self.cursor.fetchone()

        if not result or result[3] is None:
            return {
                'month': datetime.now().strftime('%Y-%m'),
                'month_costs': 0,
                'days_elapsed': 0,
                'daily_burn_rate': 0,
                'runway_days': 999,  # Infinite if no burn
                'alert': None
            }

        month_start, month_costs, days_elapsed, daily_burn = result

        # Get available cash for runway calculation
        cash_query = """
        SELECT COALESCE(1000 - SUM(amount), 1000) as cash_available
        FROM costs.expenses;
        """
        self.cursor.execute(cash_query)
        cash_available = self.cursor.fetchone()[0]

        runway_days = int(cash_available / daily_burn) if daily_burn > 0 else 999

        # Alert logic
        alert = None
        if daily_burn > 20:
            alert = 'RED'  # Exceeding forecast
        elif daily_burn > 15:
            alert = 'YELLOW'

        return {
            'month': str(month_start),
            'month_costs': float(month_costs),
            'days_elapsed': int(days_elapsed),
            'daily_burn_rate': float(daily_burn),
            'cash_available': float(cash_available),
            'runway_days': runway_days,
            'alert': alert
        }

    def get_revenue_by_stream(self):
        """
        Get: Revenue breakdown by P1, P2, P3 streams
        Used to identify which streams are performing
        """
        query = """
        SELECT
            CASE
                WHEN source = 'gumroad' THEN 'P1_Gumroad'
                WHEN source = 'stripe' THEN 'P2_Freelance'
                WHEN source = 'affiliate' THEN 'P3_Affiliate'
                ELSE 'Other'
            END as stream,
            COUNT(*) as transaction_count,
            SUM(net_amount) as net_revenue
        FROM revenue.transactions
        WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
        GROUP BY stream
        ORDER BY net_revenue DESC;
        """
        self.cursor.execute(query)
        results = self.cursor.fetchall()

        streams = {}
        for stream, txn_count, revenue in results:
            streams[stream] = {
                'transactions': int(txn_count),
                'revenue': float(revenue) if revenue else 0
            }

        return streams

    def get_email_list_growth(self):
        """
        Get: Daily email list growth (leading indicator for P2 warm conversion)
        Target: 500+ by April 1
        """
        query = """
        SELECT
            COUNT(*) as total_subscribers,
            COUNT(CASE WHEN subscribed_at >= CURRENT_DATE THEN 1 END) as new_today,
            COUNT(CASE WHEN subscribed_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as new_this_week
        FROM email_list.subscribers;
        """
        self.cursor.execute(query)
        result = self.cursor.fetchone()

        total, new_today, new_week = result if result else (0, 0, 0)

        # Alert: Target 500 by April 1 (3 days from March 29)
        # Need ~165/day growth rate, or 50+ by EOD March 31 at minimum
        alert = None
        if total < 50 and datetime.now().strftime('%Y-%m-%d') == '2026-03-29':
            alert = 'YELLOW'  # Too slow

        return {
            'total_subscribers': int(total),
            'new_today': int(new_today),
            'new_this_week': int(new_week),
            'target_april_1': 500,
            'days_to_target': 3,
            'alert': alert
        }

    def generate_daily_report(self):
        """
        Generate: Complete cash position report for standup
        """
        cash = self.get_current_cash_position()
        burn = self.calculate_burn_rate()
        revenue = self.get_revenue_by_stream()
        email = self.get_email_list_growth()

        report = {
            'timestamp': self.timestamp.isoformat(),
            'cash_position': cash,
            'burn_analysis': burn,
            'revenue_by_stream': revenue,
            'email_list': email,
            'alerts': self._compile_alerts(cash, burn, email)
        }

        return report

    def _compile_alerts(self, cash, burn, email):
        """
        Compile: All RED/YELLOW alerts from all metrics
        """
        alerts = []

        # Burn rate alerts
        if burn['alert'] == 'RED':
            alerts.append({
                'severity': 'RED',
                'metric': 'Daily Burn Rate',
                'value': f"${burn['daily_burn_rate']}/day",
                'threshold': '$20/day',
                'action': 'Escalate to CEO: Costs exceeding forecast'
            })
        elif burn['alert'] == 'YELLOW':
            alerts.append({
                'severity': 'YELLOW',
                'metric': 'Daily Burn Rate',
                'value': f"${burn['daily_burn_rate']}/day",
                'threshold': '$15-20/day',
                'action': 'Monitor closely, plan cost reduction'
            })

        # Runway alerts
        if burn['runway_days'] < 30:
            alerts.append({
                'severity': 'RED',
                'metric': 'Runway Remaining',
                'value': f"{burn['runway_days']} days",
                'threshold': '<30 days',
                'action': 'CRITICAL: Revenue acceleration needed or costs must cut'
            })

        # Email list alerts (leading indicator)
        if email['alert'] == 'YELLOW':
            alerts.append({
                'severity': 'YELLOW',
                'metric': 'Email List Growth Rate',
                'value': f"{email['new_this_week']}/week",
                'threshold': '50+/day needed for M1 target',
                'action': 'Accelerate email growth: paid traffic, partnerships, partnerships'
            })

        return alerts

    def save_report(self, report, filepath='/tmp/cfo_daily_report.json'):
        """
        Save: JSON report to file for standup reference
        """
        with open(filepath, 'w') as f:
            json.dump(report, f, indent=2)

        print(f"[CFO] Report saved: {filepath}")
        return filepath

    def print_report(self, report):
        """
        Print: Human-readable report to stdout
        """
        print("\n" + "="*60)
        print("CFO DAILY CASH POSITION REPORT")
        print("="*60)
        print(f"Timestamp: {report['timestamp']}")

        print("\n--- CASH POSITION ---")
        cash = report['cash_position']
        print(f"Total Revenue (YTD):     ${cash['total_revenue']:,.2f}")
        print(f"Total Costs (YTD):       ${cash['total_costs']:,.2f}")
        print(f"Seed Budget (available): ${cash['cash_available']:,.2f} (started with ${cash['seed_budget']:,.2f})")
        print(f"Cumulative Profit:       ${cash['cumulative_profit']:,.2f}")

        print("\n--- BURN ANALYSIS ---")
        burn = report['burn_analysis']
        print(f"Month:                   {burn['month']}")
        print(f"Daily Burn Rate:         ${burn['daily_burn_rate']:.2f}/day")
        print(f"Runway Remaining:        {burn['runway_days']} days (${burn['cash_available']:,.2f} available)")
        if burn['alert']:
            print(f"⚠️  ALERT:                {burn['alert']} — Costs exceeding forecast")

        print("\n--- REVENUE BY STREAM ---")
        for stream, data in report['revenue_by_stream'].items():
            print(f"{stream:20s}    ${data['revenue']:>10,.2f}  ({data['transactions']} txns)")

        print("\n--- EMAIL LIST (Leading Indicator) ---")
        email = report['email_list']
        print(f"Total Subscribers:       {email['total_subscribers']} (target: {email['target_april_1']} by April 1)")
        print(f"New Today:               {email['new_today']}")
        print(f"New This Week:           {email['new_this_week']}")
        if email['alert']:
            print(f"⚠️  ALERT:                {email['alert']} — Email growth too slow")

        if report['alerts']:
            print("\n--- CRITICAL ALERTS ---")
            for alert in report['alerts']:
                print(f"🚨 {alert['severity']}: {alert['metric']}")
                print(f"   Value: {alert['value']}")
                print(f"   Threshold: {alert['threshold']}")
                print(f"   Action: {alert['action']}")
        else:
            print("\n--- ALERTS ---")
            print("✅ All clear, no RED/YELLOW alerts")

        print("\n" + "="*60)

    def close(self):
        """Close database connection"""
        self.cursor.close()
        self.conn.close()


def main():
    """
    Run: Daily cash position monitoring
    Usage: python3 cash_position_monitoring_script.py
    Schedule: Daily at 23:59 UTC (via cron or n8n)
    """
    try:
        monitor = CashPositionMonitor(DB_CONFIG)
        report = monitor.generate_daily_report()
        monitor.print_report(report)
        monitor.save_report(report)
        monitor.close()

        return 0  # Success

    except Exception as e:
        print(f"[ERROR] CFO Cash Monitoring Failed: {str(e)}")
        return 1  # Failure


if __name__ == '__main__':
    sys.exit(main())
