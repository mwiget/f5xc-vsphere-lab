provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  timeout      = "30s"
}
provider "vsphere" {
  user                  = var.vsphere_user
  password              = var.vsphere_password
  vsphere_server        = var.vsphere_server
  allow_unverified_ssl  = true
}
provider "restapi" {
  uri = var.f5xc_api_url
  create_returns_object = true
  headers = {                   
    Authorization = format("APIToken %s", var.f5xc_api_token)   
    Content-Type  = "application/json"
  }
}
