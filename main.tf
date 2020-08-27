locals {

  defaults = {
    label_order         = ["namespace", "environment", "stage", "name", "attributes"]
    regex_replace_chars = "/[^-a-zA-Z0-9]/"
    delimiter           = "-"
    replacement         = ""
    # The `sentinel` should match the `regex_replace_chars`, so it will be replaced with the `replacement` value
    sentinel        = "\t"
    attributes      = []
    id_length_limit = 0
    id_hash_length  = 5
  }

  # So far, we have decided not to allow overriding replacement, sentinel, or id_hash_length
  replacement    = local.defaults.replacement
  sentinel       = local.defaults.sentinel
  id_hash_length = local.defaults.id_hash_length

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
    id_length_limit     = var.id_length_limit == null ? var.context.id_length_limit : var.id_length_limit
  }


  enabled             = local.input.enabled
  regex_replace_chars = coalesce(local.input.regex_replace_chars, local.defaults.regex_replace_chars)

  name            = lower(replace(coalesce(local.input.name, local.sentinel), local.regex_replace_chars, local.replacement))
  namespace       = lower(replace(coalesce(local.input.namespace, local.sentinel), local.regex_replace_chars, local.replacement))
  environment     = lower(replace(coalesce(local.input.environment, local.sentinel), local.regex_replace_chars, local.replacement))
  stage           = lower(replace(coalesce(local.input.stage, local.sentinel), local.regex_replace_chars, local.replacement))
  delimiter       = local.input.delimiter == null ? local.defaults.delimiter : local.input.delimiter
  label_order     = local.input.label_order == null ? local.defaults.label_order : coalescelist(local.input.label_order, local.defaults.label_order)
  id_length_limit = local.input.id_length_limit == null ? local.defaults.id_length_limit : local.input.id_length_limit


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
  # Create a truncated ID if needed
  delimiter_length = length(local.delimiter)
  # Calculate length of normal part of ID, leaving room for delimiter and hash
  id_truncated_length_limit = local.id_length_limit - (local.id_hash_length + local.delimiter_length)
  # Truncate the ID and ensure a single (not double) trailing delimiter
  id_truncated = local.id_truncated_length_limit <= 0 ? "" : "${trimsuffix(substr(local.id_full, 0, local.id_truncated_length_limit), local.delimiter)}${local.delimiter}"
  id_hash      = md5(local.id_full)
  # Create the short ID by adding a hash to the end of the truncated ID
  id_short = substr("${local.id_truncated}${local.id_hash}", 0, local.id_length_limit)
  id       = local.id_length_limit != 0 && length(local.id_full) > local.id_length_limit ? local.id_short : local.id_full


  # Context of this label to pass to other label modules
  output_context = {
    enabled             = local.enabled
    name                = local.name
    namespace           = local.namespace
    environment         = local.environment
    stage               = local.stage
    delimiter           = local.delimiter
    attributes          = local.attributes
    tags                = local.tags
    additional_tag_map  = local.additional_tag_map
    label_order         = local.label_order
    regex_replace_chars = local.regex_replace_chars
    id_length_limit     = local.id_length_limit
  }

}
