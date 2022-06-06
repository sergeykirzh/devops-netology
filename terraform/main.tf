provider "yandex" {
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
}

resource "yandex_compute_image" "ubuntu1804" {
  source_family = "ubuntu-1804-lts"
}
