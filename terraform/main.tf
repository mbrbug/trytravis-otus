terraform {
  # Версия terraform
  required_version = "0.12.18"
}

provider "google" {
  # Версия провайдера
  version = "2.15"
  # ID проекта
  project = "infra-262320"
  region = "europe-west-1"
}

resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"
  tags = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
   }
 metadata = {
   # путь до публичного ключа
   ssh-keys = "appuser:${file("~/.ssh/appuser.pub")}"
   }

 network_interface {
   network = "default"
   access_config {}
   }
  }

resource "google_compute_firewall" "firewall_puma" {
 name = "allow-puma-default"
 # Название сети, в которой действует правило
 network = "default"
 # Какой доступ разрешить
 allow {
   protocol = "tcp"
   ports = ["9292"]
 }
 # Каким адресам разрешаем доступ
 source_ranges = ["0.0.0.0/0"]
 # Правило применимо для инстансов с перечисленными тэгами
 target_tags = ["reddit-app"]
}
