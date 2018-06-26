locals {
  enabled    = "${var.enabled == "true" ? true : false }"
  id         = "${local.enabled ? lower(join(var.delimiter, compact(concat(list(var.namespace, var.stage, var.name), var.attributes)))) : ""}"
  name       = "${local.enabled ? lower(format("%v", var.name)) : ""}"
  namespace  = "${local.enabled ? lower(format("%v", var.namespace)) : ""}"
  stage      = "${local.enabled ? lower(format("%v", var.stage)) : ""}"
  attributes = "${local.enabled ? lower(format("%v", join(var.delimiter, compact(var.attributes)))) : ""}"

  generated_tags = {
    Name = "${local.id}",
    Namespace = "${local.namespace}",
    Stage = "${local.stage}"    
  }

  _tags = {
    tags      = "${var.tags}"
    generated = "${merge(var.tags, local.generated_tags)}"
  }

  tags = "${local._tags[var.exclude_generated_tags ? "tags" : "generated"]}"

  tags_as_list_of_maps = ["${data.null_data_source.tags_as_list_of_maps.*.outputs}"]
}

data "null_data_source" "tags_as_list_of_maps" {
  count = "${length(keys(local.tags))}"

  inputs = "${merge(map(
      "key", "${element(keys(local.tags), count.index)}",
      "value", "${element(values(local.tags), count.index)}"
    ),
    var.additional_tag_map
  )}"
}
