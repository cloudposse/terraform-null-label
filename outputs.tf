output "id" {
  value       = "${local.id}"
  description = "Disambiguated ID"
}

output "name" {
  value       = "${local.name}"
  description = "Normalized name"
}

output "namespace" {
  value       = "${local.namespace}"
  description = "Normalized namespace"
}

output "stage" {
  value       = "${local.stage}"
  description = "Normalized stage"
}

output "attributes" {
  value       = "${local.attributes}"
  description = "Normalized attributes"
}

# Merge input tags with our tags.
# Note: `Name` has a special meaning in AWS and we need to disamgiuate it by using the computed `id`
output "tags" {
  value = "${
      merge( 
        map(
          "Name", "${local.id}",
          "Namespace", "${local.namespace}",
          "Stage", "${local.stage}"
        ), var.tags
      )
    }"

  description = "Normalized Tag map"
}
