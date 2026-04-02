#!/bin/bash
# ── MakinMoves Quick Start ─────────────────────────────
# Usage: bash scripts/start.sh

set -e

echo "=== MakinMoves - Starting Services ==="
echo ""

# Check Docker
if ! docker info > /dev/null 2>&1; then
    echo "ERROR: Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Start Docker services
echo "[1/3] Starting Docker containers..."
docker compose up -d

# Wait for PostgreSQL
echo "[2/3] Waiting for PostgreSQL to be ready..."
until docker exec mm-postgres pg_isready -U makinmoves > /dev/null 2>&1; do
    sleep 1
done
echo "  PostgreSQL is ready!"

# Install npm deps if needed
if [ ! -d "node_modules" ]; then
    echo "[3/3] Installing npm dependencies..."
    npm install
else
    echo "[3/3] Dependencies already installed."
fi

echo ""
echo "=== All Services Running ==="
echo ""
echo "  PostgreSQL:  localhost:5432"
echo "  n8n:         http://localhost:5678  (admin / changeme123)"
echo "  Redis:       localhost:6379"
echo "  Selenium:    http://localhost:4444"
echo "  VNC Viewer:  http://localhost:7900  (watch scraping live)"
echo ""
echo "Next steps:"
echo "  1. Open n8n at http://localhost:5678 to build automation workflows"
echo "  2. Update .env with your API keys"
echo "  3. Run 'claude' in this directory to use MCP-powered tools"
echo ""
