terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cloudstock-asia" # <--- Ganti nama sedikit agar bersih dari cache
  location = "East Asia"          # <--- Gunakan region VIP dari screenshot-mu!
}