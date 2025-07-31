# Tailscale VPN for IGEL OS

## Description

Tailscale VPN client packaged for IGEL OS 12. Based on Tailscale version 1.78.1.

## Package Contents

- tailscale CLI tool
- tailscaled daemon
- systemd service configuration

## Build Requirements

- Download Tailscale amd64 deb package from https://pkgs.tailscale.com/stable/
- Upload the deb file when using IGEL App Creator Portal

## Usage

After installation, authenticate using:
```
sudo tailscale up
```

Or with an auth key:
```
sudo tailscale up --authkey=YOUR_KEY
```

## License

Tailscale is distributed under the BSD-3-Clause license.

---
**Disclaimer:** THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND.