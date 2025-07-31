#!/bin/bash

# Tailscale initialization script for IGEL OS

# Set up logging
LOGFILE="/var/log/tailscale-debug.log"
echo "Starting Tailscale initialization at $(date)" | tee -a "$LOGFILE"

# Create necessary directories
echo "Creating directories..." | tee -a "$LOGFILE"
mkdir -p /var/lib/tailscale 2>/dev/null || true
mkdir -p /var/run/tailscale 2>/dev/null || true
chmod 700 /var/lib/tailscale 2>/dev/null || true
chmod 755 /var/run/tailscale 2>/dev/null || true

# Set executable permissions on binaries
chmod +x /services/tailscale/usr/bin/tailscale 2>/dev/null || true
chmod +x /services/tailscale/usr/sbin/tailscaled 2>/dev/null || true

# Create symlinks for CLI access
ln -sf /services/tailscale/usr/bin/tailscale /usr/bin/tailscale 2>/dev/null || true
ln -sf /services/tailscale/usr/sbin/tailscaled /usr/sbin/tailscaled 2>/dev/null || true

# Set default values
PORT="${PORT:-41641}"
FLAGS="${FLAGS:-}"

# Load configuration from environment file if it exists
if [ -f /etc/default/tailscaled ]; then
    echo "Loading configuration from /etc/default/tailscaled" | tee -a "$LOGFILE"
    . /etc/default/tailscaled
fi

# Debugging output
echo "Configuration:" | tee -a "$LOGFILE"
echo "  Port: $PORT" | tee -a "$LOGFILE"
echo "  Flags: $FLAGS" | tee -a "$LOGFILE"

# Check if binary exists and is executable
DAEMON_PATH="/services/tailscale/usr/sbin/tailscaled"
if [ ! -x "$DAEMON_PATH" ]; then
    echo "ERROR: Tailscale daemon not found or not executable at $DAEMON_PATH" | tee -a "$LOGFILE"
    exit 1
fi

# Check directories and permissions
echo "Directory status:" | tee -a "$LOGFILE"
ls -la /var/lib/tailscale | tee -a "$LOGFILE"
ls -la /var/run/tailscale | tee -a "$LOGFILE"

echo "Starting tailscaled daemon..." | tee -a "$LOGFILE"

# Start tailscaled with proper arguments
exec "$DAEMON_PATH" \
    --state=/var/lib/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock \
    --port="$PORT" \
    $FLAGS