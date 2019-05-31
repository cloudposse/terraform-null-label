locals {

  defaults = {
    label_order = ["namespace", "environment", "stage", "name", "attributes"]
    delimiter   = "-"
  }

  # Provided values provided by variables superceed values inherited from the context

  enabled             = var.enabled
  name                = coalesce(var.name, var.context.name)
  namespace           = coalesce(var.namespace, var.context.namespace)
  environment         = coalesce(var.environment, var.context.environment)
  stage               = coalesce(var.stage, var.context.stage)
  regex_replace_chars = coalesce(var.regex_replace_chars, var.context.regex_replace_chars)
  delimiter           = coalesce(var.delimiter, var.context.delimiter, local.defaults.delimiter)
  label_order         = length(var.label_order) > 0 ? var.label_order : (length(var.context.label_order) > 0 ? var.context.label_order : local.defaults.label_order)
  additional_tag_map  = merge(var.context.additional_tag_map, var.additional_tag_map)

  # Merge attributes
  attributes = distinct(
    compact(concat(var.attributes, var.context.attributes))
  )

  # FIXME: need to filter out empty tags
  generated_tags = { for l in keys(local.id_context) : title(l) => local.id_context[l] }

  tags                 = merge(var.context.tags, local.generated_tags, var.tags)
  tags_as_list_of_maps = data.null_data_source.tags_as_list_of_maps.*.outputs

  # Context of this label to pass to other label modules
  output_context = {
    enabled             = local.enabled
    name                = local.name
    namespace           = local.namespace
    environment         = local.environment
    stage               = local.stage
    attributes          = local.attributes
    tags                = local.tags
    delimiter           = local.delimiter
    label_order         = local.label_order
    regex_replace_chars = local.regex_replace_chars
    additional_tag_map  = local.additional_tag_map

  }

  id_context = {
    name        = local.name
    namespace   = local.namespace
    environment = local.environment
    stage       = local.stage
    attributes  = lower(join(local.delimiter, local.attributes))
  }

  labels = [for l in local.label_order : local.id_context[l]]

  id = lower(join(local.delimiter, local.labels))

}

data "null_data_source" "tags_as_list_of_maps" {
  count = local.enabled ? length(keys(local.tags)) : 0

  inputs = merge(
    {
      "key"   = element(keys(local.tags), count.index)
      "value" = element(values(local.tags), count.index)
    },
    var.additional_tag_map,
  )
}

