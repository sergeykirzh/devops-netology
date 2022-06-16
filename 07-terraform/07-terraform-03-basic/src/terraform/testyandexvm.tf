locals {
    instance_type = {
       stage = "standard-v1"
       prod =  "standard-v3"
    }
    count_pc     =  {
       stage = 1
       prod =  2
   }
  
   for_each     =  {
       first = "one"
       last =  "two"
   }

}


resource "yandex_compute_instance" "netologyvm" {
  name                      = "netologyvm-${terraform.workspace}-${count.index}"
  zone                      = "ru-central1-a"
  hostname                  = "netologyvm-${terraform.workspace}-${count.index}.netology.cloud"
  platform_id               = local.instance_type[terraform.workspace]
  count                     = local.count_pc[terraform.workspace]
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = yandex_compute_image.ubuntu1804.id
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}

resource "yandex_compute_instance" "netologyvm-for_each" {
  name                      = "netologyvm-foreach-${each.value}"
  zone                      = "ru-central1-a"
  for_each                  = local.for_each
  hostname                  = "netologyvm-foreach-${each.value}.netology.cloud"
  platform_id               = local.instance_type[terraform.workspace]
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = yandex_compute_image.ubuntu1804.id
      type        = "network-nvme"
      size        = "50"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}
