output "id" {
  value = "${null_resource.default.triggers.id}"
}

output "name" {
  value = "${null_resource.default.triggers.name}"
}

output "namespace" {
  value = "${null_resource.default.triggers.namespace}"
}

output "stage" {
  value = "${null_resource.default.triggers.stage}"
}

output "attributes" {
  value = "${null_resource.default.triggers.attributes}"
}

# Merge input tags with our tags.
# Note: `Name` has a special meaning in AWS and we need to disamgiuate it by using the computed `id`
output "tags" {
  value = "${
    merge( 
      map(
        "Name", "${null_resource.default.triggers.id}",
        "Namespace", "${null_resource.default.triggers.namespace}",
        "Stage", "${null_resource.default.triggers.stage}"
      ), var.tags
    )
  }"
}
