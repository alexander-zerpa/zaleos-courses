#!/usr/bin/env bash

if [ ! -z $1 ]; then
	STATUS=0
	echo "watching $1"
	while [ $STATUS -eq 0 ]; do
		ps $1 > /dev/null
		STATUS=$?
	done
	echo "done"
fi

exit 0
