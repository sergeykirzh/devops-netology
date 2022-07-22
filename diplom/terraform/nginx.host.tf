resource "yandex_compute_instance" "reversproxy" {
  name                      = "reversproxy-${terraform.workspace}"
  zone                      = "ru-central1-a"
  hostname                      = "reversproxy-${terraform.workspace}.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = yandex_compute_image.ubuntu1804nat.id
      type        = "network-nvme"
      size        = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    ip_address = local.workspace[terraform.workspace].internet_next_hop_address 
    nat_ip_address = local.workspace[terraform.workspace].public_ip
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

