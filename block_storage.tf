##############################################################################
# Create Map of Block Storage Volumes
##############################################################################

module "block_volume_map" {
  source = "./list_to_map"
  list   = var.block_storage_volumes
}

##############################################################################

##############################################################################
# Create Storage Volumes
##############################################################################

resource "ibm_is_volume" "vsi_storage" {
  for_each             = module.block_volume_map.value
  name                 = "${var.prefix}-${var.name}-${each.value.name}-volume"
  profile              = each.value.profile
  capacity             = each.value.capacity
  encryption_key       = lookup(each.value, "encryption_key", null) == null ? var.boot_volume_encryption_key : each.value.encryption_key
  iops                 = each.value.iops
  delete_all_snapshots = each.value.delete_all_snapshots
  resource_group       = var.resource_group_id
  tags                 = var.tags
  zone                 = var.zone
}

##############################################################################