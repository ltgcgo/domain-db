# Domain list database

This project was pulled and forked from `v2fly/domain-list-community`, with only its data changed to use several blocklists.

This project does not need to appear to be maintained, as almost every update is conducted automatically without need of manual intervention. The blocklists are built twice a week.

## Purpose of this project

Make your *ray instance a powerful adblocker, either on servers or on clients.

Build status: [![Build dlc.dat](https://github.com/ltgcgo/domain-db/actions/workflows/build.yml/badge.svg)](https://github.com/ltgcgo/domain-db/releases/latest/download/dlc.dat) (Click to download!)

## Download links

- **dlc.dat**：[GitHub Releases](https://github.com/ltgcgo/domain-db/releases/latest/download/dlc.dat)
- **dlc.dat.sha256sum**：[GitHub Releases](https://github.com/ltgcgo/domain-db/releases/latest/download/dlc.dat.sha256sum)

## Usage example

Each file in the `data` directory can be used as a rule in this format: `geosite:filename`.

```json
"routing": {
  "domainStrategy": "IPIfNonMatch",
  "rules": [
    {
      "type": "field",
      "outboundTag": "Reject",
      "domain": [
        "geosite:category-ads-all",
        "geosite:category-porn"
      ]
    },
    {
      "type": "field",
      "outboundTag": "Direct",
      "domain": [
        "domain:icloud.com",
        "domain:icloud-content.com",
        "domain:cdn-apple.com",
        "geosite:cn",
        "geosite:private"
      ]
    },
    {
      "type": "field",
      "outboundTag": "Proxy-1",
      "domain": [
        "geosite:category-anticensorship",
        "geosite:category-media",
        "geosite:category-vpnservices"
      ]
    },
    {
      "type": "field",
      "outboundTag": "Proxy-2",
      "domain": [
        "geosite:category-dev"
      ]
    },
    {
      "type": "field",
      "outboundTag": "Proxy-3",
      "domain": [
        "geosite:geolocation-!cn"
      ]
    }
  ]
}
```

## Generate `dlc.dat` manually

- Install `golang` and `git`
- Clone project code: `git clone https://github.com/ltgcgo/domain-db.git`
- Navigate to project root directory: `cd domain-db`
- Install project dependencies: `go mod download`
- Generate `dlc.dat` (without `datapath` option means to use domain lists in `data` directory of current working directory):
  - `go run ./`
  - `go run ./ --datapath=/path/to/your/custom/data/directory`

Run `go run ./ --help` for more usage information.

## Structure of data

All data are under `data` directory. Each file in the directory represents a sub-list of domains, named by the file name. File content is in the following format.

```
# comments
include:another-file
domain:google.com @attr1 @attr2
keyword:google
regexp:www\.google\.com$
full:www.google.com
```

**Syntax:**

> The following types of rules are **NOT** fully compatible with the ones that defined by user in V2Ray config file. Do **Not** copy and paste directly.

* Comment begins with `#`. It may begin anywhere in the file. The content in the line after `#` is treated as comment and ignored in production.
* Inclusion begins with `include:`, followed by the file name of an existing file in the same directory.
* Subdomain begins with `domain:`, followed by a valid domain name. The prefix `domain:` may be omitted.
* Keyword begins with `keyword:`, followed by a string.
* Regular expression begins with `regexp:`, followed by a valid regular expression (per Golang's standard).
* Full domain begins with `full:`, followed by a complete and valid domain name.
* Domains (including `domain`, `keyword`, `regexp` and `full`) may have one or more attributes. Each attribute begins with `@` and followed by the name of the attribute.

## How it works

The entire `data` directory will be built into an external `geosite` file for Project V. Each file in the directory represents a section in the generated file.

To generate a section:

1. Remove all the comments in the file.
2. Replace `include:` lines with the actual content of the file.
3. Omit all empty lines.
4. Generate each `domain:` line into a [sub-domain routing rule](https://github.com/v2fly/v2ray-core/blob/master/app/router/config.proto#L21).
5. Generate each `keyword:` line into a [plain domain routing rule](https://github.com/v2fly/v2ray-core/blob/master/app/router/config.proto#L17).
6. Generate each `regexp:` line into a [regex domain routing rule](https://github.com/v2fly/v2ray-core/blob/master/app/router/config.proto#L19).
7. Generate each `full:` line into a [full domain routing rule](https://github.com/v2fly/v2ray-core/blob/master/app/router/config.proto#L23).

## How to organize domains

### File name

Theoretically any string can be used as the name, as long as it is a valid file name. In practice, we prefer names for determinic group of domains, such as the owner (usually a company name) of the domains, e.g., "google", "netflix". Names with unclear scope are generally unrecommended, such as "evil", or "local".

### Attributes

Attribute is useful for sub-group of domains, especially for filtering purpose. For example, the list of `google` domains may contains its main domains, as well as domains that serve ads. The ads domains may be marked by attribute `@ads`, and can be used as `geosite:google@ads` in V2Ray routing.

## Contribution guideline

* Fork this repo, make modifications to your own repo, file a PR.
* Please begin with small size PRs, say modification in a single file.
* A PR must be reviewed and approved by another member.
* After a few successful PRs, you may apply for manager access to this repository.
