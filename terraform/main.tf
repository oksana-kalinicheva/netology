variable yc_token {}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Provider

provider "yandex" {
  token = var.oauth_token
  cloud_id = var.cloud_id
  folder_id = var.folder_id

}

# NGINX
resource "yandex_compute_instance" "nginx1" {
  name     = "nginx1"
  hostname = "nginx1"
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    core_fraction = 20
    memory = 2

  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-nginx1.id
    security_group_ids = [yandex_vpc_security_group.private-sg.id]
    ip_address         = "192.168.1.10"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"

  }
}


resource "yandex_compute_instance" "nginx2" {
  name     = "nginx2"
  hostname = "nginx2"
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  zone     = "ru-central1-b"

  resources {
    cores  = 2
    core_fraction = 20
    memory = 2

  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = 10
    }

  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-nginx2.id
    security_group_ids = [yandex_vpc_security_group.private-sg.id]
    ip_address         = "192.168.2.10"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

# Zabbix
resource "yandex_compute_instance" "zabbix" {
  name     = "zabbix"
  hostname = "zabbix"
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  zone     = "ru-central1-d"

  resources {
    cores  = 2
    core_fraction = 20
    memory = 6
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = "15"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    security_group_ids = [yandex_vpc_security_group.private-sg.id, yandex_vpc_security_group.zabbix-sg.id]
    ip_address         = "192.168.4.20"
    nat                = true

  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

# Elasticsearch
resource "yandex_compute_instance" "elasticsearch" {
  name     = "elasticsearch"
  hostname = "elasticsearch"
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  zone     = "ru-central1-d"

  resources {
    cores  = 4
    core_fraction = 20
    memory = 8

  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-services.id
    security_group_ids = [yandex_vpc_security_group.private-sg.id, yandex_vpc_security_group.elasticsearch-sg.id]
    ip_address         = "192.168.3.10"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}


# Kibana
resource "yandex_compute_instance" "kibana" {
  name     = "kibana"
  hostname = "kibana"
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  zone     = "ru-central1-d"

  resources {
    cores  = 2
    core_fraction = 20
    memory = 2

  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    security_group_ids = [yandex_vpc_security_group.private-sg.id, yandex_vpc_security_group.kibana-sg.id]
    ip_address         = "192.168.4.30"
    nat                = true

  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

# Bastion
resource "yandex_compute_instance" "bastion" {
  name     = "bastion"
  hostname = "bastion"
  allow_stopping_for_update = true
  platform_id = "standard-v3"
  zone     = "ru-central1-d"

  resources {
    cores  = 2
    core_fraction = 20
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = "15"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    security_group_ids = [yandex_vpc_security_group.bastion-sg.id]
    ip_address         = "192.168.4.100"
    nat                = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}