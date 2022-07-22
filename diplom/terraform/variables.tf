variable "yandex_cloud_id" {
  default = ""
}

variable "yandex_folder_id" {
  default = ""
}

#пароль gitlab-server по-умолчанию
variable "gitlab_pass" {
  default = "YjB*5SpIA)p9*^k)2G"
}

#Конфигурация stage и prod окружения, указать свои domain и public_ip
locals {
  workspace = {     
    stage =  {
      public_ip = "51.250.89.238"
      domain = "sksaransk.ru"
      subnet_default_v4_cidr_blocks = ["192.168.50.0/24"]
      subnet_zone2_v4_cidr_blocks =  ["192.168.52.0/24"]
      subnet_public_v4_cidr_blocks =  ["192.168.51.0/24"]
      internet_next_hop_address = "192.168.51.10"      
      ip_address_db1 = "192.168.50.10"
      ip_address_db2 = "192.168.52.20"
      ip_address_app = "192.168.50.30"
      ip_address_gitlab = "192.168.50.40"
      ip_address_grunner = "192.168.50.50"
      ip_address_monitoring = "192.168.52.60"

    }

    prod =  {
      public_ip = "51.250.89.238"
      domain = "sksaransk.ru"      
      subnet_default_v4_cidr_blocks = ["192.168.60.0/24"]
      subnet_zone2_v4_cidr_blocks =  ["192.168.62.0/24"]
      subnet_public_v4_cidr_blocks =  ["192.168.61.0/24"]
      internet_next_hop_address = "192.168.61.10"      
      ip_address_db1 = "192.168.60.10"
      ip_address_db2 = "192.168.62.20"
      ip_address_app = "192.168.60.30"
      ip_address_gitlab = "192.168.60.40"
      ip_address_grunner = "192.168.60.50"
      ip_address_monitoring = "192.168.62.60"

    }  
  } 

}