#!/bin/bash
# Update and adapt the domains automatically. Just sweet!
# Head to the data directory.
cd data
# Fetch and adapt 1HostsPro
curl -Lo 1hosts-pro https://github.com/badmojr/1Hosts/raw/master/Pro/wildcards.txt
sed -i "s/\*./domain:/g" 1hosts-pro
# Fetch Energized BluGo (replaced Blu due to size concerns)
curl -Lo energized-blu https://energized.pro/bluGo/formats/domains.txt
# Fetch and adapt AdAway
curl -Lo adaway https://github.com/AdAway/adaway.github.io/raw/master/hosts.txt
sed -i "s/127.0.0.1 //g" adaway
# Fetch and adapt OISD Basic
curl -Lo oisd-basic https://dblw.oisd.nl/basic/
sed -i "s/\*./domain:/g" oisd-basic
# Fetch BlocklistProject
curl -Lo blocklistproject-ransomware https://blocklistproject.github.io/Lists/alt-version/ransomware-nl.txt
curl -Lo blocklistproject-scam https://blocklistproject.github.io/Lists/alt-version/scam-nl.txt
curl -Lo blocklistproject-tracking https://blocklistproject.github.io/Lists/alt-version/tracking-nl.txt
# All work done!
cd ..
exit
