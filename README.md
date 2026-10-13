# Webmin Kea DHCP — enhanced local edition

Local enhancements for Webmin's official `kea-dhcp` module.

This repository deliberately tracks the local changes as a small patch set on top of the official Webmin module instead of vendoring the whole Webmin source tree. This makes upstream updates auditable: bump the Webmin tag, rebuild, resolve any patch conflicts, test, and deploy.

## Baseline

- Upstream: `webmin/webmin`
- Module: `kea-dhcp`
- Current baseline: Webmin `2.670`
- License: BSD-3-Clause (same as Webmin)

## Local enhancements

- DHCPv4-focused main UI
- Numeric IPv4 ordering for reservations and runtime tables
- Runtime overview joining leases and configured reservations
- Active, inactive dynamic, reserved and free-address views
- Reserved/dynamic lease classification
- Free-address calculation from configured pools
- Passive client-presence state using `ip neigh`
- Optional ASUS client metadata from `/etc/webmin/kea-dhcp/asus-clients.json`
- Reservation hostname priority over DHCP/ASUS-discovered names
- Live DHCPv4 lease retrieval through the Kea control socket (`lease4-get-all`)
- Lease de-duplication/activity handling for legacy memfile data paths

See [`docs/CUSTOMIZATIONS.md`](docs/CUSTOMIZATIONS.md) for details.

## Build

```bash
./scripts/build.sh
```

This downloads the configured upstream Webmin tag, extracts only `kea-dhcp`, and applies the local patch series. The result is written to `build/kea-dhcp`.

To use another upstream tag for a compatibility test:

```bash
UPSTREAM_TAG=2.680 ./scripts/build.sh
```

If a patch no longer applies, the build stops rather than silently producing a mixed module.

## Install / update

Run on the Webmin host as root:

```bash
git clone https://github.com/lophas/webmin-kea-dhcp.git /opt/webmin-kea-dhcp
cd /opt/webmin-kea-dhcp
./scripts/install.sh
```

For subsequent updates:

```bash
cd /opt/webmin-kea-dhcp
git pull --ff-only
./scripts/install.sh
```

The installer creates a timestamped backup of the currently installed module before replacing it. It does not modify `/etc/webmin/kea-dhcp/` or `/etc/kea/`.

## Machine-specific metadata

Optional ASUS metadata is read at runtime from:

```text
/etc/webmin/kea-dhcp/asus-clients.json
```

That file is intentionally not stored in Git.
