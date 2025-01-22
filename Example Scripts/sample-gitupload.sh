#!/bin/bash

GIT_PATH=/home/Git/ipblacklist

useDate=$(date +%b/%d)

#echo $useDate

GitUpload()
{
	cd $GIT_PATH
	git add .
	git commit -m "[$useDate] Add/Update IPs"
	git push origin main
}
GitUpload