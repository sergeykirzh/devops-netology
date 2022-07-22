resource "yandex_compute_instance" "gitlab" {
  name                      = "gitlab-${terraform.workspace}"
  zone                      = "ru-central1-a"
  hostname                      = "gitlab-${terraform.workspace}.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = yandex_compute_image.ubuntu2004.id
      type        = "network-nvme"
      size        = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    ip_address = local.workspace[terraform.workspace].ip_address_gitlab
    nat   = false
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
 
}

