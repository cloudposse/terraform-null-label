locals {
  enabled    = "${var.enabled == "true" ? true : false }"

  id         = "${lower(join(var.delimiter, compact(concat(list(local.namespace, local.stage, local.name, local.attributes)))))}"
  name       = "${var.name == "" ? lookup(var.context, "name", "") : lower(format("%v", var.name))}"
  namespace  = "${var.namespace == "" ? lookup(var.context, "namespace", "") : lower(format("%v", var.namespace))}"
  stage      = "${var.stage == "" ? lookup(var.context, "stage", "") : lower(format("%v", var.stage))}"
  attributes = "${length(var.attributes) == 0 ? lookup(var.context, "attributes", "") : lower(format("%v", join(var.delimiter, compact(var.attributes))))}"

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

  context    = {
    name       = "${local.name}"
    namespace  = "${local.namespace}"
    stage      = "${local.stage}"
    attributes = "${local.attributes}"
    tags       = "${local.tags}"
    delimiter  = "${var.delimiter}"
  }
}

resource "null_resource" "tags_as_list_of_maps" {
  count = "${local.enabled ? length(keys(local.tags)) : 0}"

  triggers = "${merge(map(
    "key", "${element(keys(local.tags), count.index)}",
    "value", "${element(values(local.tags), count.index)}"
  ),
  var.additional_tag_map)}"
}
