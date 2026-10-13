# Changelog

All notable changes to this repository are documented here.

## v1.0.0 — 2026-10-13

Initial stable release based on Webmin `2.670`.

### Added

- DHCPv4-focused Webmin UI.
- Numeric IPv4 sorting for reservations and runtime tables.
- Runtime overview combining live leases and configured reservations.
- Separate Active leases, Inactive dynamic, Reserved addresses, and Free addresses views.
- Reserved/dynamic lease classification.
- Free-address calculation from configured DHCPv4 pools.
- Passive client-presence detection using `ip neigh`.
- Optional ASUS client metadata from `/etc/webmin/kea-dhcp/asus-clients.json`.
- Reservation hostname priority over DHCP and ASUS-discovered names.
- Live DHCPv4 lease retrieval through the Kea control socket using `lease4-get-all`.
- Current lease validity handling based on `cltt + valid-lft`.
- Reproducible patch-based build on top of the official Webmin source.
- Webmin-aware Perl syntax checks during build.
- Timestamped module backup before installation.
- Webmin restart health check with automatic rollback on failure.

### Verified

- Patch set applies cleanly to Webmin `2.670`.
- Generated module was compared against the previously working local installation.
- Perl syntax checks pass for all modified Perl/CGI files.
- Repository-based installation was tested successfully on the production proxy LXC.
