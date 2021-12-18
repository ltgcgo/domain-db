#!/bin/bash
if [ "$1" != "" ] ; then
	rm "$1.zone"
	cat "$1" | while IFS= read -r ruleText ; do
		if [[ "$ruleText" == "domain:"* ]] ; then
			echo "${ruleText/domain:/template IN ANY } {" >> "$1.zone"
			echo -e "\trcode NXDOMAIN" >> "$1.zone"
			echo -e "\tauthority \"{{ .Zone }} 60 IN SOA ns.localhost ns2.localhost (1 60 60 60 60)\"" >> "$1.zone"
			echo -e "\tfallthrough" >> "$1.zone"
			echo -e "}" >> "$1.zone"
		else
			echo "Line ${ruleText} skipped."
		fi
	done
fi
exit
