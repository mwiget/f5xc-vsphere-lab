resource "volterra_virtual_network" "gn" {
  name            = format("%s-global-network", var.project_prefix)
  namespace       = "system"
  global_network  = true
}

output "global_network" {
  value = volterra_virtual_network.gn
}
