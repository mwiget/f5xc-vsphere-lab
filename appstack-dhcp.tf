module "appstack-dhcp" {
  count = 0
  depends_on             = [ restapi_object.appstack-dhcp ]
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
    { name = "master-0", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "dhcp" },
    { name = "master-1", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "dhcp" },
    { name = "master-2", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "dhcp" }
  ]
  outside_network        = "VM Network"
  dnsservers             = {
    primary = "1.1.1.1"
    secondary = "8.8.8.8"
  }
  # publicdefaultgateway   = "10.200.0.1"
  # publicdefaultroute     = "0.0.0.0/0"
  guest_type             = var.f5xc_vm_guest_type
  cpus                   = 4
  memory                 = 16384
  certifiedhardware      = "vmware-voltstack-combo"
  cluster_name           = format("%s-as-dhcp", var.project_prefix)
  sitelatitude           = "47.2"
  sitelongitude          = "8.5"
}

resource "restapi_object" "appstack-dhcp" {
  depends_on   = [ restapi_object.appstack-dhcp-k8s-cluster ]
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/voltstack_sites"
  data         = local.appstack_dhcp
}

resource "restapi_object" "appstack-dhcp-k8s-cluster" {
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/k8s_clusters"
  data         = local.appstack_dhcp_k8s_cluster
}

locals {
  appstack_dhcp = jsonencode({
    "metadata": {
      "name" : format("%s-as-dhcp", var.project_prefix)
      "namespace" : "system",
      "labels" : {
        "site-mesh" : var.project_prefix
      },
      "annotations" : {},
      "disable" : false
    },
    "spec": {
      "volterra_certified_hw": "vmware-voltstack-combo",
      "master_nodes": [],
      "master_node_configuration": [
        {
          "name": "master-0"
        },
        {
          "name": "master-1"
        },
        {
          "name": "master-2"
        }
      ],
      "worker_nodes": [
      ],
      "no_bond_devices": {},
      "default_network_config": {},
      "default_storage_config": {},
      "disable_gpu": {},
      "coordinates" : {
        "latitude" : 0,
        "longitude" : 0
      },
      "k8s_cluster": {
        "tenant": var.f5xc_tenant,
        "namespace": "system",
        "name": format("%s-as-dhcp", var.project_prefix),
        "kind": "k8s_cluster"
      },
      "logs_streaming_disabled": {},
      "allow_all_usb": {},
      "disable_vm": {},
      "default_blocked_services": {},
      "offline_survivability_mode": {
        "no_offline_survivability_mode": {}
      },
      "default_sriov_interface": {}
    }
  })
  appstack_dhcp_k8s_cluster = jsonencode({
    "metadata": {
      "name" : format("%s-as-dhcp", var.project_prefix)
      "namespace" : "system",
      "labels" : {},
      "annotations" : {},
      "disable" : false
    },
    "spec": {
      "local_access_config": {
      "local_domain": format("%s-as-dhcp.local", var.project_prefix)
      "default_port": {}
    },
    "global_access_enable": {},
    "use_default_psp": {},
    "use_default_cluster_roles": {},
    "use_default_cluster_role_bindings": {},
    "no_cluster_wide_apps": {},
    "no_insecure_registries": {},
    "cluster_scoped_access_permit": {}
    }
  })
}

output "appstack-dhcp" {
  value = [
    restapi_object.appstack-dhcp.api_response,
    restapi_object.appstack-dhcp-k8s-cluster.api_response,
    module.appstack-dhcp[*]
  ]
}
