#
# ONLY EDIT THIS FILE IN cloudposse/terraform-null-label
# All other instances of this file should be a copy of that one
#

# Copy contents of cloudposse/terraform-null-label/variables.tf here
variable "context" {
  type = object({
    enabled             = bool
    namespace           = string
    environment         = string
    stage               = string
    name                = string
    delimiter           = string
    attributes          = list(string)
    tags                = map(string)
    additional_tag_map  = map(string)
    regex_replace_chars = string
    label_order         = list(string)
  })
  default = {
    enabled             = true
    namespace           = null
    environment         = null
    stage               = null
    name                = null
    delimiter           = null
    attributes          = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = null
    label_order         = []
  }
  description = <<EOT
Single object for setting entire context at once.
See description of individual variables for details.
Individual variable settings (non-null) override settings in context object,
except for attributesm tags, and additional_tag_map, which are merged.
EOT
}

variable "enabled" {
  type        = bool
  default     = null
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type        = string
  default     = null
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = null
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = null
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = null
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = string
  default     = null
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = "Additional tags for appending to each tag map"
}

variable "label_order" {
  type        = list(string)
  default     = null
  description = "The naming order of the id output and Name tag"
}

variable "regex_replace_chars" {
  type        = string
  default     = null
  description = <<EOT
Regex to replace chars with empty string in
`namespace`, `environment`, `stage` and `name`.
If not set, "/[^a-zA-Z0-9-]/" is used to remove
all characters other than hyphens, letters and digits.
EOT
}

#### End of copy of cloudposse/terraform-null-label/variables.tf

#
# Ensure all variables above are includes in input to module "this" below
#
module "this" {
  source              = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"

  enabled             = var.enabled
  namespace           = var.namespace
  environment         = var.environment
  stage               = var.stage
  name                = var.name
  delimiter           = var.delimiter
  attributes          = var.attributes
  tags                = var.tags
  additional_tag_map  = var.additional_tag_map
  label_order         = var.label_order
  regex_replace_chars = var.regex_replace_chars

  context = var.context
}
