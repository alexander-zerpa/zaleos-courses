#!/usr/bin/env bash

COMPUTER=34

echo $(date)

while [ ! $CORRECT ]; do
	read -p "Guess number: " NUM
	if [ $NUM -gt $COMPUTER ]; then
		echo "To high"
		continue
	elif [ $NUM -lt $COMPUTER ]; then
		echo "To low"
		continue
	fi
	CORRECT=0
done
echo "You won!"

exit 0
