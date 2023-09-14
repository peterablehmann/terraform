terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.42.1"
    }
    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
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

  image     = "ubuntu-22.04"
  user_data = "../cloud-init/docker.yml"
  ssh_keys  = ["infra"]
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
