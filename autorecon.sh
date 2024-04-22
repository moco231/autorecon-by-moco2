#!/bin/bash

# This script will get a domain name and should output a list of subdomains




echo  "enter a valid domain url to enumerate here:"
read inurl

if [[ $inurl =~ \.(com|net|org|co\.il)$ ]] && [ ! -d "$inurl" ]; then
    echo "$inurl is valid. Creating directory."
    mkdir "$inurl"

else 
	echo "$inurl is not a valid input."
fi


if [ ! -d "$inurl/recon" ]; then
	echo creating recon directory for $inurl 
        mkdir $inurl/recon 
fi


if command -v sublist3r >/dev/null 2>&1; then 
	echo "Sublist3r is installed."
else
	echo "Sublist3r is not installed. Please install it to use this script"
	exit
fi

cd $inurl/recon

echo "Starting  to passivly enumerate Subdomains for $inurl"
sublist3r -d $inurl -o  temp_subdomains.txt > /dev/null
echo "done!"

cat temp_subdomains.txt | sort | uniq >> subdomains
echo "Subdomains saved to subdomains.txt"
