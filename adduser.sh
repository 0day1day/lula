#!/bin/bash

adduser --home /home/incoming/$1 $1
addgroup $1 ftp-only
ln /home/incoming/readme.txt /home/incoming/$1/readme.txt
mkdir /home/incoming/$1/incoming
chown root: /home/incoming/$1
chown $1: /home/incoming/$1/incoming
