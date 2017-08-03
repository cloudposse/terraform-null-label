output "id" {
  value = "${null_resource.default.triggers.id}"
}

output "tags" {
  value = "${
    map(
      "Name", "${null_resource.default.triggers.id}",
      "Namespace", "${null_resource.default.triggers.namespace}",
      "Stage", "${null_resource.default.triggers.stage}"
    )
  }"
}
