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

  zone_bigdriver_net_id         = module.zones.bigdriver_net_zone_id
  zone_lehmann_zone_id          = module.zones.lehmann_zone_zone_id
  zone_uic_fahrzeugnummer_de_id = module.zones.uic_fahrzeugnummer_de_zone_id
  zone_xnee_de_id               = module.zones.xnee_de_zone_id
  zone_xnee_net_id              = module.zones.xnee_net_zone_id
  zone_xxhe_de_id               = module.zones.xxhe_de_zone_id
}
