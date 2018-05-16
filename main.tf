locals {
  enabled    = "${var.enabled == "true" ? true : false }"
  id         = "${local.enabled ? lower(join(var.delimiter, compact(concat(list(var.namespace, var.stage, var.name), var.attributes)))) : ""}"
  name       = "${local.enabled ? lower(format("%v", var.name)) : ""}"
  namespace  = "${local.enabled ? lower(format("%v", var.namespace)) : ""}"
  stage      = "${local.enabled ? lower(format("%v", var.stage)) : ""}"
  attributes = "${local.enabled ? lower(format("%v", join(var.delimiter, compact(var.attributes)))) : ""}"

  tags = "${
      merge( 
        map(
          "Name", "${local.id}",
          "Namespace", "${local.namespace}",
          "Stage", "${local.stage}"
        ), var.tags
      )
    }"

  tags_as_list_of_maps = ["${null_resource.tags_as_list_of_maps.*.triggers}"]
}

resource "null_resource" "tags_as_list_of_maps" {
  count = "${length(keys(local.tags))}"

  triggers = "${merge(map(
    "key", "${element(keys(local.tags), count.index)}",
    "value", "${element(values(local.tags), count.index)}"
  ),
  var.additional_tag_map)}"
}
