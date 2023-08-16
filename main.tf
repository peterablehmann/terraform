terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.42.0"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
  }
}

provider "hcloud" {
}

provider "hetznerdns" {
}

module "bigdriver_net" {
  source = "./zones/bigdriver_net"
}

module "lehmann_zone" {
  source = "./zones/lehmann_zone"
}

module "uic_fahrzeugnummer_de" {
  source = "./zones/uic_fahrzeugnummer_de"
}

module "xnee_de" {
  source = "./zones/xnee_de"
}

module "xnee_net" {
  source = "./zones/xnee_net"
}

module "xxhe_de" {
  source = "./zones/xxhe_de"
}

module "infrastructure" {
  source = "./infrastructure"

  zone_bigdriver_net_id         = module.bigdriver_net.zone_id
  zone_lehmann_zone_id          = module.lehmann_zone.zone_id
  zone_uic_fahrzeugnummer_de_id = module.uic_fahrzeugnummer_de.zone_id
  zone_xnee_de_id               = module.xnee_de.zone_id
  zone_xnee_net_id              = module.xnee_net.zone_id
  zone_xxhe_de_id               = module.xxhe_de.zone_id
}
