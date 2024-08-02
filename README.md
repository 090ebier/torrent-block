# Torrent Block Script

This script uses `iptables` to block torrent traffic on your server. It is designed to prevent the use of BitTorrent protocols by filtering common torrent-related traffic patterns and blocking specific ports.

## Prerequisites

- A Debian-based Linux distribution (e.g., Ubuntu).
- Root or sudo access to install packages and modify iptables rules.

## Installation and Usage

To download and run the script using `curl`, use the following command:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/090ebier/torrent-blocking-script/main/block_torrent.sh)"
