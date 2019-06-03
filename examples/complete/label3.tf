module "label3" {
  source    = "../../"
  name      = "Starfish"
  stage     = "release"
  context   = module.label1.context
  delimiter = "."

  tags = {
    "Eat"    = "Carrot"
    "Animal" = "Rabbit"
  }
}

output "label3" {
  value = {
    id         = module.label3.id
    name       = module.label3.name
    namespace  = module.label3.namespace
    stage      = module.label3.stage
    attributes = module.label3.attributes
  }
}

output "label3_tags" {
  value = module.label3.tags
}

output "label3_context" {
  value = module.label3.context
}
