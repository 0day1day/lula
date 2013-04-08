#!/bin/bash

source lula.conf

for i in "$internal_preparing_dir"; do
	type=$(file "$i" | sed 's/.*: //')
	sha1=$(sha1sum "$file")

	if $virustotal_query; then
		./vt-query $sha1
	fi

	if [ "$type" =~ "PE32" ]; then
		pescan "$i"
	fi
done

exit

./save.sh
