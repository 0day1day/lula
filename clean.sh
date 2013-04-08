#!/bin/bash

rm -rf preparing/* processing/* db.csv temp/db_temp.csv

[ "$1" = "--full" ] && rm -rf ready/* store/* reports/* 
