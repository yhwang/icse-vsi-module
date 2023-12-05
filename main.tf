##############################################################################
# Create Virtual Server Deployments
##############################################################################

resource "ibm_is_instance" "vsi" {
  count                            = var.instance_count
  name                             = "${var.prefix}-${var.name}-${count.index}"
  image                            = var.image_id
  profile                          = var.profile
  resource_group                   = var.resource_group_id
  vpc                              = var.vpc_id
  zone                             = var.zone
  user_data                        = var.user_data
  keys                             = var.ssh_key_ids
  availability_policy_host_failure = var.availability_policy_host_failure
  dedicated_host                   = var.dedicated_host
  dedicated_host_group             = var.dedicated_host_group
  default_trusted_profile_target   = var.default_trusted_profile_target
  metadata_service_enabled         = var.metadata_service_enabled
  placement_group                  = var.placement_group

  volumes = [
    for volume in ibm_is_volume.vsi_storage :
    volume.id
  ]

  primary_network_interface {
    subnet            = var.primary_subnet_id
    security_groups   = var.primary_security_group_ids
    allow_ip_spoofing = var.allow_ip_spoofing
  }

  dynamic "network_interfaces" {
    for_each = var.secondary_subnets
    content {
      subnet            = network_interfaces.value.id
      security_groups   = lookup(network_interfaces, "security_group_ids", null)
      allow_ip_spoofing = lookup(network_interfaces, "allow_ip_spoofing", null)
    }
  }

  boot_volume {
    encryption = var.boot_volume_encryption_key
    name       = var.boot_volume_name
    size       = var.boot_volume_size
  }
}

##############################################################################

##############################################################################
# Optionally Add Floating IPs
##############################################################################

resource "ibm_is_floating_ip" "vsi_fip" {
  for_each = ibm_is_instance.vsi
  count  = var.add_floating_ip == true ? 1 : 0
  name   = "${var.prefix}-${each.name}-fip"
  target = each.primary_network_interface.0.id
}

resource "ibm_is_floating_ip" "secondary_fip" {
  for_each = {
    for interface in var.secondary_floating_ips :
    (interface) => {
      name = "${var.prefix}-${var.name}-secondary-fip-${index(var.secondary_floating_ips, interface) + 1}"
      target = ibm_is_instance.vsi.network_interfaces[
        index(var.secondary_subnets.*.shortname, interface)
      ].id
    }
  }
  name   = each.key
  target = each.value.target
}

##############################################################################