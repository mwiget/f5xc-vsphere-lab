module "virtual_site" {     
  source                                = "./modules/f5xc/site/virtual"
  f5xc_namespace                        = "shared"
  f5xc_virtual_site_name                = format("%s-all-sites", var.project_prefix)
  f5xc_virtual_site_type                = "CUSTOMER_EDGE"
  f5xc_virtual_site_selector_expression = [ format("site-mesh in (%s)", var.project_prefix) ]
} 

resource "volterra_site_mesh_group" "smg" {
  name        = format("%s-smg", var.project_prefix)
  namespace   = "system"
  type        = "SITE_MESH_GROUP_TYPE_FULL_MESH"
  virtual_site {
    name = module.virtual_site.virtual_site["name"]
    namespace = "shared"
  }
}
