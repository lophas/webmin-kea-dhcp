# Webmin Kea DHCP — local enhanced edition

A locally maintained variant of Webmin's official `kea-dhcp` module, based on
Webmin **2.670**, with operational enhancements for a DHCPv4-focused home/LAN
installation.

## Upstream

- Project: `webmin/webmin`
- Module: `kea-dhcp`
- Baseline: Webmin tag `2.670`
- Upstream module was introduced in Webmin 2.650.

This repository retains the upstream BSD-3-Clause license.

## Local enhancements

The current branch adds:

- DHCPv4-focused module index (DHCPv6 and DHCP-DDNS tabs hidden from the main UI)
- Numeric IPv4 sorting for reservations and runtime tables
- Runtime overview combining leases and configured reservations
- Separate views for active, inactive dynamic, reserved, and free addresses
- Reserved/dynamic lease classification
- Free-address calculation from configured DHCPv4 pools
- Passive client-presence indication using the kernel neighbor table (`ip neigh`)
- Optional ASUS client metadata from `/etc/webmin/kea-dhcp/asus-clients.json`
- Reservation hostname priority over DHCP-supplied and ASUS-discovered names
- Direct live lease retrieval from the running Kea DHCPv4 server using the
  control socket and the `lease4-get-all` command, instead of treating the
  append-oriented memfile CSV as authoritative runtime state
- Current-lease de-duplication / activity handling for legacy lease data paths

See [`docs/CUSTOMIZATIONS.md`](docs/CUSTOMIZATIONS.md) for details.

## Installation

Run as root on the Webmin host:

```bash
./scripts/install.sh
```

The installer backs up the currently installed module before replacing it.
It does **not** modify `/etc/webmin/kea-dhcp/` or the Kea daemon configuration.

## Local metadata

ASUS metadata, when used, is expected in:

```text
/etc/webmin/kea-dhcp/asus-clients.json
```

This machine-specific file is deliberately not part of the repository.

## Maintenance model

Treat `webmin/webmin` as upstream. When Webmin changes the official `kea-dhcp`
module, compare the new upstream version with this repository, rebase/merge the
local changes, test, and then deploy with `scripts/install.sh`.
