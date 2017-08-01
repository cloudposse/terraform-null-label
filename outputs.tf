output "id" {
  value = "${null_resource.default.triggers.id}"
}

output "Name" {
  value = "${null_resource.default.triggers.name}"
}

output "Namespace" {
  value = "${null_resource.default.triggers.namespace}"
}

output "Stage" {
  value = "${null_resource.default.triggers.stage}"
}

