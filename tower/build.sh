#!/bin/bash
# Runs once inside the image at build time:
# creates locstd00 - locstd08 and builds every floor.
set -euo pipefail

BUILD=/root/build
set -a
. "$BUILD/passwords.env"
set +a

#Non-player character
useradd -r -s /usr/sbin/nologin herobrine

for n in $(seq -f '%02g' 0 8); do
    user=locstd$n
    pass_var=PASS$n
    useradd -m -s /bin/bash "$user"
    echo "$user:${!pass_var}" | chpasswd
    #Read-only home: owned by root, readable by the player only
    chown -R root:"$user" "/home/$user"
    chmod 750 "/home/$user"
done

for n in $(seq -f '%02g' 0 8); do
    next=$(printf '%02d' $((10#$n + 1)))
    next_var=PASS$next
    export LEVEL=$n
    export LEVEL_USER=locstd$n
    export LEVEL_HOME=/home/locstd$n
    export NEXT_USER=locstd$next
    export NEXT_PASS=${!next_var:-}
    export CHALLENGE=$BUILD/levels/level$n/challenge

    install -o root -g "$LEVEL_USER" -m 440 "$CHALLENGE/README" "$LEVEL_HOME/README"
    bash "$BUILD/levels/level$n/setup.sh"
done
