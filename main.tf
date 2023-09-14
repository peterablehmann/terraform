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
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  backend "pg" {}
}

provider "hcloud" {
}

provider "hetznerdns" {
}

module "zones" {
  source = "./zones"
}

module "infrastructure" {
  source = "./infrastructure"

  zone_xnee_de_id = module.zones.xnee_de_zone_id
}
