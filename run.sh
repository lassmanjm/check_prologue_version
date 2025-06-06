#!/bin/bash

source ~/.bash_aliases
source ~/bash_profile/functions/discord.sh


wanted_version=4
log=""

while getopts "v:l" flag; do
case "${flag}" in
  v)
    wanted_version=$OPTARG
    ;;
  l)
    log=true
    ;;
  \?)
    echo "Invalid flag option: $OPTIND. Valid flags: { [-v version] | [-l log] }"
    exit
    ;;
esac
done
shift $((OPTIND - 1))


prologue_url="https://apps.apple.com/us/app/prologue/id1459223267"
search_results=$(curl -s "https://www.apple.com/us/search/prologue\?src\=serp")
if [[ $search_results =~ https://apps.apple.com/us/app/prologue/id[0-9]+ ]]; then
    prologue_url="${BASH_REMATCH[0]}"
fi

fail_email_subject="Prologue version not found"
prologue_scrape=$(curl -s "$prologue_url")
if [[ -z $prologue_scrape ]]; then
    echo "Subject: $fail_email_subject"$'\n\n'"Unable to scrape prologue url: $prologue_url" \
        | msmtp  josh
    exit 1
fi
if [[ $prologue_scrape =~ Version\ (([0-9]).[0-9].[0-9]) ]]; then
    full_version="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[2]}"
fi

if [[ -z $version ]]; then
    echo "Subject: $fail_email_subject"$'\n\n'"Could not find version in page: $prologue_url" \
        | msmtp  josh
    exit 1
fi
if [[ $version -ge $wanted_version ]]; then
    subject="Prologue Version update!"
    content="Prologue has been updated to version $full_version: $prologue_url"
    echo "Subject: $subject"$'\n\n'"$content" \
        | msmtp  josh
    discord -c "green" -d "$content" "$subject"
fi

if [[ -n $log ]]; then
    date +"%Y-%m-%d Version: $full_version" >> /tmp/logs/check_prologue_version.log
fi


