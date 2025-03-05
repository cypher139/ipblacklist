#!/bin/bash
BUILDVER=0.02.1
GIT_PATH=/home/Git/ipblacklist

useDate=$(date +%b/%d)
msgAdd=""
msgDiff=""
msgSeparator=""
#
#Commit message
cd $GIT_PATH
ipCount=$(cat block.txt 2>/dev/null | sed -n '$=')
lastipCount=$ipCount
if [[ -f lastipcount.txt ]]; then
	lastipCount=$(cat lastipcount.txt)
else
	echo "$ipCount" > lastipcount.txt
fi

if [[ $lastipCount -lt $ipCount ]]; then
	msgDiff=$(($ipCount - $lastipCount))
	msgAdd="Add $msgDiff IPs"
	if [[ $msgDiff -eq 1 ]]; then
		echo "Only one IP Added, skipping upload today"
		exit
	fi
elif [[ $lastipCount -eq $ipCount ]]; then
	msgAdd="Updates"
elif [[ $lastipCount -gt $ipCount ]]; then
	msgDiff=$(($lastipCount - $ipCount))
	msgAdd="Remove $msgDiff IPs"
fi
commitMessage="[$useDate] $msgAdd"
#
GitUpload()
{
	cd $GIT_PATH
	git add .
	git commit -m "$commitMessage"
	git push origin main
	echo "$ipCount" > lastipcount.txt
}
GitPull()
{
	cd $GIT_PATH
	git pull
}
Help()
{
    echo "Help:"
    echo "Build: $BUILDVER    |    OS: $OSTYPE"  
    echo "Options:"
    echo "p     Run git pull first."
    echo "d     Show Date"
    echo "m     Compute Git commit message"
}

while getopts ":hmdp" option; do
    case $option in
        p) #Pull
         GitPull
         exit;;
        d) #Show date
         echo $useDate
         exit;;
		m) #Show commit message
         echo -e "\033[1;32m$commitMessage\033[0m"
         exit;;
        h) 
         Help
         exit;;
        \?) # Invalid option
         echo -e "\033[1;33mOption not recognized\033[0m"
         exit;;
    esac
done

GitUpload