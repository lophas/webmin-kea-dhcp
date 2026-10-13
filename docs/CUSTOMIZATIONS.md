# Local customizations

## Upstream baseline

The current patch series is based on the official Webmin `kea-dhcp` module from tag `2.670`.

The original module remains the source of truth for all unchanged functionality. Only locally maintained behavior is represented by the patches in `patches/`.

## Modified files

### `index.cgi`

- Main UI is DHCPv4-focused.
- DHCPv6 and DHCP-DDNS tabs are hidden from the normal module index.
- Service overview is limited to the DHCPv4 component.

### `edit_subnet.cgi`

- DHCPv4 reservations are displayed in numeric IPv4 order without rewriting their underlying Kea configuration order.

### `runtime.cgi`

Adds the operational views used on the local network:

- Overview
- Active leases
- Inactive dynamic leases
- Reserved addresses
- Free addresses
- Pool usage
- Statistics
- Logs

The overview merges live lease state with configured reservations, distinguishes dynamic/reserved addresses, adds presence information, and enriches hostnames/device metadata when local discovery data is available.

### `kea-dhcp-lib.pl`

- Live DHCPv4 lease retrieval via the Kea UNIX control socket using `lease4-get-all`.
- Current/inactive lease handling and de-duplication.
- Reservation mapping helpers.
- Numeric IPv4 comparison helpers used by runtime views.
- Passive presence lookup using the kernel neighbour table.
- Optional ASUS client metadata support.
- Hostname selection and device/vendor helpers.

### `module.info`

Adds explicit local module version/dependency values for Webmin 2.670.

## External state deliberately excluded

The repository does not contain machine-specific configuration or discovery state, including:

- `/etc/kea/kea-dhcp4.conf`
- `/etc/webmin/kea-dhcp/`
- `/etc/webmin/kea-dhcp/asus-clients.json`
- lease databases
- Webmin ACL/user configuration

## Upstream upgrade workflow

1. Change `UPSTREAM_TAG` in `scripts/build.sh` or override it in the environment.
2. Run `./scripts/build.sh`.
3. If patches apply cleanly, inspect the upstream changes and test the built module.
4. If a patch fails, rebase that customization against the new upstream file instead of forcing the patch.
5. Update the baseline documented here and commit the refreshed patches.
6. Deploy with `./scripts/install.sh`.
