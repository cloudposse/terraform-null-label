module "label2" {
  source              = "../../"
  context             = module.label1.context
  name                = "Charlie"
  stage               = "test"
  delimiter           = "+"
  regex_replace_chars = "/[^a-zA-Z0-9-+]/"

  additional_tag_map = {
    propagate_at_launch = "true"
    additional_tag      = "yes"
  }


  tags = {
    "City"        = "London"
    "Environment" = "Public"
  }
}

output "label2" {
  value = {
    id         = module.label2.id
    name       = module.label2.name
    namespace  = module.label2.namespace
    stage      = module.label2.stage
    attributes = module.label2.attributes
    delimiter  = module.label2.delimiter
  }
}

output "label2_tags" {
  value = module.label2.tags
}

output "label2_tags_as_list_of_maps" {
  value = module.label2.tags_as_list_of_maps
}

output "label2_context" {
  value = module.label2.context
}
