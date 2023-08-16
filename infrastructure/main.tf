terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    hetznerdns = {
      source = "timohirt/hetznerdns"
    }
  }
}

resource "hcloud_ssh_key" "infra" {
  name       = "infra"
  public_key = file("ssh/ed25519_infra.pub")
}

resource "hcloud_server" "infra_xnee_de" {
  name               = "infra.xnee.de"
  server_type        = "cpx31"
  datacenter         = "nbg1-dc3"
  delete_protection  = false
  rebuild_protection = false

  image     = "debian-12"
  ssh_keys  = ["infra"]
  user_data = file("cloud-init/nixos.yml")
}

resource "hetznerdns_record" "infra_xnee_de_v4" {
  zone_id = var.zone_xnee_de_id
  name    = "infra"
  value   = hcloud_server.infra_xnee_de.ipv4_address
  type    = "A"
}

resource "hetznerdns_record" "infra_xnee_de_v6" {
  zone_id = var.zone_xnee_de_id
  name    = "infra"
  value   = hcloud_server.infra_xnee_de.ipv6_address
  type    = "AAAA"
}
