locals {
  enabled = "${var.enabled == "true" ? true : false }"

  id = "${lower(join(local.delimiter, compact(concat(list(local.namespace, local.stage, local.name), local.attributes))))}"

  # selected_name : Select which value to use, the one from context, or the one from the var
  # name: Remove spaces, make lowercase

  selected_name       = ["${compact(concat(local.context_local["name"], list(var.name)))}"]
  name                = "${lower(join("", split(" ", join("",local.selected_name))))}"
  selected_namespace  = ["${compact(concat(local.context_local["namespace"], list(var.namespace)))}"]
  namespace           = "${lower(join("", split(" ", join("",local.selected_namespace))))}"
  selected_stage      = ["${compact(concat(local.context_local["stage"], list(var.stage)))}"]
  stage               = "${lower(join("", split(" ", join("",local.selected_stage))))}"
  selected_attributes = ["${distinct(compact(concat(var.attributes, local.context_local["attributes"])))}"]
  attributes          = "${split("~^~", lower(join("~^~", local.selected_attributes)))}"
  selected_delimiter  = ["${compact(concat(local.context_local["delimiter"], list(var.delimiter)))}"]
  delimiter           = "${lower(join("", split(" ", join("",distinct(local.selected_delimiter)))))}"
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
  tags                 = "${merge(local.generated_tags, zipmap(local.context_local["tags_keys"], local.context_local["tags_values"]),var.tags, )}"
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
