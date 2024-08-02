#!/bin/sh

apt-get install -y iptables iptables-persistent

iptables -N TORRENT_CHAIN_INPUT
iptables -N TORRENT_CHAIN_OUTPUT
iptables -N TORRENT_CHAIN_FORWARD

iptables -A INPUT -j TORRENT_CHAIN_INPUT
iptables -A OUTPUT -j TORRENT_CHAIN_OUTPUT
iptables -A FORWARD -j TORRENT_CHAIN_FORWARD

iptables -F TORRENT_CHAIN_INPUT
iptables -F TORRENT_CHAIN_OUTPUT
iptables -F TORRENT_CHAIN_FORWARD

[ -e bt.sh ] || wget https://github.com/Heclalava/blockpublictorrent-iptables/raw/main/bt.sh && chmod +x bt.sh && bash bt.sh

iptables -A TORRENT_CHAIN_INPUT -p tcp --dport 6881:6889 -j DROP
iptables -A TORRENT_CHAIN_INPUT -p udp --dport 6881:6889 -j DROP

iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "GET /announce?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "GET /scrape?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "GET /announce.php?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "GET /scrape.php?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "GET /announce.php?passkey=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "GET /scrape.php?passkey=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --hex-string "|13426974546f7272656e742070726f746f636f6c|" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "BitTorrent" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "peer_id=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string ".torrent" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "torrent" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "announce" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --algo bm --string "info_hash" -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --string "get_peers" --algo bm -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --string "announce_peer" --algo bm -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -m string --string "find_node" --algo bm -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p TCP --dport 25 -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p TCP --dport 465 -j DROP
iptables -A TORRENT_CHAIN_OUTPUT -p TCP --dport 587 -j DROP

iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "GET /announce?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "GET /scrape?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "GET /announce.php?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "GET /scrape.php?info_hash=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "GET /announce.php?passkey=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "GET /scrape.php?passkey=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --hex-string "|13426974546f7272656e742070726f746f636f6c|" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A TORRENT_CHAIN_FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
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
