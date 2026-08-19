#!/usr/bin/env bash

set -e

DB_NAME="mfano_bora_db"
DB_USER="postgres"
PHP_PORT="8000"

echo "=================================================="
echo " Mfano Bora Resources Portal - Environment Setup  "
echo "=================================================="

# 1. Dependency Checks & Auto-Installation
echo "[1/6] Checking required system packages..."
REQUIRED_PKGS=()

command -v php >/dev/null 2>&1 || REQUIRED_PKGS+=("php")
command -v psql >/dev/null 2>&1 || REQUIRED_PKGS+=("postgresql" "postgresql-contrib")
command -v lsof >/dev/null 2>&1 || REQUIRED_PKGS+=("lsof")
command -v xdg-open >/dev/null 2>&1 || REQUIRED_PKGS+=("xdg-utils")

# Check PHP PostgreSQL extension
if command -v php >/dev/null 2>&1; then
    if ! php -m | grep -q "pgsql"; then
        REQUIRED_PKGS+=("php-pgsql")
    fi
fi

if [ ${#REQUIRED_PKGS[@]} -ne 0 ]; then
    echo "Installing missing dependencies: ${REQUIRED_PKGS[*]}"
    sudo apt-get update -qq
    sudo apt-get install -y "${REQUIRED_PKGS[@]}"
else
    echo "All system dependencies are installed."
fi

# Ensure PostgreSQL service is active
echo "[2/6] Verifying PostgreSQL service..."
if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl start postgresql
else
    sudo service postgresql start
fi

# 2. Safe PostgreSQL Port Handling
PGPORT=5432
if command -v pg_lsclusters >/dev/null 2>&1; then
    # Detect the port of the active PostgreSQL cluster
    ACTIVE_PORT=$(pg_lsclusters --no-header | awk '$4=="online" {print $3}' | head -n 1)
    if [ -n "$ACTIVE_PORT" ]; then
        PGPORT="$ACTIVE_PORT"
    fi
fi

echo "Using PostgreSQL on port $PGPORT..."

# 3. Database Creation & Schema/Seed Execution
echo "[3/6] Setting up PostgreSQL database ($DB_NAME)..."

# Check if database exists
DB_EXISTS=$(sudo -u "$DB_USER" psql -p "$PGPORT" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME';" || true)

if [ "$DB_EXISTS" != "1" ]; then
    echo "Creating database '$DB_NAME'..."
    sudo -u "$DB_USER" createdb -p "$PGPORT" "$DB_NAME"
else
    echo "Database '$DB_NAME' already exists."
fi

# Import Schema and Seed files
if [ -f "database/schema.sql" ]; then
    echo "Applying schema (database/schema.sql)..."
    sudo -u "$DB_USER" psql -p "$PGPORT" -d "$DB_NAME" -f database/schema.sql >/dev/null
else
    echo "Warning: database/schema.sql not found."
fi

if [ -f "database/seed.sql" ]; then
    echo "Populating seed data (database/seed.sql)..."
    sudo -u "$DB_USER" psql -p "$PGPORT" -d "$DB_NAME" -f database/seed.sql >/dev/null
else
    echo "Warning: database/seed.sql not found."
fi

# 4. PHP Configuration File Generation
echo "[4/6] Checking application configuration..."
if [ ! -f "config/config.php" ] && [ -f "config/config.example.php" ]; then
    echo "Creating config/config.php from template..."
    cp config/config.example.php config/config.php
    
    # Generate random API Key and inject into config.php
    NEW_KEY=$(php -r "echo bin2hex(random_bytes(24));")
    sed -i "s/'admin_api_key' => '.*'/'admin_api_key' => '$NEW_KEY'/" config/config.php
    echo "Generated new admin_api_key: $NEW_KEY"
fi

# 5. Terminate Existing Running Server Instances
echo "[5/6] Clearing existing PHP processes on port $PHP_PORT..."
PID=$(lsof -ti :"$PHP_PORT" || true)
if [ -n "$PID" ]; then
    echo "Killing running process (PID: $PID) on port $PHP_PORT..."
    kill -9 $PID
    sleep 1
else
    echo "Port $PHP_PORT is clear."
fi

# 6. Run PHP Development Server & Launch Browser
echo "[6/6] Starting local PHP server and opening Admin Dashboard..."
php -S "localhost:$PHP_PORT" > /dev/null 2>&1 &
SERVER_PID=$!

sleep 2

# Verify server started successfully
if kill -0 $SERVER_PID 2>/dev/null; then
    ADMIN_URL="http://localhost:$PHP_PORT/admin/index.html"
    echo "Server running at http://localhost:$PHP_PORT"
    echo "Opening $ADMIN_URL in browser..."
    
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$ADMIN_URL"
    elif command -v open >/dev/null 2>&1; then
        open "$ADMIN_URL"
    fi
else
    echo "Failed to start PHP server on port $PHP_PORT."
    exit 1
fi

echo "=================================================="
echo " Setup complete! Press Ctrl+C to stop server.      "
echo "=================================================="

# Keep process alive attached to shell terminal
wait $SERVER_PID