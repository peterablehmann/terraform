terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.42.1"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  backend "pg" {}
}

provider "hcloud" {
}

provider "hetznerdns" {
}

resource "hcloud_ssh_key" "peter_kee" {
  name       = "peter_kee"
  public_key = file("ssh/ed25519_peter@kee.pub")
}

module "zones" {
  source = "./zones"
}

module "infrastructure" {
  source = "./infrastructure"

  zone_xnee_de_id = module.zones.xnee_de_zone_id
}
