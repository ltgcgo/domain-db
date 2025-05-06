#!/bin/bash
# Update and adapt the domains automatically. Just sweet!
# Head to the data directory.
mkdir -p source
mkdir -p intermediate
mkdir -p data
cd source
# Fetch and adapt 1Hosts-Lite
curl -Lo 1hosts-lite.list https://raw.githubusercontent.com/badmojr/1Hosts/master/Lite/wildcards.txt
sed -i "s/\*./domain:/g" 1hosts-lite.list
# Fetch Energized BluGo (replaced Blu due to size concerns)
#curl -Lo energized-blu.list https://energized.pro/bluGo/formats/domains.txt
# Fetch and adapt AdAway
#curl -Lo adaway.list https://github.com/AdAway/adaway.github.io/raw/master/hosts.txt
#sed -i "s/127.0.0.1 //g" adaway.list
# Fetch and adapt OISD Basic
curl -Lo oisd-basic.list https://small.oisd.nl/domainswild
#sed -i "s/||/domain:/g" oisd-basic.list
# Fetch BlocklistProject
#curl -Lo bp-abuse.list https://blocklistproject.github.io/Lists/alt-version/abuse-nl.txt
#curl -Lo bp-ads.list https://blocklistproject.github.io/Lists/alt-version/ads-nl.txt
#curl -Lo bp-fraud.list https://blocklistproject.github.io/Lists/alt-version/fraud-nl.txt
#curl -Lo bp-gambling.list https://blocklistproject.github.io/Lists/alt-version/gambling-nl.txt
#curl -Lo bp-malware.list https://blocklistproject.github.io/Lists/alt-version/malware-nl.txt
#curl -Lo bp-phishing.list https://blocklistproject.github.io/Lists/alt-version/phishing-nl.txt
curl -Lo bp-ransomware.list https://blocklistproject.github.io/Lists/alt-version/ransomware-nl.txt
#curl -Lo bp-redirect.list https://blocklistproject.github.io/Lists/alt-version/redirect-nl.txt
curl -Lo bp-scam.list https://blocklistproject.github.io/Lists/alt-version/scam-nl.txt
curl -Lo bp-tiktok.list https://blocklistproject.github.io/Lists/alt-version/tiktok-nl.txt
curl -Lo bp-tracking.list https://blocklistproject.github.io/Lists/alt-version/tracking-nl.txt
# Fetch Combined Privacy Blocklists
#curl -Lo combinedprivacy.list https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/MiniLists/NoFormatting/mini-cpbl-wildcard-blacklist.txt
#sed -i "s/\*./domain:/g" combinedprivacy.list
# Validate every blocklist
bash ../validater.sh
# Copy lists
cp -v ../intermediate/bp-tiktok ../data/tiktok
cp -v ../intermediate/liteblock ../data/liteblock
# All work done!
cd ..
if [ "$1" != "nopush" ] ; then
	git stage -A
	git commit -m "Automated updater task."
	git push
fi
exit
