module "label2" {
  source    = "../../"
  context   = module.label1.context
  name      = "Charlie"
  stage     = "test"
  delimiter = "+"

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
  }
}

output "label2_tags" {
  value = module.label2.tags
}

output "label2_context" {
  value = module.label2.context
}



