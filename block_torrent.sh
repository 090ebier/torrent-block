#!/bin/sh

apt-get install -y iptables iptables-persistent

iptables -N TORRENT_CHAIN_INPUT
iptables -N TORRENT_CHAIN_OUTPUT
iptables -N TORRENT_CHAIN_FORWARD
iptables -N abuse-defender

iptables -A INPUT -j TORRENT_CHAIN_INPUT
iptables -A OUTPUT -j TORRENT_CHAIN_OUTPUT
iptables -I OUTPUT -j abuse-defender
iptables -A FORWARD -j TORRENT_CHAIN_FORWARD

iptables -F TORRENT_CHAIN_INPUT
iptables -F TORRENT_CHAIN_OUTPUT
iptables -F TORRENT_CHAIN_FORWARD




[ -e bt.sh ] || wget https://github.com/Heclalava/blockpublictorrent-iptables/raw/main/bt.sh && chmod +x bt.sh && bash bt.sh

iptables -A TORRENT_CHAIN_INPUT -p tcp --dport 6881:6889 -j DROP
iptables -A TORRENT_CHAIN_INPUT -p udp --dport 6881:6889 -j DROP

iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "BitTorrent" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "peer_id=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string ".torrent" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "torrent" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "announce" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "info_hash" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --string "get_peers" --algo bm -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --string "announce_peer" --algo bm -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --string "find_node" --algo bm -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p TCP --dport 25 -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p TCP --dport 465 -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p TCP --dport 587 -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p tcp --dport 6881:6889 -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p udp --dport 6881:6889 -j DROP

iptables -A abuse-defender -d 10.0.0.0/8 -j DROP
iptables -A abuse-defender -d 100.64.0.0/10 -j DROP
iptables -A abuse-defender -d 169.254.0.0/16 -j DROP
iptables -A abuse-defender -d 172.16.0.0/12 -j DROP
iptables -A abuse-defender -d 192.0.0.0/24 -j DROP
iptables -A abuse-defender -d 192.0.2.0/24 -j DROP
iptables -A abuse-defender -d 192.88.99.0/24 -j DROP
iptables -A abuse-defender -d 192.168.0.0/16 -j DROP
iptables -A abuse-defender -d 198.18.0.0/15 -j DROP
iptables -A abuse-defender -d 198.51.100.0/24 -j DROP
iptables -A abuse-defender -d 203.0.113.0/24 -j DROP
iptables -A abuse-defender -d 240.0.0.0/24 -j DROP
iptables -A abuse-defender -d 224.0.0.0/4 -j DROP
iptables -A abuse-defender -d 233.252.0.0/24 -j DROP
iptables -A abuse-defender -d 102.0.0.0/8 -j DROP
iptables -A abuse-defender -d 185.235.86.0/24 -j DROP
iptables -A abuse-defender -d 185.235.87.0/24 -j DROP
iptables -A abuse-defender -d 114.208.187.0/24 -j DROP
iptables -A abuse-defender -d 216.218.185.0/24 -j DROP
iptables -A abuse-defender -d 206.191.152.0/24 -j DROP
iptables -A abuse-defender -d 45.14.174.0/24 -j DROP
iptables -A abuse-defender -d 195.137.167.0/24 -j DROP
iptables -A abuse-defender -d 103.58.50.0/24 -j DROP
iptables -A abuse-defender -d 25.0.0.0/19 -j DROP



iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A TORRENT_CHAIN_FORWARD -p TCP --dport 25 -j DROP
iptables -A TORRENT_CHAIN_FORWARD -p TCP --dport 465 -j DROP
iptables -A TORRENT_CHAIN_FORWARD -p TCP --dport 587 -j DROP

iptables -L

systemctl stop rpcbind.service
systemctl disable rpcbind.service
systemctl mask rpcbind.service
systemctl stop rpcbind.socket
systemctl disable rpcbind.socket
systemctl mask rpcbind.socket
systemctl daemon-reload

iptables-save > /etc/iptables/rules.v4
