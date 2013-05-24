#!/bin/bash

if pgrep chromium > /dev/null 2>&1
then
	echo "Runing"
else
	echo "Stopped"
fi