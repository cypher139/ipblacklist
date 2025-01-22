#!/bin/bash

ADDED_IPS=()
ERROR_IPS=()
SKIPPED=0
BLOCK_PATH=/home/user/block.txt

echo "Starting blacklist rule insertions..."
while read line;
do
	CMD_STATUS=`/usr/sbin/ufw insert 1 deny from $line to any 2>&1`;
	if [[ $CMD_STATUS == "Skipping inserting existing rule" ]]; then
		((SKIPPED++))
	elif [[ $CMD_STATUS == "Rule inserted" ]]; then
		# echo -e "\033[1;36m Added $line \033[0m"
		# echo " Added $line"
		ADDED_IPS+=("$line")
	elif [[ $CMD_STATUS == "ERROR: Bad source address" ]]; then
		ERROR_IPS+=("$line")
	fi
done < $BLOCK_PATH

if [[ $SKIPPED != 0 ]]; then
	echo $SKIPPED IPs were already present, skipping.
fi
if (( ${#ADDED_IPS[@]} )); then
	# echo Added ${#ADDED_IPS[@]} IPs: ${ADDED_IPS[*]}
	echo Added ${#ADDED_IPS[@]} IPs.
fi
if (( ${#ERROR_IPS[@]} )); then
	echo ${#ERROR_IPS[@]} IPs have a parsing error: ${ERROR_IPS[*]}
fi
echo "Blacklist rule insertions completed."