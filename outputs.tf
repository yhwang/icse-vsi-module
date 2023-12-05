##############################################################################
# VSI Outputs
##############################################################################

output "id" {
  description = "Virtual Server ID"
  value = [
    for inst in ibm_is_instance.vsi : "${inst.id}"
  ]
}

output "name" {
  description = "Virtual Server name"
  value = [
    for inst in ibm_is_instance.vsi : "${inst.name}"
  ]
}

output "primary_ipv4_address" {
  description = "Primary ipv4 address for virtual server"
  value = [ 
    for inst in ibm_is_instance.vsi : "${inst.primary_network_interface.0.primary_ipv4_address}"
  ]
}

output "floating_ip" {
  description = "Floating IP if created"
  value = [
    for inst in ibm_is_floating_ip.vsi_fip : "${inst.address}"
  ]
}

##############################################################################