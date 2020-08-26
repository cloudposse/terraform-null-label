module "label3i" {
  source              = "../../"
  name                = "Starfish"
  stage               = "release"
  context             = module.label1.input
  delimiter           = "."
  regex_replace_chars = "/[^-a-zA-Z0-9.]/"

  tags = {
    "Eat"    = "Carrot"
    "Animal" = "Rabbit"
  }
}

output "label3i" {
  value = {
    id         = module.label3i.id
    name       = module.label3i.name
    namespace  = module.label3i.namespace
    stage      = module.label3i.stage
    attributes = module.label3i.attributes
    delimiter  = module.label3i.delimiter
  }
}

output "label3i_tags" {
  value = module.label3i.tags
}

output "label3i_context" {
  value = module.label3i.context
}

output "label3i_input" {
  value = module.label3i.input
}
