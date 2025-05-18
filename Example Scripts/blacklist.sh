#!/bin/bash

ADDED_IPS=()
ERROR_IPS=()
SKIPPED=0
BLOCK_PATH=block.txt
BLOCKED_PATH=blocked.txt
EXIST_IPS=()
timestamp() { echo "$(printf '%(%F %T)T')"; }
containsElement () { for e in "${@:2}"; do [[ "$e" = "$1" ]] && return 0; done; return 1; }

echo "$(timestamp) Starting blacklist rule insertions..."
# Load previously added IPs
while read line; do
	EXIST_IPS+=("$line")
done < $BLOCKED_PATH
# echo "${#EXIST_IPS[@]} ${EXIST_IPS[*]}"
# Process IPs
while read line; do
	if containsElement "$line" "${EXIST_IPS[@]}"; then
		# echo "Bash skipped $line"
		((SKIPPED++))
		continue
	fi
	CMD_STATUS=$(/usr/sbin/ufw insert 1 deny from "$line" to any 2>&1);
	if [[ $CMD_STATUS == "Skipping inserting existing rule" ]]; then
		((SKIPPED++))
		# echo "ufw skipped $line"
		echo "$line" >> $BLOCKED_PATH
	elif [[ $CMD_STATUS == "Rule inserted" || $CMD_STATUS == "Rules updated" ]]; then
		# echo -e "\033[1;36m Added $line \033[0m"
		# echo " Added $line"
		ADDED_IPS+=("$line")
		echo "$line" >> $BLOCKED_PATH
	elif [[ $CMD_STATUS == "ERROR: Bad source address" ]]; then
		ERROR_IPS+=("$line")
	elif [[ $CMD_STATUS == "ERROR: Invalid position '1'" ]]; then
		#ufw can't insert rules if no rules are present. Add a dummy rule to continue.
		CMD_STATUS=$(/usr/sbin/ufw deny from "$line" to any 2>&1);
	fi
done < $BLOCK_PATH
# Results:
if [[ $SKIPPED != 0 ]]; then
	echo $SKIPPED IPs were already present, skipping.
fi
if (( ${#ADDED_IPS[@]} )); then
	# echo Added ${#ADDED_IPS[@]} IPs: ${ADDED_IPS[*]}
	echo Added ${#ADDED_IPS[@]} IPs.
fi
if (( ${#ERROR_IPS[@]} )); then
	echo ${#ERROR_IPS[@]} IPs have a parsing error: "${ERROR_IPS[*]}"
fi
echo "$(timestamp) Blacklist rule insertions completed."