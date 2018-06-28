locals {
  enabled = "${var.enabled == "true" ? true : false }"

  id = "${lower(join(local.delimiter, compact(concat(list(local.namespace, local.stage, local.name), local.attributes))))}"

  # selected_name : Select which value to use, the one from context, or the one from the var
  # name: Remove spaces, make lowercase

  selected_name       = ["${compact(concat(list(var.name), local.context_local["name"]))}"]
  name                = "${lower(join("", split(" ", local.selected_name[0])))}"
  selected_namespace  = ["${compact(concat(local.context_local["namespace"], list(var.namespace)))}"]
  namespace           = "${lower(join("", split(" ", local.selected_namespace[0])))}"
  selected_stage      = ["${compact(concat(local.context_local["stage"], list(var.stage)))}"]
  stage               = "${lower(join("", split(" ", local.selected_stage[0])))}"
  selected_attributes = ["${distinct(compact(concat(var.attributes, local.context_local["attributes"])))}"]
  attributes          = "${split("~^~", lower(join("~^~", local.selected_attributes)))}"
  selected_delimiter  = ["${distinct(compact(concat(local.context_local["delimiter"], list(var.delimiter))))}"]
  delimiter           = "${lower(join("", split(" ", local.selected_delimiter[0])))}"
  context_local       = "${merge(local.context_context, var.context)}"
  context_context = {
    name        = []
    namespace   = []
    stage       = []
    attributes  = []
    tags_keys   = []
    tags_values = []
    delimiter   = []
  }
  list_attrb = ["${local.context_local["attributes"]}"]
  generated_tags = {
    "Name"      = "${local.id}"
    "Namespace" = "${local.namespace}"
    "Stage"     = "${local.stage}"
  }
  tags                 = "${merge(zipmap(local.context_local["tags_keys"], local.context_local["tags_values"]),local.generated_tags, var.tags )}"
  tags_as_list_of_maps = ["${null_resource.tags_as_list_of_maps.*.triggers}"]
  null_tags = {
    Name      = ""
    Namespace = ""
    Stage     = ""
  }
  context = {
    name        = ["${local.name}"]
    namespace   = ["${local.namespace}"]
    stage       = ["${local.stage}"]
    attributes  = ["${local.attributes}"]
    tags_keys   = ["${keys(local.tags)}"]
    tags_values = ["${values(local.tags)}"]
    delimiter   = ["${var.delimiter}"]
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
