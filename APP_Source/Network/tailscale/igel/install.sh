#!/bin/bash

# Create symlinks for binaries
ln -sf /services/tailscale/usr/bin/tailscale /usr/bin/tailscale
ln -sf /services/tailscale/usr/sbin/tailscaled /usr/sbin/tailscaled

# Create systemd service file with correct paths
cat > /lib/systemd/system/tailscaled.service << 'EOF'
[Unit]
Description=Tailscale node agent
Documentation=https://tailscale.com/kb/
After=network-pre.target
Wants=network-pre.target

[Service]
EnvironmentFile=-/services/tailscale/etc/default/tailscaled
ExecStartPre=/services/tailscale/usr/sbin/tailscaled --cleanup
ExecStart=/services/tailscale/usr/sbin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock
ExecStopPost=/services/tailscale/usr/sbin/tailscaled --cleanup
Restart=on-failure
RuntimeDirectory=tailscale
RuntimeDirectoryMode=0755
StateDirectory=tailscale
StateDirectoryMode=0700
CacheDirectory=tailscale
CacheDirectoryMode=0750
Type=notify

[Install]
WantedBy=multi-user.target
EOF

# Set proper permissions
chmod 644 /lib/systemd/system/tailscaled.service

# Create state directory
mkdir -p /var/lib/tailscale
chmod 700 /var/lib/tailscale

# Enable the service
enable_system_service tailscaled.service