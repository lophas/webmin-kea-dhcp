#!/bin/sh
set -eu

UPSTREAM_TAG=${UPSTREAM_TAG:-2.670}
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WORK=${BUILD_ROOT:-"$ROOT/build"}
ARCHIVE="$WORK/webmin-$UPSTREAM_TAG.tar.gz"
SRC="$WORK/src"
OUT="$WORK/kea-dhcp"
URL="https://github.com/webmin/webmin/archive/refs/tags/$UPSTREAM_TAG.tar.gz"

rm -rf "$WORK"
mkdir -p "$WORK" "$SRC"

if command -v curl >/dev/null 2>&1; then
  curl -fL --retry 3 -o "$ARCHIVE" "$URL"
elif command -v wget >/dev/null 2>&1; then
  wget -O "$ARCHIVE" "$URL"
else
  echo "curl or wget is required" >&2
  exit 1
fi

tar -xzf "$ARCHIVE" -C "$SRC"
TOP=$(find "$SRC" -mindepth 1 -maxdepth 1 -type d -name 'webmin-*' | head -n 1)
[ -n "$TOP" ] || { echo "Unable to locate extracted Webmin source" >&2; exit 1; }
[ -d "$TOP/kea-dhcp" ] || { echo "kea-dhcp module is missing in Webmin $UPSTREAM_TAG" >&2; exit 1; }

cp -a "$TOP/kea-dhcp" "$OUT"

for p in "$ROOT"/patches/*.patch; do
  [ -f "$p" ] || continue
  echo "Applying $(basename "$p")"
  patch -d "$WORK" -p1 --forward --batch < "$p"
done

echo "Built: $OUT"
