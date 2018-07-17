output "id" {
  value       = "${local.enabled ? local.id : ""}"
  description = "Disambiguated ID"
}

output "name" {
  value       = "${local.enabled ? local.name : ""}"
  description = "Normalized name"
}

output "namespace" {
  value       = "${local.enabled ? local.namespace : ""}"
  description = "Normalized namespace"
}

output "stage" {
  value       = "${local.enabled ? local.stage : ""}"
  description = "Normalized stage"
}

output "attributes" {
  value       = "${local.enabled ? local.attributes : ""}"
  description = "Normalized attributes"
}

output "tags" {
  value       = "${local.tags}"
  description = "Normalized Tag map"
}

output "tags_as_list_of_maps" {
  value       = ["${local.tags_as_list_of_maps}"]
  description = "Additional tags as a list of maps, which can be used in several AWS resources"
}

output "context" {
  value       = "${local.context}"
  description = "Context of this module to pass between other modules"
}

output "delimiter" {
  value       = "${local.delimiter}"
  description = "Delimiter used in label ID"
}
