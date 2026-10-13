# Webmin Kea DHCP v1.0.0

First stable release of the enhanced local Kea DHCP module for Webmin, based on upstream Webmin 2.670.

## Highlights

- DHCPv4-focused management UI
- Live lease retrieval through the Kea control socket (`lease4-get-all`)
- Runtime Overview, Active leases, Inactive dynamic, Reserved addresses, and Free addresses views
- Numeric IPv4 sorting
- Reservation-aware hostname and lease classification
- Passive presence detection using `ip neigh`
- Optional ASUS client metadata integration
- Reproducible patch-based build from the official Webmin 2.670 source
- Automatic Webmin-aware Perl syntax checks
- Safe installer with timestamped backup, service health check, and rollback

## Validation

The v1.0.0 patch set was applied cleanly to Webmin 2.670, syntax-checked, installed on the production proxy LXC, and verified through the Webmin browser UI.

## Installation

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

See `CHANGELOG.md` and `docs/CUSTOMIZATIONS.md` for details.
