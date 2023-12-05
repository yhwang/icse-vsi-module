##############################################################################
# VSI Outputs
##############################################################################

output "id" {
  description = "Virtual Server ID"
  value = {
    for k, v in ibm_is_instance.vsi : k => v.id
  }
}

output "name" {
  description = "Virtual Server name"
  value = {
    for k, v in ibm_is_instance.vsi : k => v.name
  }
}

output "primary_ipv4_address" {
  description = "Primary ipv4 address for virtual server"
  value = {
    for k, v in ibm_is_instance.vsi : k => v.primary_network_interface.0.primary_ipv4_address
  }
}

output "floating_ip" {
  description = "Floating IP if created"
  value = {
    for k, v in ibm_is_floating_ip.vsi_fip : k => v.address
  }
}

##############################################################################