locals {
  enabled = "${var.enabled == "true" ? true : false }"

  # Only maps that contain all the same attribute types can be merged, so the values have been set to list
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

  # Merge the map of empty values, with the variable context, so that context_local always contains all map keys
  context_local = "${merge(local.context_struct, var.context)}"

  # Provided variables take precedence over the variables from the provided context
  selected_name = ["${coalescelist(compact(list(var.name)), compact(local.context_local["name"]), list(""))}"]
  name          = "${lower(replace(local.selected_name[0], "/[^a-zA-Z0-9]/", ""))}"

  selected_namespace = ["${coalescelist(compact(list(var.namespace)), compact(local.context_local["namespace"]), list(""))}"]
  namespace          = "${lower(replace(local.selected_namespace[0], "/[^a-zA-Z0-9]/", ""))}"

  selected_environment = ["${coalescelist(compact(list(var.environment)), compact(local.context_local["environment"]), list(""))}"]
  environment          = "${lower(replace(local.selected_environment[0], "/[^a-zA-Z0-9]/", ""))}"

  selected_stage = ["${coalescelist(compact(list(var.stage)), compact(local.context_local["stage"]), list(""))}"]
  stage          = "${lower(replace(local.selected_stage[0], "/[^a-zA-Z0-9]/", ""))}"

  selected_delimiter = ["${coalescelist(compact(list(var.delimiter)), compact(local.context_local["delimiter"]), list(""))}"]
  delimiter          = "${local.selected_delimiter[0]}"

  selected_attributes = ["${distinct(compact(concat(var.attributes, local.context_local["attributes"])))}"]
  attributes          = "${lower(join(local.delimiter, local.selected_attributes))}"

  generated_tags = {
    "Name"        = "${local.id}"
    "Namespace"   = "${local.namespace}"
    "Environment" = "${local.environment}"
    "Stage"       = "${local.stage}"
  }

  tags                 = "${merge(zipmap(local.context_local["tags_keys"], local.context_local["tags_values"]), local.generated_tags, var.tags)}"
  tags_count           = "${length(keys(local.tags))}"
  tags_as_list_of_maps = ["${data.null_data_source.tags_as_list_of_maps.*.outputs}"]

  label_order_default_list = "${list("namespace", "environment", "stage", "name", "attributes")}"
  label_order_context_list = "${distinct(compact(local.context_local["label_order"]))}"
  label_order_final_list   = ["${distinct(compact(coalescelist(var.label_order, local.label_order_context_list, local.label_order_default_list)))}"]
  label_order_length       = "${(length(local.label_order_final_list))}"

  # Context of this module to pass between other modules
  output_context = {
    name        = ["${local.name}"]
    namespace   = ["${local.namespace}"]
    environment = ["${local.environment}"]
    stage       = ["${local.stage}"]
    attributes  = ["${local.attributes}"]
    tags_keys   = ["${keys(local.tags)}"]
    tags_values = ["${values(local.tags)}"]
    delimiter   = ["${local.delimiter}"]
    label_order = ["${local.label_order_final_list}"]
  }

  id_context = {
    name        = "${local.name}"
    namespace   = "${local.namespace}"
    environment = "${local.environment}"
    stage       = "${local.stage}"
    attributes  = "${local.attributes}"
  }

  id = "${lower(join(local.delimiter, compact(list(
    "${local.label_order_length > 0 ? local.id_context[element(local.label_order_final_list, 0)] : ""}",
    "${local.label_order_length > 1 ? local.id_context[element(local.label_order_final_list, 1)] : ""}",
    "${local.label_order_length > 2 ? local.id_context[element(local.label_order_final_list, 2)] : ""}",
    "${local.label_order_length > 3 ? local.id_context[element(local.label_order_final_list, 3)] : ""}",
    "${local.label_order_length > 4 ? local.id_context[element(local.label_order_final_list, 4)] : ""}"))))}"
}

data "null_data_source" "tags_as_list_of_maps" {
  count = "${local.enabled ? local.tags_count : 0}"

  inputs = "${merge(map(
    "key", "${element(keys(local.tags), count.index)}",
    "value", "${element(values(local.tags), count.index)}"
  ),
  var.additional_tag_map)}"
}
