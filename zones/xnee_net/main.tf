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

resource "hetznerdns_zone" "xnee_net" {
  name = "xnee.net"
  ttl  = 60
}

# Mail

resource "hetznerdns_record" "MX_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "@"
  value   = "10 www208.your-server.de."
  type    = "MX"
}

resource "hetznerdns_record" "TXT_default2307__domainkey_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "default2307._domainkey"
  value = join("\"", [
    "",
    replace(local.dkim, "/(.{255})/", "$1\" \""),
    " "
  ])
  type = "TXT"
}

resource "hetznerdns_record" "TXT_SPF_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "@"
  value   = "\"v=spf1 mx ~all\""
  type    = "TXT"
}

resource "hetznerdns_record" "TXT__dmarc_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "_dmarc"
  value   = "\"v=DMARC1;p=quarantine;sp=quarantine;pct=100;rua=mailto:dmarc@xnee.net;ruf=mailto:dmarc@xnee.net;adkim=s;aspf=s;\""
  type    = "TXT"
}

resource "hetznerdns_record" "SRV__autodiscover__tcp_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "_autodiscover._tcp"
  value   = "0 100 443 mail.your-server.de."
  type    = "SRV"
}

resource "hetznerdns_record" "SRV__imaps__tcp_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "_imaps._tcp"
  value   = "0 100 993 mail.your-server.de"
  type    = "SRV"
}

resource "hetznerdns_record" "SRV__pop3s__tcp_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "_pop3s._tcp"
  value   = "0 100 995 mail.your-server.de"
  type    = "SRV"
}

resource "hetznerdns_record" "SRV__submission__tcp_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "_submission._tcp"
  value   = "0 100 587 mail.your-server.de"
  type    = "SRV"
}

resource "hetznerdns_record" "CNAME_autoconfig_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "autoconfig"
  value   = "mail.your-server.de."
  type    = "CNAME"
}

# ThinClients
resource "hetznerdns_record" "AAAA_tc1_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "grafana"
  value   = "2003:cb:cf15:a700:921b:eff:fe8f:625d"
  type    = "AAAA"
}

resource "hetznerdns_record" "AAAA_tc2_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "tc2"
  value   = "2003:cb:cf27:3800:921b:eff:fe5a:1cdb"
  type    = "AAAA"
}

# Grafana
resource "hetznerdns_record" "CNAME_grafana_xnee_net" {
  zone_id = hetznerdns_zone.xnee_net.id
  name    = "grafana"
  value   = "tc2.xnee.net."
  type    = "CNAME"
}
