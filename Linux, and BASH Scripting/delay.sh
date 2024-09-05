#!/usr/bin/env bash

if [ ! -z $1 ]; then
	echo "sleeping $1 seconds"
	sleep $1
	echo "awake"
fi

exit 0
