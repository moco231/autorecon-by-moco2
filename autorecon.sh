#!/bin/bash

# This script will get a domain name and should output a list of subdomains




echo  "enter a valid domain url to enumerate here:"
read inurl

if [[ $inurl =~ \.(com|net|org|co\.il)$ ]] && [ ! -d "$inurl" ]; then
    echo "$inurl is valid. Creating directory."
    mkdir "$inurl"

else 
	echo "$inurl is not a valid input."
	exit 1
fi


if [ ! -d "$inurl/recon" ]; then
	echo creating recon directory for $inurl 
        mkdir $inurl/recon 
fi


if command -v sublist3r >/dev/null 2>&1; then 
	echo "Sublist3r is installed."
else
	echo "Sublist3r is not installed. Please install it to use this script"
	exit 1
fi

if ! command -v assetfinder >/dev/null 2>&1; then 
    echo "Assetfinder is not installed. Please install it to use this script"
    exit 1
fi
cd $inurl/recon

echo "Starting  to passivly enumerate Subdomains for $inurl with Sublist3r..."
sublist3r -d $inurl -o  sublist3r.txt > /dev/null
echo "done!"

echo  "Starting to passivly enumerate Subdomains for $inurl with Amass..."
amass enum -d $inurl >> Amass.txt
echo "done!"

echo " Starting to passivly enumaerate for $inurl with Assetfinder..."
assetfinder --subs-only $inurl >> assetfinder.txt
echo "job done!"


cat sublist3r.txt Amass.txt assetfinder.txt | sort -u > subdomains.txt

echo "Do you want to start the probing process? (y/n)"
read inprobe

if [ "$inprobe" = "y" ]; then
    echo "Probing process begins. Please wait..."
    cat subdomains.txt | httprobe | sort |  uniq >>  httprobe.txt
    cat httprobe.txt
else
    echo "Exiting program."
    exit 1
fi
