#!/bin/bash

source lula.conf

empty=false
>"$temporary_database_file"

echo '[+] removing old compressed files...'
cd "$internal_preparing_dir"
rm -f *.zip *.tar *.tgz *.gz *.rar
find . -type d ! -name '.' -exec rm -rf {} +; 2>&-
cd ..

for i in $internal_preparing_dir/*; do
	sha=$(sha1sum "$i" | cut -d' ' -f1)

	if grep -qF "$sha" "$database_file"; then
		rm "$i"
		continue
	fi

	if ! ls $internal_preparing_dir/* > /dev/null; then
		empty=true
		break;
	fi

	report=$internal_reports_dir/$sha.txt

	echo -e "basic\n---" > "$report"

	(echo -n "$(date),$sha,$(basename "$i"),"
	wc -c "$i" | cut -d' ' -f1) | tee -a "$database_file" \
	"$temporary_database_file" "$report" >/dev/null

	type=$(file "$i" | sed 's/.*: //')
	echo "$type" >> "$report"

	if [[ "$type" =~ 'PE32' ]]; then
		(echo -e "\npescan\n---"
		pescan -v "$i") >> "$report"
	fi

	if $virustotal_query; then
		(echo -e "\nvirustotal\n---"
		./vt-query.sh $sha | column -t) >> "$report"
	fi

done

if ! ls $internal_preparing_dir/* > /dev/null 2>&1; then
	echo all new samples are known files
	exit
fi

echo '[+] creating submission zip package...'
zip -jP virus $internal_processing_dir/samples-$(date "+%Y%m%d-%H%M-$RANDOM").zip $internal_preparing_dir/*
rm -rf $internal_preparing_dir/*

./provide.sh
