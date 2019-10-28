locals {

  defaults = {
    label_order = ["namespace", "environment", "stage", "name", "attributes"]
    delimiter   = "-"
    replacement = ""
    # The `sentinel` should match the `regex_replace_chars`, so it will be replaced with the `replacement` value
    sentinel   = "~"
    attributes = [""]
  }

  # The values provided by variables superceed the values inherited from the context

  enabled             = var.enabled
  regex_replace_chars = coalesce(var.regex_replace_chars, var.context.regex_replace_chars)

  name               = lower(replace(coalesce(var.name, var.context.name, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  namespace          = lower(replace(coalesce(var.namespace, var.context.namespace, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  environment        = lower(replace(coalesce(var.environment, var.context.environment, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  stage              = lower(replace(coalesce(var.stage, var.context.stage, local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  delimiter          = coalesce(var.delimiter, var.context.delimiter, local.defaults.delimiter)
  label_order        = length(var.label_order) > 0 ? var.label_order : (length(var.context.label_order) > 0 ? var.context.label_order : local.defaults.label_order)
  additional_tag_map = merge(var.context.additional_tag_map, var.additional_tag_map)

  # Merge attributes
  attributes = compact(distinct(concat(var.attributes, var.context.attributes, local.defaults.attributes)))

  tags = merge(var.context.tags, local.generated_tags, var.tags)

  tags_as_list_of_maps = flatten([
    for key in keys(local.tags) : merge(
      {
        key   = key
        value = local.tags[key]
    }, var.additional_tag_map)
  ])

  tags_context = {
    # For AWS we need `Name` to be disambiguated sine it has a special meaning
    name        = local.id
    namespace   = local.namespace
    environment = local.environment
    stage       = local.stage
    attributes  = local.id_context.attributes
  }

  generated_tags = { for l in keys(local.tags_context) : title(l) => local.tags_context[l] if length(local.tags_context[l]) > 0 }

  id_context = {
    name        = local.name
    namespace   = local.namespace
    environment = local.environment
    stage       = local.stage
    attributes  = lower(replace(join(local.delimiter, local.attributes), local.regex_replace_chars, local.defaults.replacement))
  }

  labels = [for l in local.label_order : local.id_context[l] if length(local.id_context[l]) > 0]

  id = lower(join(local.delimiter, local.labels))

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

}
