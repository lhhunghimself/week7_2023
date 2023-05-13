#!/bin/bash

set -e

#get the csrf tokent
csrf_token=$(curl -c cookies.txt http://localhost/login | grep csrf_token | sed 's/.*value="\([^"]*\)".*/\1/')

#get login endpoint with correct credentials
page_name=$(curl -b cookies.txt -X POST -d "email=lhhung@uw.edu&password=qwerty&csrf_token=${csrf_token}" http://localhost/login | sed -n 's:.*<title>\(.*\)<\/title>.*:\1:p')

if [ "$page_name" != "Redirecting..." ]; then
    echo "$page_name is not Redirecting..."
    echo "Login endpoint failed with correct credentials"
    exit 1
fi
#get login endpoint with correct credentials
page_name=$(curl -b cookies.txt -X POST -d "email=wrong@uw.edu&password=qwerty&csrf_token=${csrf_token}" http://localhost/login | sed -n 's:.*<title>\(.*\)<\/title>.*:\1:p')

if [ "$page_name" != "Login" ]; then
    echo "Login endpoint failed with incorrect credentials"
    exit 1
fi
echo "Login endpoint passed with both correct and incorrect credentials"
