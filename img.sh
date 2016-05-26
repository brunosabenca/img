#!/bin/bash
# https://github.com/Ceryn/img
# Call with '-s' to target only a selection of the screen.

clientid='3e7a4deb7ac67da'
img=$(mktemp '/tmp/img-XXXXXX.png')

maim "$@" $img >/dev/null 2>&1 || exit
res=$(curl -sH "Authorization: Client-ID $clientid" -F "image=@$img" "https://api.imgur.com/3/upload")

echo $res | grep -qo '"status":200' \
&& link=$(echo $res | sed -e 's/.*"link":"\([^"]*\).*/\1/' -e 's/\\//g') \
&& delhash=$(echo $res | sed -e 's/.*"deletehash":"\([^"]*\).*/\1/' -e 's/\\//g')

test -n "$link" \
&& printf '%s %s\n' "$link https://imgur.com/delete/$deletehash" >> ~/screenshots/imgur.txt \
&& (printf $link | xclip -sel clip; printf "\a" && rm "$img") || echo "$res" > "$img.error"
