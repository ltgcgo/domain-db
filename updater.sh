#!/bin/bash
# Update and adapt the domains automatically. Just sweet!
# Head to the data directory.
mkdir -p rawdata
mkdir -p data
cd rawdata
# Fetch and adapt 1Hosts-Lite
curl -Lo 1hosts-lite.list https://raw.githubusercontent.com/badmojr/1Hosts/master/Lite/wildcards.txt
sed -i "s/\*./domain:/g" 1hosts-lite.list
# Fetch Energized BluGo (replaced Blu due to size concerns)
#curl -Lo energized-blu.list https://energized.pro/bluGo/formats/domains.txt
# Fetch and adapt AdAway
#curl -Lo adaway.list https://github.com/AdAway/adaway.github.io/raw/master/hosts.txt
#sed -i "s/127.0.0.1 //g" adaway.list
# Fetch and adapt OISD Basic
curl -Lo oisd-basic.list https://small.oisd.nl/
#sed -i "s/||/domain:/g" oisd-basic.list
# Fetch BlocklistProject
curl -Lo blocklistproject-ransomware.list https://blocklistproject.github.io/Lists/alt-version/ransomware-nl.txt
curl -Lo blocklistproject-scam.list https://blocklistproject.github.io/Lists/alt-version/scam-nl.txt
#curl -Lo blocklistproject-tracking.list https://blocklistproject.github.io/Lists/alt-version/tracking-nl.txt
curl -Lo blocklistproject-gambling.list https://blocklistproject.github.io/Lists/alt-version/gambling-nl.txt
# Fetch Combined Privacy Blocklists
#curl -Lo combinedprivacy.list https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/MiniLists/NoFormatting/mini-cpbl-wildcard-blacklist.txt
sed -i "s/\*./domain:/g" combinedprivacy.list
# Validate every blocklist
bash ../validater.sh
# All work done!
cd ..
if [ "$1" != "nopush" ] ; then
	git stage -A
	git commit -m "Automated updater task."
	git push
fi
exit
