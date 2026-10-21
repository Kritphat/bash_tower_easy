# Helpers shared by every levelNN/setup.sh

# Challenge files belong to root so the player cannot delete or edit them.
lock() {
    chown root:"$LEVEL_USER" "$@"
    chmod 440 "$@"
}

# rand N -> N random characters (no look-alike characters)
rand() {
    python3 -c "import secrets,sys; a='abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789'; print(''.join(secrets.choice(a) for _ in range(int(sys.argv[1]))))" "$1"
}
