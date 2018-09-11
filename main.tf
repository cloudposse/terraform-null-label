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

  # Provided variables take precedence over the variables from the provided context IF they're not the default
  # if thing == default and if local_context[thing] != ""
  #   local_context[thing]
  # else
  #   thing

  names                          = "${concat(local.context_local["name"], list(""))}"
  name_context_or_default        = "${length(local.names[0]) > 0 ? local.names[0] : var.name}"
  name_or_context                = "${var.name != ""? var.name : local.name_context_or_default}"
  name                           = "${lower(replace(local.name_or_context, "/[^a-zA-Z0-9]/", ""))}"
  namespaces                     = "${concat(local.context_local["namespace"], list(""))}"
  namespace_context_or_default   = "${length(local.namespaces[0]) > 0 ? local.namespaces[0] : var.namespace}"
  namespace_or_context           = "${var.namespace != "" ? var.namespace : local.namespace_context_or_default}"
  namespace                      = "${lower(replace(local.namespace_or_context, "/[^a-zA-Z0-9]/", ""))}"
  environments                   = "${concat(local.context_local["environment"], list(""))}"
  environment_context_or_default = "${length(local.environments[0]) > 0 ? local.environments[0] : var.environment}"
  environment_or_context         = "${var.environment != "" ? var.environment : local.environment_context_or_default}"
  environment                    = "${lower(replace(local.environment_or_context, "/[^a-zA-Z0-9]/", ""))}"
  stages                         = "${concat(local.context_local["stage"], list(""))}"
  stage_context_or_default       = "${length(local.stages[0]) > 0 ? local.stages[0] : var.stage}"
  stage_or_context               = "${var.stage != "" ? var.stage : local.stage_context_or_default}"
  stage                          = "${lower(replace(local.stage_or_context, "/[^a-zA-Z0-9]/", ""))}"
  delimiters                     = "${concat(local.context_local["delimiter"], list(""))}"
  delimiter_context_or_default   = "${length(local.delimiters[0]) > 0 ? local.delimiters[0] : var.delimiter}"
  delimiter                      = "${var.delimiter != "-" ? var.delimiter : local.delimiter_context_or_default}"
  # Merge attributes
  attributes = ["${distinct(compact(concat(var.attributes, local.context_local["attributes"])))}"]
  # Generate tags (don't include tags with empty values)
  generated_tags = "${zipmap(
    compact(list("Name", local.namespace != "" ? "Namespace" : "", local.environment != "" ? "Environment" : "", local.stage != "" ? "Stage" : "")),
    compact(list(local.id, local.namespace, local.environment, local.stage))
    )}"
  tags                     = "${merge(zipmap(local.context_local["tags_keys"], local.context_local["tags_values"]), local.generated_tags, var.tags)}"
  tags_as_list_of_maps     = ["${data.null_data_source.tags_as_list_of_maps.*.outputs}"]
  label_order_default_list = "${list("namespace", "environment", "stage", "name", "attributes")}"
  label_order_context_list = "${distinct(compact(local.context_local["label_order"]))}"
  label_order_final_list   = ["${distinct(compact(coalescelist(var.label_order, local.label_order_context_list, local.label_order_default_list)))}"]
  label_order_length       = "${(length(local.label_order_final_list))}"
  # Context of this label to pass to other label modules
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
    attributes  = "${lower(join(local.delimiter, local.attributes))}"
  }
  id = "${lower(join(local.delimiter, compact(list(
    "${local.label_order_length > 0 ? local.id_context[element(local.label_order_final_list, 0)] : ""}",
    "${local.label_order_length > 1 ? local.id_context[element(local.label_order_final_list, 1)] : ""}",
    "${local.label_order_length > 2 ? local.id_context[element(local.label_order_final_list, 2)] : ""}",
    "${local.label_order_length > 3 ? local.id_context[element(local.label_order_final_list, 3)] : ""}",
    "${local.label_order_length > 4 ? local.id_context[element(local.label_order_final_list, 4)] : ""}"))))}"
}

data "null_data_source" "tags_as_list_of_maps" {
  count = "${local.enabled ? length(keys(local.tags)) : 0}"

  inputs = "${merge(map(
    "key", "${element(keys(local.tags), count.index)}",
    "value", "${element(values(local.tags), count.index)}"
  ),
  var.additional_tag_map)}"
}
