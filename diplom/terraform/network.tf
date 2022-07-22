resource "yandex_vpc_network" "default" {
  name = "net-${terraform.workspace}"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet-${terraform.workspace}"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.default.id
  v4_cidr_blocks = local.workspace[terraform.workspace].subnet_default_v4_cidr_blocks

}

resource "yandex_vpc_subnet" "zone2" {
  name = "subnet-zone-b-${terraform.workspace}"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.default.id
  v4_cidr_blocks = local.workspace[terraform.workspace].subnet_zone2_v4_cidr_blocks

}

resource "yandex_vpc_subnet" "public" {
  name = "subnet-public--${terraform.workspace}"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = local.workspace[terraform.workspace].subnet_public_v4_cidr_blocks
}



resource "yandex_vpc_route_table" "default" {
  name = "internet-${terraform.workspace}"
  network_id = "${yandex_vpc_network.default.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   =  local.workspace[terraform.workspace].internet_next_hop_address 
  }
}

