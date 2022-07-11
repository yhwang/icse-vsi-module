##############################################################################
# Module Variables
##############################################################################

variable "prefix" {
  description = "The prefix that you would like to prepend to your resources"
  type        = string
}

variable "tags" {
  description = "List of Tags for the resource created"
  type        = list(string)
  default     = null
}

variable "resource_group_id" {
  description = "Resource group ID for the VSI"
  type        = string
  default     = null
}

variable "zone" {
  description = "Zone where the VSI and Block Storage will be provisioned"
  type        = string
}

##############################################################################

##############################################################################
# VPC Variables
##############################################################################

variable "vpc_id" {
  description = "ID of the VPC where VSI will be provisioned"
  type        = string
}

##############################################################################

##############################################################################
# Subnet Variables
##############################################################################

variable "primary_subnet_id" {
  description = "ID of the subnet where the VSI will be provisioned."
  type        = string
}

variable "primary_security_group_ids" {
  description = "(Optional) List of security group ids to add to the primary network interface. Using an empty list will assign the default VPC security group."
  type        = list(string)
  default     = []
}

variable "secondary_subnets" {
  description = "(Optional) List of secondary subnets to connect to the instance"
  type = list(
    object({
      name              = string                 # arbitrary name for attaching floating IPs
      id                = string                 # subnet id
      security_groups   = optional(list(string)) # list of security groups to add 
      allow_ip_spoofing = optional(bool)         # allow ip spoofing
    })
  )
  default = []
}

##############################################################################

##############################################################################
# VSI Variables
##############################################################################

variable "name" {
  description = "Name of the server instance"
  type        = string
}

variable "image_id" {
  description = "ID of the server image to use for VSI creation"
  type        = string
}

variable "profile" {
  description = "Type of machine profile for VSI. Use the command `ibmcloud is instance-profiles` to find available profiles in your region"
  type        = string
  default     = "bx2-2x8"
}

variable "ssh_key_ids" {
  description = "List of SSH Key Ids. At least one SSH key must be provided"
  type        = list(string)

  validation {
    error_message = "To provision VSI at least one VPC SSH Ket must be provided."
    condition     = length(var.ssh_key_ids) > 0
  }
}

##############################################################################

##############################################################################
# Common Optional Variables
##############################################################################

variable "boot_volume_encryption_key" {
  description = "(Optional) Boot volume encryption key"
  type        = string
  default     = null
}

variable "user_data" {
  description = "(Optional) Data to transfer to instance"
  type        = string
  default     = null
}

variable "allow_ip_spoofing" {
  description = "Allow IP spoofing on primary network interface"
  type        = bool
  default     = false
}

variable "add_floating_ip" {
  description = "Add a floating IP to the primary network interface."
  type        = bool
  default     = false
}

variable "block_storage_volumes" {
  description = "List describing the block storage volumes that will be attached to the VSI. Storage volumes will be provisoned in the same resource group as the server instance."
  type = list(
    object({
      name                 = string           # Name of the storage volume
      profile              = string           # Profile to use for the volume
      capacity             = optional(number) # Capacity in gigabytes. If null, will default to `100`
      iops                 = optional(number) # The total input/ output operations per second (IOPS) for your storage. This value is required for custom storage profiles onli
      encryption_key       = optional(string) # ID of the key to use to encrypt volume
      delete_all_snapshots = optional(bool)   # Deletes all snapshots created from this volume.
    })
  )
  default = []

  validation {
    error_message = "Each block storage volume must have a unique name."
    condition     = length(distinct(var.block_storage_volumes.*.name)) == length(var.block_storage_volumes)
  }
}

##############################################################################

##############################################################################
# Uncommon Optional Variables
##############################################################################

variable "secondary_floating_ips" {
  description = "List of secondary interfaces to add floating ips"
  type        = list(string)
  default     = []

  validation {
    error_message = "Secondary floating IPs must contain a unique list of interfaces."
    condition     = length(var.secondary_floating_ips) == length(distinct(var.secondary_floating_ips))
  }
}

variable "availability_policy_host_failure" {
  description = "(Optional) The availability policy to use for this virtual server instance. The action to perform if the compute host experiences a failure. Supported values are `restart` and `stop`."
  type        = string
  default     = null

  validation {
    error_message = "Availability Policy Host Failure can be `null`, `stop`, or `restart`."
    condition = (
      var.availability_policy_host_failure == null
      ? true
      : contains(["stop", "restart"], var.availability_policy_host_failure)
    )
  }
}

variable "boot_volume_name" {
  description = "(Optional) Name of the boot volume"
  type        = string
  default     = null
}

variable "boot_volume_size" {
  description = "(Optional) The size of the boot volume.(The capacity of the volume in gigabytes. This defaults to minimum capacity of the image and maximum to 250"
  type        = number
  default     = null
}


variable "dedicated_host" {
  description = "(Optional) The placement restrictions to use the virtual server instance. Unique ID of the dedicated host where the instance id placed."
  type        = string
  default     = null
}

variable "dedicated_host_group" {
  description = "(Optional) The placement restrictions to use for the virtual server instance. Unique ID of the dedicated host group where the instance is placed."
  type        = string
  default     = null
}

variable "default_trusted_profile_target" {
  description = "(Optional) The unique identifier or CRN of the default IAM trusted profile to use for this virtual server instance."
  type        = string
  default     = null
}

variable "metadata_service_enabled" {
  description = "(Optional) Indicates whether the metadata service endpoint is available to the virtual server instance. Default value : false"
  type        = bool
  default     = null
}

variable "placement_group" {
  description = "(Optional) Unique Identifier of the Placement Group for restricting the placement of the instance"
  type        = string
  default     = null
}

##############################################################################