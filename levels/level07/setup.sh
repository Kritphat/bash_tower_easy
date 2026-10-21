#!/bin/bash
# Floor 12: find a private key, fix its permissions, log in with it
set -euo pipefail
. /root/build/tower/lib.sh

root=/opt/stronghold
items=("A stack of 12 bookshelves." "Three iron ingots." "An enchanted book (Mending)."
       "Two ender pearls." "A rusty iron pickaxe." "Some rotten flesh."
       "A golden apple." "Cobwebs. Only cobwebs." "A loaf of bread."
       "-----BEGIN BROKEN EYE-----\nThis eye shattered a long time ago.\n-----END BROKEN EYE-----")

n=0
for room in library prison fountain_room storeroom corridor portal_room; do
    for chest in 1 2 3 4 5; do
        mkdir -p "$root/$room/chest_$chest"
        printf '%b\n' "${items[$((n % ${#items[@]}))]}" > "$root/$room/chest_$chest/item"
        n=$((n + 1))
    done
done
chown -R root:"$LEVEL_USER" "$root"
chmod -R u=rwX,g=rX,o= "$root"

#The Eye of Ender replaces one random item. 644 is too open for ssh on purpose.
eye=$(find "$root" -name item | shuf -n 1)
rm "$eye"
ssh-keygen -q -t ed25519 -N '' -C eye_of_ender -f "$eye"
install -d -o root -g "$NEXT_USER" -m 750 "/home/$NEXT_USER/.ssh"
install -o root -g "$NEXT_USER" -m 640 "$eye.pub" "/home/$NEXT_USER/.ssh/authorized_keys"
rm "$eye.pub"
chown "$LEVEL_USER":"$LEVEL_USER" "$eye"
chmod 644 "$eye"

#ssh wants to remember the host it connects to
install -d -o "$LEVEL_USER" -g "$LEVEL_USER" -m 700 "$LEVEL_HOME/.ssh"
