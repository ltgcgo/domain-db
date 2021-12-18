#!/bin/bash
if [ "$1" != "" ] ; then
	rm "$1.hosts"
	cat "$1" | while IFS= read -r ruleText ; do
		if [[ "$ruleText" == "domain:"* ]] ; then
			echo "${ruleText/domain:/0.0.0.0 }" >> "$1.hosts"
			echo "0.0.0.0 www.${ruleText/domain:/}" >> "$1.hosts"
		elif [[ "$ruleText" == "#"* ]]; then
			echo "Comment skipped."
		else
			echo "0.0.0.0 $ruleText" >> "$1.hosts"
		fi
	done
fi
exit
