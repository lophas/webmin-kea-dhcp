#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEST=${WEBMIN_KEA_DIR:-/usr/share/webmin/kea-dhcp}
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP=${WEBMIN_KEA_BACKUP:-/root/kea-dhcp-backup-$STAMP.tar.gz}

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this installer as root." >&2
  exit 1
fi

"$ROOT/scripts/build.sh"
SRC="$ROOT/build/kea-dhcp"

if [ -d "$DEST" ]; then
  echo "Backing up $DEST to $BACKUP"
  tar -C "$(dirname "$DEST")" -czf "$BACKUP" "$(basename "$DEST")"
fi

rm -rf "$DEST"
mkdir -p "$DEST"
cp -a "$SRC"/. "$DEST"/
chown -R root:root "$DEST"

if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files webmin.service >/dev/null 2>&1; then
  systemctl restart webmin
elif [ -x /etc/webmin/restart ]; then
  /etc/webmin/restart
fi

echo "Installed $DEST"
echo "Backup: $BACKUP"
