##############################################################################
# Fail if FIP secondary subnet not found
##############################################################################

locals {
  CONFIGURATION_FAILURE_unfound_secondary_subnet_for_floating_ip = regex(
    "true",
    (
      length(var.secondary_subnets) == 0
      ? true
      : length([
        for name in var.secondary_floating_ips :
        true if !contains(var.secondary_subnets.*.shortname, name)
      ]) == 0
    )
  )
}
##############################################################################