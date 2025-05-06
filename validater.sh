#!/bin/bash
ls -1 | while IFS= read -r list ; do
	destList="../intermediate/${list/.list/}"
	echo "Now validating list: $list"
	echo "# Generated and sanitized by the Validater." > "$destList"
	lineNo=0
	cat "$list" | while IFS= read -r rule ; do
		let lineNo=lineNo+1
		if [[ "$rule" == " "* ]]; then
			echo "Rule skipped due to prepended whitespace on line $lineNo."
		elif [[ "$rule" == "\t"* ]]; then
			echo "Rule skipped due to prepended tabs on line $lineNo."
		elif [ "$rule" == "" ]; then
			echo "Blank line ignored on line $lineNo."
		elif [[ "$rule" == ":"* ]]; then
			echo "Redundant rule ignored on line $lineNo."
		elif [[ "$rule" == "#"* ]]; then
			echo "Comment skipped on line $lineNo."
		elif [[ "$rule" == "["* ]]; then
			echo "Comment skipped on line $lineNo."
		elif [[ "$rule" == "!"* ]]; then
			echo "Comment skipped on line $lineNo."
		elif [[ "$rule" == "||"* ]]; then
			interm="${rule/||/domain:}"
			echo "${interm/^/}" >> "$destList"
		elif [[ "$rule" != "domain:"* ]]; then
			echo "domain:$rule" >> "$destList"
		else
			echo "$rule" >> "$destList"
		fi
	done
	sed -i "s/domain:\*\./domain:/g" "$destList"
done
exit
