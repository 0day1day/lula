#!/bin/bash

source lula.conf

adduser --home "$ftp_incoming_dir"/$1 $1
addgroup $1 $ftp_group
ln "$ftp_incoming_dir"/readme.txt "$ftp_incoming_dir"/$1/readme.txt
mkdir "$ftp_incoming_dir"/$1/incoming
chown root: "$ftp_incoming_dir"/$1
chown $1: "$ftp_incoming_dir"/$1/incoming
