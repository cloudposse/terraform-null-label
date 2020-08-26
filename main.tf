locals {

  defaults = {
    label_order         = ["namespace", "environment", "stage", "name", "attributes"]
    regex_replace_chars = "/[^-a-zA-Z0-9]/"
    delimiter           = "-"
    replacement         = ""
    # The `sentinel` should match the `regex_replace_chars`, so it will be replaced with the `replacement` value
    sentinel   = "\t"
    attributes = []
  }

  # So far, we have decided not to allow overriding replacement or sentinel
  replacement = local.defaults.replacement
  sentinel    = local.defaults.sentinel

  # The values provided by variables supersede the values inherited from the context object
  input = {
    # It would be nice to use coalesce here, but we cannot, because it
    # is an error for all the arguments to coalesce to be empty.
    enabled     = var.enabled == null ? var.context.enabled : var.enabled
    namespace   = var.namespace == null ? var.context.namespace : var.namespace
    environment = var.environment == null ? var.context.environment : var.environment
    stage       = var.stage == null ? var.context.stage : var.stage
    name        = var.name == null ? var.context.name : var.name
    delimiter   = var.delimiter == null ? var.context.delimiter : var.delimiter
    attributes  = compact(distinct(concat(var.attributes, var.context.attributes)))
    tags        = merge(var.context.tags, var.tags)

    additional_tag_map  = merge(var.context.additional_tag_map, var.additional_tag_map)
    label_order         = var.label_order == null ? var.context.label_order : var.label_order
    regex_replace_chars = var.regex_replace_chars == null ? var.context.regex_replace_chars : var.regex_replace_chars
  }


  enabled             = local.input.enabled
  regex_replace_chars = coalesce(local.input.regex_replace_chars, local.defaults.regex_replace_chars)

  name               = lower(replace(coalesce(local.input.name, local.sentinel), local.regex_replace_chars, local.replacement))
  namespace          = lower(replace(coalesce(local.input.namespace, local.sentinel), local.regex_replace_chars, local.replacement))
  environment        = lower(replace(coalesce(local.input.environment, local.sentinel), local.regex_replace_chars, local.replacement))
  stage              = lower(replace(coalesce(local.input.stage, local.sentinel), local.regex_replace_chars, local.replacement))
  delimiter          = coalesce(local.input.delimiter, local.defaults.delimiter)
  label_order        = local.input.label_order == null ? local.defaults.label_order : coalescelist(local.input.label_order, local.defaults.label_order)
  additional_tag_map = merge(var.context.additional_tag_map, var.additional_tag_map)

  # Merge attributes
  attributes = compact(distinct(concat(local.input.attributes, local.defaults.attributes)))

  tags = merge(local.generated_tags, local.input.tags)

  tags_as_list_of_maps = flatten([
    for key in keys(local.tags) : merge(
      {
        key   = key
        value = local.tags[key]
    }, var.additional_tag_map)
  ])

  tags_context = {
    # For AWS we need `Name` to be disambiguated since it has a special meaning
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
    attributes  = lower(replace(join(local.delimiter, local.attributes), local.regex_replace_chars, local.replacement))
  }

  labels = [for l in local.label_order : local.id_context[l] if length(local.id_context[l]) > 0]

  id_full = lower(join(local.delimiter, local.labels))
  id_md5  = md5(local.id_full)
  # Truncates ID to given max length, suffixed by 6 character hash of ID for disambiguation 
  id_short = (var.id_max_length <= 6 ?
    substr(local.id_md5, 0, var.id_max_length) :
  "${replace(substr(local.id_full, 0, var.id_max_length - 6), "/-$/", "")}-${substr(local.id_md5, 0, 5)}")
  id = var.id_max_length != 0 && length(local.id_full) > var.id_max_length ? local.id_short : local.id_full


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
