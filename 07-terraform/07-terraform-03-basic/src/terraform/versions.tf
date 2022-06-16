terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-terraform-state"
    region     = "ru-central1"
    key        = "s3/terraform.tfstate"
    access_key = "Y**************X"
    secret_key = "YC**************"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
