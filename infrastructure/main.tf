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
}

provider "docker" {
  host     = "ssh://root@infra.xnee.de:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
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
  user_data = file(".cloudinit/docker.yaml")
  ssh_keys  = ["infra", "peter_kee"]
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

resource "docker_image" "traefik" {
  name = "traefik:v3.0"
}

resource "docker_volume" "traefik" {
  name = "traefik_acme"
}

resource "docker_container" "traefik" {
  name  = "traefik"
  image = docker_image.traefik.image_id
  mounts {
    target    = "/var/run/docker.sock"
    type      = "bind"
    source    = "/var/run/docker.sock"
    read_only = true
  }

  volumes {
    container_path = "/acme"
    volume_name    = "traefik_acme"
  }

  ports {
    internal = 80
  }
  ports {
    internal = 443
  }

  command = [
    "--entrypoints.web.address=:80",
    "--entrypoints.websecure.address=:443",
    "--providers.docker",
    "--log.level=WARN",
    "--certificatesresolvers.leresolver.acme.httpchallenge=true",
    "--certificatesresolvers.leresolver.acme.email=peter@lehmann.zone",
    "--certificatesresolvers.leresolver.acme.storage=/acme/acme.json",
    "--certificatesresolvers.leresolver.acme.httpchallenge.entrypoint=web"
  ]

  labels {
    label = "traefik.http.routers.http-catchall.rule"
    value = "hostregexp(`{host:.+}`)"
  }
  labels {
    label = "traefik.http.routers.http-catchall.entrypoints"
    value = "web"
  }
  labels {
    label = "traefik.http.routers.http-catchall.middlewares"
    value = "redirect-to-https"
  }
  labels {
    label = "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme"
    value = "https"
  }
}

# Portainer

resource "hetznerdns_record" "CNAME_portainer_xnee_de" {
  zone_id = var.zone_xnee_de_id
  name    = "portainer"
  value   = "infra.xnee.de."
  type    = "CNAME"
}

resource "hetznerdns_record" "CNAME_edge_xnee_de" {
  zone_id = var.zone_xnee_de_id
  name    = "edge"
  value   = "infra.xnee.de."
  type    = "CNAME"
}

resource "docker_image" "portainer" {
  name = "portainer/portainer-ee:2.19.1-alpine"
}

resource "docker_volume" "portainer_data" {
  name = "portainer_data"
}

resource "docker_container" "portainer" {
  name  = "portainer"
  image = docker_image.portainer.image_id
  mounts {
    target    = "/var/run/docker.sock"
    type      = "bind"
    source    = "/var/run/docker.sock"
    read_only = true
  }

  volumes {
    container_path = "/data"
    volume_name    = "portainer_data"
  }

  # Frontend

  labels {
    label = "traefik.enable"
    value = "true"
  }
  labels {
    label = "traefik.http.routers.frontend.rule"
    value = "Host(`portainer.xnee.de`)"
  }
  labels {
    label = "traefik.http.routers.frontend.entrypoints"
    value = "websecure"
  }
  labels {
    label = "traefik.http.services.frontend.loadbalancer.server.port"
    value = "9000"
  }
  label {
    label = "traefik.http.routers.frontend.service"
    value = "frontend"
  }
  label {
    label = "traefik.http.routers.frontend.tls.certresolver"
    value = "leresolver"
  }

  # Edge

  label {
    label = "traefik.http.routers.edge.rule"
    value = "Host(`edge.xnee.de`)"
  }
  labels {
    label = "traefik.http.routers.edge.entrypoints"
    value = "websecure"
  }
  labels {
    label = "traefik.http.services.edge.loadbalancer.server.port"
    value = "8000"
  }
  label {
    label = "traefik.http.routers.edge.service"
    value = "edge"
  }
  label {
    label = "traefik.http.routers.edge.tls.certresolver"
    value = "leresolver"
  }
}
