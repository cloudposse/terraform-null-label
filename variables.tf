variable "namespace" {
  description = "Namespace, which could be your organization name, e.g. 'cp' or 'cloudposse'"
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
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
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}
