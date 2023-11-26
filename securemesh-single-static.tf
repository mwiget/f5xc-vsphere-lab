module "securemesh-single-static" {
  depends_on             = [ restapi_object.securemesh-single-static ]
  source                 = "./vsphere"
  f5xc_tenant            = var.f5xc_tenant
  f5xc_api_url           = var.f5xc_api_url
  f5xc_namespace         = var.f5xc_namespace
  f5xc_api_token         = var.f5xc_api_token
  f5xc_api_ca_cert       = var.f5xc_api_ca_cert
  f5xc_reg_url           = var.f5xc_reg_url
  f5xc_vm_template       = var.f5xc_vm_template
  vsphere_user           = var.vsphere_user
  vsphere_password       = var.vsphere_password
  vsphere_server         = var.vsphere_server
  vsphere_datacenter     = var.vsphere_datacenter
  vsphere_cluster        = var.vsphere_cluster
  admin_password         = var.admin_password
  nodes   = [
    { name = "master-0", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "192.168.42.100/24" },
    #    { name = "master-1", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "static" },
    #    { name = "master-2", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "static" }
  ]
  outside_network        = "VM Network"
  dnsservers             = {
    primary = "1.1.1.1"
    secondary = "8.8.8.8"
  }
  publicdefaultgateway   = "192.168.42.1"
  publicdefaultroute     = "0.0.0.0/0"
  guest_type             = var.f5xc_vm_guest_type
  cpus                   = 4
  memory                 = 16384
  certifiedhardware      = "vmware-voltmesh"
  cluster_name           = format("%s-sm-single-static", var.project_prefix)
  sitelatitude           = "47.2"
  sitelongitude          = "8.5"
}

resource "restapi_object" "securemesh-single-static" {
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.securemesh_single_static
}

locals {
  securemesh_single_static = jsonencode({
    "metadata" : {
      "name" : format("%s-sm-single-static", var.project_prefix)
      "namespace" : "system",
      "labels" : {
        "site-mesh" : var.project_prefix
      },
      "annotations" : {},
      "disable" : false
    },
    "spec" : {
      "volterra_certified_hw" : "vmware-voltmesh",
      "master_node_configuration" : [
        {
          "name" : "master-0"
        },
        {
          "name" : "master-1"
        },
        {
          "name" : "master-2"
        }
      ],
      "worker_nodes" : [],
      "no_bond_devices" : {},
      "default_network_config": {},
      "coordinates" : {
        "latitude" : 0,
        "longitude" : 0
      },
      "logs_streaming_disabled" : {},
      "default_blocked_services" : {},
      "offline_survivability_mode" : {
        "no_offline_survivability_mode" : {}
      }
    }
  })
}

output "securemesh-single-static" {
  value = [
    restapi_object.securemesh-single-static.api_response,
    module.securemesh-single-static
  ]
}
