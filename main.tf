locals {
  enabled = "${var.enabled == "true" ? true : false }"

  sort_map = "${map("${index(local.label_order_local, "namespace")}", local.namespace, "${index(local.label_order_local, "environment")}", local.environment, "${index(local.label_order_local, "stage")}", local.stage, "${index(local.label_order_local, "name")}", local.name, "${index(local.label_order_local, "attributes")}", local.attributes)}"

  id = "${lower(join(local.delimiter, compact(concat(list(
    "${local.label_order_length >= 0 ? local.sort_map["0"] : ""}", 
    "${local.label_order_length >= 1 ? local.sort_map["1"] : ""}", 
    "${local.label_order_length >= 2 ? local.sort_map["2"] : ""}", 
    "${local.label_order_length >= 3 ? local.sort_map["3"] : ""}", 
    "${local.label_order_length >= 4 ? local.sort_map["4"] : ""}")))))}"

  # selected_name : Select which value to use, the one from context, or the one from the var
  # name: Remove spaces, make lowercase

  selected_name        = ["${concat(compact(concat(list(var.name), local.context_local["name"])), list(""))}"]
  name                 = "${lower(replace(local.selected_name[0], "/[^a-zA-Z0-9]/", ""))}"
  selected_namespace   = ["${concat(compact(concat(local.context_local["namespace"], list(var.namespace))), list(""))}"]
  namespace            = "${lower(replace(local.selected_namespace[0], "/[^a-zA-Z0-9]/", ""))}"
  selected_environment = ["${concat(compact(concat(local.context_local["environment"], list(var.environment))), list(""))}"]
  environment          = "${lower(replace(local.selected_environment[0], "/[^a-zA-Z0-9]/", ""))}"
  selected_stage       = ["${concat(compact(concat(local.context_local["stage"], list(var.stage))),list(""))}"]
  stage                = "${lower(replace(local.selected_stage[0], "/[^a-zA-Z0-9]/", ""))}"
  selected_attributes  = ["${distinct(compact(concat(var.attributes, local.context_local["attributes"])))}"]
  attributes           = "${lower(join(local.delimiter, local.selected_attributes))}"
  selected_delimiter   = ["${distinct(compact(concat(local.context_local["delimiter"], list(var.delimiter))))}"]
  delimiter            = "${local.selected_delimiter[0]}"
  label_order_length   = "${max(length(var.label_order), length(local.context_local["label_order"])) - 1}"
  label_order_default  = "${list("namespace", "environment", "stage", "name", "attributes")}"
  label_order_local    = "${split("~^~", local.label_order_length < 0 ? join("~^~", local.label_order_default) : join("~^~", local.label_order_temp))}"
  label_order          = ["${distinct(compact(coalescelist(var.label_order, local.context_local["label_order"])))}"]
  label_order_temp     = ["${distinct(compact(concat(local.label_order, list("namespace", "environment", "stage", "name", "attributes"))))}"]
  # Merge the map of empty values, with the variable context, so that context_local always contains all map keys
  context_local = "${merge(local.context_struct, var.context)}"
  # Only maps that contain all the same attribute types can be merged, so they have been set to list
  context_struct = {
    name        = []
    namespace   = []
    environment = []
    stage       = []
    attributes  = []
    tags_keys   = []
    tags_values = []
    delimiter   = []
    label_order = []
  }
  generated_tags = {
    "Name"        = "${local.id}"
    "Namespace"   = "${local.namespace}"
    "Environment" = "${local.environment}"
    "Stage"       = "${local.stage}"
  }
  tags                 = "${merge(zipmap(local.context_local["tags_keys"], local.context_local["tags_values"]),local.generated_tags, var.tags )}"
  tags_as_list_of_maps = ["${data.null_data_source.tags_as_list_of_maps.*.outputs}"]
  context = {
    name        = ["${local.name}"]
    namespace   = ["${local.namespace}"]
    environment = ["${local.environment}"]
    stage       = ["${local.stage}"]
    attributes  = ["${local.attributes}"]
    tags_keys   = ["${keys(local.tags)}"]
    tags_values = ["${values(local.tags)}"]
    delimiter   = ["${local.delimiter}"]
    label_order = ["${slice(local.label_order_local, 0, local.label_order_length + 1)}"]
  }
}

data "null_data_source" "tags_as_list_of_maps" {
  count = "${local.enabled ? length(keys(local.tags)) : 0}"

  inputs = "${merge(map(
    "key", "${element(keys(local.tags), count.index)}",
    "value", "${element(values(local.tags), count.index)}"
  ),
  var.additional_tag_map)}"
}
