module "label8u" {
  source                  = "../../"
  enabled                 = true
  namespace               = "eg"
  environment             = "demo"
  name                    = "blue"
  attributes              = ["cluster"]
  delimiter               = "-"
  id_case                 = "upper"
  generated_tag_name_case = "upper"

  tags = {
    "kubernetes.io/cluster/" = "shared"
  }
}

module "label8u_context" {
  source = "../../"

  context = module.label8u.context
}

output "label8u_context_id" {
  value = module.label8u_context.id
}

output "label8u_context_context" {
  value = module.label8u_context.context
}

output "label8u_context_tags" {
  value = module.label8u_context.tags
}

output "label8u_id" {
  value = module.label8u.id
}

output "label8u_context" {
  value = module.label8u.context
}

output "label8u_tags" {
  value = module.label8u.tags
}
