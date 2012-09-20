



#!/bin/sh
# With a little automator workflow, quicksilver magic, and a judicious
# placement of pbpaste on the next line you can paste with almost no effort at
# all.
url=$(curl http://pastie.caboo.se/pastes/create \
    -H "Expect:" \
    -F "paste[parser]=plaintext" \
    -F "paste[body]=<-" \
    -s -L -o /dev/null -w "%{url_effective}")

echo -n "$url" | pbcopy
echo "$url"
