#!/usr/bin/env python3
"""
Gumroad Sales Monitor — ExSitu Innovations / MakinMoves
Checks for new sales, prints summary, optionally logs to file.
Usage: python3 check_sales.py [--log]
"""

import os
import sys
import json
import urllib.request
import urllib.parse
from datetime import datetime, timezone
from pathlib import Path

# Load token from .env
ENV_PATH = Path(__file__).parent.parent / ".env"
TOKEN = None

if ENV_PATH.exists():
    for line in ENV_PATH.read_text().splitlines():
        if line.startswith("GUMROAD_ACCESS_TOKEN="):
            TOKEN = line.split("=", 1)[1].strip()
            break

if not TOKEN:
    TOKEN = os.environ.get("GUMROAD_ACCESS_TOKEN")

if not TOKEN:
    print("ERROR: No GUMROAD_ACCESS_TOKEN found in .env or environment")
    sys.exit(1)

API_BASE = "https://api.gumroad.com/v2"

PRODUCTS = {
    "ai-prompts-freelancers": {"name": "AI Prompts for Freelancers", "price": 24},
    "notion-freelancer-tracker": {"name": "Notion Invoice + Client Tracker", "price": 39},
    "freelance-starter-kit": {"name": "Freelance Starter Kit (Bundle)", "price": 49},
}

GUMROAD_FEE_RATE = 0.10
GUMROAD_FEE_FLAT = 0.50


def api_get(endpoint, params=None):
    """Make GET request to Gumroad API."""
    if params is None:
        params = {}
    params["access_token"] = TOKEN
    url = f"{API_BASE}/{endpoint}?{urllib.parse.urlencode(params)}"
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())


def get_products():
    """Fetch all products."""
    data = api_get("products")
    if data.get("success"):
        return data["products"]
    return []


def get_sales(page=1):
    """Fetch sales (paginated)."""
    data = api_get("sales", {"page": str(page)})
    if data.get("success"):
        return data.get("sales", [])
    return []


def get_all_sales():
    """Fetch all sales across all pages."""
    all_sales = []
    page = 1
    while True:
        sales = get_sales(page)
        if not sales:
            break
        all_sales.extend(sales)
        page += 1
    return all_sales


def format_currency(cents):
    """Format cents as dollars."""
    return f"${cents / 100:.2f}"


def main():
    log_mode = "--log" in sys.argv
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    print(f"\n{'='*60}")
    print(f"  GUMROAD SALES MONITOR — ExSitu Innovations")
    print(f"  {now}")
    print(f"{'='*60}\n")

    # Check products
    print("PRODUCTS:")
    products = get_products()
    for p in products:
        status = "LIVE" if p.get("published") else "DRAFT"
        print(f"  [{status}] {p['name']} — ${p['price']/100:.0f} | views: {p.get('sales_count', 0)} sales")

    # Check sales
    print(f"\nSALES:")
    sales = get_all_sales()

    if not sales:
        print("  No sales yet. Keep pushing!")
        total_revenue = 0
        total_net = 0
    else:
        by_product = {}
        total_revenue = 0
        total_fees = 0

        for sale in sales:
            product = sale.get("product_name", "Unknown")
            price = sale.get("price", 0)
            fee = sale.get("gumroad_fee", 0)
            total_revenue += price
            total_fees += fee

            if product not in by_product:
                by_product[product] = {"count": 0, "revenue": 0, "fees": 0}
            by_product[product]["count"] += 1
            by_product[product]["revenue"] += price
            by_product[product]["fees"] += fee

        total_net = total_revenue - total_fees

        print(f"  Total sales: {len(sales)}")
        print(f"  Gross revenue: {format_currency(total_revenue)}")
        print(f"  Gumroad fees: {format_currency(total_fees)}")
        print(f"  Net revenue: {format_currency(total_net)}")
        print()

        for product, data in by_product.items():
            net = data["revenue"] - data["fees"]
            print(f"  {product}:")
            print(f"    Sales: {data['count']} | Gross: {format_currency(data['revenue'])} | Net: {format_currency(net)}")

    # Projections
    print(f"\nTARGETS:")
    print(f"  Week 1 target: 5-10 sales ($120-$490)")
    print(f"  First sale target: by April 5-7")
    if sales:
        print(f"  Progress: {len(sales)} sales, {format_currency(total_revenue)} gross")

    print(f"\n{'='*60}\n")

    # Log to file if requested
    if log_mode:
        log_dir = Path(__file__).parent.parent / "CFO" / "reports"
        log_dir.mkdir(parents=True, exist_ok=True)
        log_file = log_dir / f"sales_check_{datetime.now().strftime('%Y-%m-%d_%H%M')}.txt"
        with open(log_file, "w") as f:
            f.write(f"Sales Check — {now}\n")
            f.write(f"Total sales: {len(sales)}\n")
            f.write(f"Gross revenue: {format_currency(total_revenue) if sales else '$0.00'}\n")
            f.write(f"Net revenue: {format_currency(total_net) if sales else '$0.00'}\n")
            for s in sales:
                f.write(f"  {s.get('created_at', 'unknown')} | {s.get('product_name', 'unknown')} | {format_currency(s.get('price', 0))}\n")
        print(f"  Log saved: {log_file}")


if __name__ == "__main__":
    main()
