output "id" {
  value       = "${local.id}"
  description = "Disambiguated ID"
}

output "name" {
  value       = "${local.name}"
  description = "Normalized name"
}

output "env" {
  value       = "${local.env}"
  description = "Normalized Env"
}

output "stack" {
  value       = "${local.stack}"
  description = "Normalized Stack"
}

output "tags" {
  value       = "${local.tags}"
  description = "Normalized Tag map"
}
