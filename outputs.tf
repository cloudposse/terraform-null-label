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
  value = "${local.tags}"

  description = "Normalized Tag map"
}

output "tags_asg_propagate_true" {
  value       = ["${local.tags_asg_propagate_true}"]
  description = "Additional tags for adding to EC2 servers in an autoscaling group"
}

output "tags_asg_propagate_false" {
  value       = ["${local.tags_asg_propagate_false}"]
  description = "Additional tags for adding to an autoscaling group"
}
