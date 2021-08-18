module "label9a" {
  source        = "../../"
  enabled       = true
  suppress_tags = ["environment"]
  environment   = "demo"
  name          = "red"

  tags = {
    "kubernetes.io/cluster/" = "shared"
    "City"                   = "Norwich"
  }
}

module "label9a_context" {
  source = "../../"

  context = module.label9a.context
}

output "label9a_context_id" {
  value = module.label9a_context.id
}

output "label9a_context_context" {
  value = module.label9a_context.context
}

// debug
output "label9a_context_normalized_context" {
  value = module.label9a_context.normalized_context
}

output "label9a_context_tags" {
  value = module.label9a_context.tags
}

output "label9a_id" {
  value = module.label9a.id
}

output "label9a_context" {
  value = module.label9a.context
}

output "label9a_tags" {
  value = module.label9a.tags
}
