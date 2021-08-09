module "label9" {
  source      = "../../"
  enabled     = true
  static_tags = true

  tags = {
    "kubernetes.io/cluster/" = "shared"
    "City"                   = "Norwich"
  }
}

module "label9_context" {
  source = "../../"

  context = module.label9.context
}

output "label9_context_id" {
  value = module.label9_context.id
}

output "label9_context_context" {
  value = module.label9_context.context
}

// debug
output "label9_context_normalized_context" {
  value = module.label9_context.normalized_context
}

output "label9_context_tags" {
  value = module.label9_context.tags
}

output "label9_id" {
  value = module.label9.id
}

output "label9_context" {
  value = module.label9.context
}

output "label9_tags" {
  value = module.label9.tags
}
