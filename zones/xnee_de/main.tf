terraform {
  required_providers {
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
  }
}

# Has to be split
locals {
  dkim = "v=DKIM1; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoenazkcLnbrxXR9t99nq1\" \"kBwSCLRNsX6QztHfH8CPKLHHq9/MnR7Rcn0kVi4tUPR7fwTEaW/OctZaecP7O3bOXP9bg2FXKD+Y\" \"b/ps/iHK/ANbWJ6jH5UnJlqm7/0Tyg/g83/FG81UrFefGRMUYXbxBvM7XvvvF5aSQESW93fE1JP7\" \"INqo5n18r0zFzWGmxEtdicvrCevGRDLx46TGqJzNEPepME3PrP/Glob2Hy3Eh+3RTfFwJjR51VDG\" \"QcLSzbyI34WUOE0HUYqXLh0xI2WLXlne47e4uqAo1xO1HlVrl4T7cBlDSxiYgKnuvIgnHuBGfYhL\" \"X2wSOvPzLFC7IKIhwIDAQAB"
}

resource "hetznerdns_zone" "xnee_de" {
  name = "xnee.de"
  ttl  = 60
}

# Mail

resource "hetznerdns_record" "MX_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "@"
  value   = "10 www208.your-server.de."
  type    = "MX"
}

resource "hetznerdns_record" "TXT_default2307__domainkey_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "default2307._domainkey"
  value = join("\"", [
    "",
    replace(local.dkim, "/(.{255})/", "$1\" \""),
    " "
  ])
  type = "TXT"
}

resource "hetznerdns_record" "TXT_SPF_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "@"
  value   = "\"v=spf1 mx ~all\""
  type    = "TXT"
}

resource "hetznerdns_record" "TXT__dmarc_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "_dmarc"
  value   = "\"v=DMARC1;p=quarantine;sp=quarantine;pct=100;rua=mailto:dmarc@xnee.net;ruf=mailto:dmarc@xnee.net;adkim=s;aspf=s;\""
  type    = "TXT"
}

resource "hetznerdns_record" "SRV__autodiscover__tcp_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "_autodiscover._tcp"
  value   = "0 100 443 mail.your-server.de."
  type    = "SRV"
}

resource "hetznerdns_record" "SRV__imaps__tcp_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "_imaps._tcp"
  value   = "0 100 993 mail.your-server.de"
  type    = "SRV"
}

resource "hetznerdns_record" "SRV__pop3s__tcp_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "_pop3s._tcp"
  value   = "0 100 995 mail.your-server.de"
  type    = "SRV"
}

resource "hetznerdns_record" "SRV__submission__tcp_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "_submission._tcp"
  value   = "0 100 587 mail.your-server.de"
  type    = "SRV"
}

resource "hetznerdns_record" "CNAME_autoconfig_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "autoconfig"
  value   = "mail.your-server.de."
  type    = "CNAME"
}

# Syncthing
resource "hetznerdns_record" "A_syncthing_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "sync"
  value   = "135.181.206.213"
  type    = "A"
}

resource "hetznerdns_record" "AAAA_syncthing_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "sync"
  value   = "2a01:4f9:c011:aeba::1"
  type    = "AAAA"
}

# proxmox.xnee.de
resource "hetznerdns_record" "A_proxmox_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "proxmox"
  value   = "65.108.0.24"
  type    = "A"
}

resource "hetznerdns_record" "AAAA_proxmox_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "proxmox"
  value   = "2a01:4f9:6a:4f6f::1"
  type    = "AAAA"
}

# proxmox-dhcp.xnee.de
resource "hetznerdns_record" "AAAA_dhcp_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "dhcp"
  value   = "2a01:4f9:6a:4f6f::5"
  type    = "AAAA"
}

#stonks-ticker
resource "hetznerdns_record" "AAAA_stonks_ticker_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "stonks-ticker"
  value   = "2a01:4f9:6a:4f6f::6"
  type    = "AAAA"
}

# installer
resource "hetznerdns_record" "AAAA_installer_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "installer"
  value   = "2a01:4f9:6a:4f6f:ffff:ffff:ffff:ffff"
  type    = "AAAA"
}

resource "hetznerdns_record" "AAAA_cache_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "cache"
  value   = "2a01:4f9:6a:4f6f::7"
  type    = "AAAA"
}

resource "hetznerdns_record" "AAAA_garage1_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "garage1"
  value   = "2a01:4f9:6a:4f6f::8"
  type    = "AAAA"
}

resource "hetznerdns_record" "AAAA_garage2_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "garage2"
  value   = "2a01:4f9:6a:4f6f::9"
  type    = "AAAA"
}

resource "hetznerdns_record" "AAAA_garage3_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "garage3"
  value   = "2a01:4f9:6a:4f6f::a"
  type    = "AAAA"
}

resource "hetznerdns_record" "AAAA_netbox_xnee_de" {
  zone_id = hetznerdns_zone.xnee_de.id
  name    = "netbox"
  value   = "2a01:4f9:6a:4f6f::11"
  type    = "AAAA"
}
