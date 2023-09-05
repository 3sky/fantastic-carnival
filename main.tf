provider "google" {
  credentials = file(".personal/credentials.json")
  project     = var.project
  region      = "europe-central2"
}


module "nginx_dev" {
  env      = "dev"
  source   = "./modules/nginx"
  region   = "europe-central2"
  vm_shape = "f1-micro"
  ha       = false

  tags = ["Terraform", "true", "env", "dev"]
}

module "nginx_stg" {
  env      = "stg"
  source   = "./modules/nginx"
  region   = "europe-central2"
  vm_shape = "f1-micro"
  ha       = true

  tags = ["Terraform", "true", "env", "stg"]
}

output "url_dev" {
  value = module.nginx_dev.nginx-url
}

output "url_stg" {
  value = module.nginx_stg.nginx-url
}
