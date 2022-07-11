##############################################################################
# VSI Outputs
##############################################################################

output "id" {
  description = "Virtual Server ID"
  value       = ibm_is_instance.vsi.id
}

output "name" {
  description = "Virtual Server name"
  value       = ibm_is_instance.vsi.id
}

output "primary_ipv4_address" {
  description = "Primary ipv4 address for virtual server"
  value       = ibm_is_instance.vsi.primary_network_interface.0.primary_ipv4_address
}

output "floating_ip" {
  description = "Floating IP if created"
  value       = var.add_floating_ip == true ? ibm_is_floating_ip.vsi_fip[0].address : null
}

output "secondary_floating_ips" {
  description = "List of secondary floating IPs"
  value = [
    for address in ibm_is_floating_ip.secondary_fip :
    {
      name = address.name
      ip   = address.address
    }
  ]
}

##############################################################################