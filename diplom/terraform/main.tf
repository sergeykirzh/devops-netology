provider "yandex" {
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}

resource "yandex_compute_image" "ubuntu2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_image" "ubuntu1804nat" {
  source_family = "nat-instance-ubuntu"
}

