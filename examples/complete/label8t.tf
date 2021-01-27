module "label8t" {
  source                  = "../../"
  enabled                 = true
  namespace               = "eg"
  environment             = "demo"
  name                    = "blue"
  attributes              = ["cluster"]
  delimiter               = "-"
  id_case                 = "title"
  generated_tag_name_case = "title"

  tags = {
    "kubernetes.io/cluster/" = "shared"
  }
}

module "label8t_context" {
  source = "../../"

  context = module.label8t.context
}

output "label8t_context_id" {
  value = module.label8t_context.id
}

output "label8t_context_context" {
  value = module.label8t_context.context
}

output "label8t_context_tags" {
  value = module.label8t_context.tags
}

output "label8t_id" {
  value = module.label8t.id
}

output "label8t_context" {
  value = module.label8t.context
}

output "label8t_tags" {
  value = module.label8t.tags
}
