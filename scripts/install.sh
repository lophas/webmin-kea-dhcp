#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEST=${WEBMIN_KEA_DIR:-/usr/share/webmin/kea-dhcp}
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP=${WEBMIN_KEA_BACKUP:-/root/kea-dhcp-backup-$STAMP.tar.gz}
PARENT=$(dirname "$DEST")
NAME=$(basename "$DEST")

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this installer as root." >&2
  exit 1
fi

"$ROOT/scripts/build.sh"
SRC="$ROOT/build/kea-dhcp"

if [ -d "$DEST" ]; then
  echo "Backing up $DEST to $BACKUP"
  tar -C "$PARENT" -czf "$BACKUP" "$NAME"
fi

rm -rf "$DEST"
mkdir -p "$DEST"
cp -a "$SRC"/. "$DEST"/
chown -R root:root "$DEST"
find "$DEST" -type d -exec chmod go-w {} +
find "$DEST" -type f -exec chmod go-w {} +

restart_webmin()
{
  if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files webmin.service >/dev/null 2>&1; then
    systemctl restart webmin
    systemctl is-active --quiet webmin
  elif [ -x /etc/webmin/restart ]; then
    /etc/webmin/restart
  fi
}

if ! restart_webmin; then
  echo "Webmin restart failed; restoring previous module from $BACKUP" >&2
  rm -rf "$DEST"
  if [ -f "$BACKUP" ]; then
    tar -C "$PARENT" -xzf "$BACKUP"
    restart_webmin || true
  fi
  exit 1
fi

echo "Installed $DEST"
echo "Backup: $BACKUP"
