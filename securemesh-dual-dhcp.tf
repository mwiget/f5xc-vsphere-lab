module "securemesh-dual-dhcp" {
  # count = 0
  depends_on             = [ restapi_object.securemesh-dual-dhcp ]
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
    #    { name = "master-1", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "dhcp" },
    #    { name = "master-2", host = var.vsphere_host, datastore = var.vsphere_datastore, ipaddress = "dhcp" }
  ]
  outside_network        = "VM Network"
  inside_network         = "VM Network 2"
  dnsservers             = {
    primary = "1.1.1.1"
    secondary = "8.8.8.8"
  }
  # publicdefaultgateway   = "10.200.0.1"
  # publicdefaultroute     = "0.0.0.0/0"
  guest_type             = var.f5xc_vm_guest_type
  cpus                   = 4
  memory                 = 16384
  certifiedhardware      = "vmware-regular-nic-voltmesh"
  cluster_name           = format("%s-sm-dual-dhcp", var.project_prefix)
  sitelatitude           = "47.2"
  sitelongitude          = "8.5"
}

resource "restapi_object" "securemesh-dual-dhcp" {
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.securemesh_dual_dhcp
}

locals {
  securemesh_dual_dhcp = jsonencode({
    "metadata" : {
      "name" : format("%s-sm-dual-dhcp", var.project_prefix)
      "namespace" : "system",
      "labels" : {
        "site-mesh" : var.project_prefix
      },
      "annotations" : {},
      "disable" : false
    },
    "spec" : {
      "volterra_certified_hw" : "vmware-regular-nic-voltmesh",
      "master_node_configuration" : [
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
      "worker_nodes" : [],
      "no_bond_devices" : {},
      "custom_network_config": {
        "default_config": {},
        "default_sli_config": {},
        "interface_list": {
          "interfaces": [
            {
              "description": "eth0",
              "labels": {},
              "ethernet_interface": {
                "device": "eth0",
                "cluster": {},
                "untagged": {},
                "dhcp_client": {},
                "site_local_network": {},
                "mtu": 0,
                "priority": 0,
                "not_primary": {},
                "monitor_disabled": {}
              },
              "dc_cluster_group_connectivity_interface_disabled": {}
            },
            {
              "description": "eth1",
              "labels": {},
              "ethernet_interface": {
                "device": "eth1",
                "cluster": {},
                "untagged": {},
                "dhcp_client": {},
                "site_local_inside_network": {},
                "mtu": 0,
                "priority": 0,
                "not_primary": {},
                "monitor_disabled": {}
              },
              "dc_cluster_group_connectivity_interface_disabled": {}
            }
          ]
        },
        "no_network_policy": {},
        "no_forward_proxy": {},
        length(var.global_virtual_networks) > 0 ? "global_network_list" : "no_global_network" : length(var.global_virtual_networks) > 0 ? {
          "global_network_connections": [
          for vn in var.global_virtual_networks :
          {
            "sli_to_global_dr": {
              "global_vn": {
                "namespace": "system",
                "name": "${vn}",
                "kind": "virtual_network"
              }
            }
          }
        ]
        } : {},
        "vip_vrrp_mode": "VIP_VRRP_INVALID",
        "tunnel_dead_timeout": 0,
        "sm_connection_pvt_ip": {}
      },
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

output "securemesh-dual-dhcp" {
  value = [
    restapi_object.securemesh-dual-dhcp[*].api_response,
    module.securemesh-dual-dhcp
  ]
}
