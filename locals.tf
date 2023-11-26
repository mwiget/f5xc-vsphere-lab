locals {
  custom_tags = {
    Owner        = var.owner_tag
    deployment   = var.deployment
    f5xc-tenant  = var.f5xc_tenant
    f5xc-feature = format("f5xc-%s", var.project_prefix)
  }
}
