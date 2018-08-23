variable "namespace" {
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
  default     = ""
}

variable "environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  default     = ""
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  default     = ""
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "additional_tag_map" {
  type        = "map"
  default     = {}
  description = "Additional tags for appending to each tag map"
}

variable "context" {
  type        = "map"
  default     = {}
  description = "Default context to use for passing state between label invocations"
}

variable "label_order" {
  type        = "list"
  description = "The naming order of the id output and Name tag"
  default     = []
}
