terraform {
  required_providers {
    docker = {
      #source = "terraform-providers/docker"
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "wordpress_imagen" {
  name         = "wordpress:latest"
  keep_locally = false
}

resource "docker_image" "mariadb_imagen" {
  name         = "mariadb:latest"
  keep_locally = false
}


resource "docker_volume" "volumen_mariadb" {
  name = "volumen_mariadb"
}

resource "docker_network" "entregable_network" {
  name = "entregable_network"
}

resource "docker_container" "wordpress_contenedor" {
  image = docker_image.wordpress_imagen.image_id
  name  = var.container_name
  ports {
    internal = 80
    external = 8001
  }

  networks_advanced {
    name = docker_network.entregable_network.name
  }
}

resource "docker_container" "mariadb_contenedor" {
  image = docker_image.mariadb_imagen.image_id
  name  = "mariadb_contenedor"
  volumes {
    volume_name    = docker_volume.volumen_mariadb.name
    container_path = "/var/lib/mysql"
  }

  networks_advanced {
    name = docker_network.entregable_network.name
  }
}