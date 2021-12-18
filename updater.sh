#!/bin/bash
# Update and adapt the domains automatically. Just sweet!
# Head to the data directory.
mkdir -p rawdata
mkdir -p data
cd rawdata
# Fetch and adapt 1HostsPro
curl -Lo 1hosts-pro.list https://github.com/badmojr/1Hosts/raw/master/Pro/wildcards.txt
sed -i "s/\*./domain:/g" 1hosts-pro.list
# Fetch Energized BluGo (replaced Blu due to size concerns)
curl -Lo energized-blu.list https://energized.pro/bluGo/formats/domains.txt
# Fetch and adapt AdAway
curl -Lo adaway.list https://github.com/AdAway/adaway.github.io/raw/master/hosts.txt
sed -i "s/127.0.0.1 //g" adaway.list
# Fetch and adapt OISD Basic
curl -Lo oisd-basic.list https://dblw.oisd.nl/basic/
sed -i "s/\*./domain:/g" oisd-basic.list
# Fetch BlocklistProject
curl -Lo blocklistproject-ransomware.list https://blocklistproject.github.io/Lists/alt-version/ransomware-nl.txt
curl -Lo blocklistproject-scam.list https://blocklistproject.github.io/Lists/alt-version/scam-nl.txt
curl -Lo blocklistproject-tracking.list https://blocklistproject.github.io/Lists/alt-version/tracking-nl.txt
# Validate every blocklist
bash ../validater.sh
# All work done!
cd ..
exit
