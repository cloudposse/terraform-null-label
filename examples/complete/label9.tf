module "label9" {
  source      = "../../"
  namespace   = "CloudPosse"
  environment = "UAT"
  stage       = "build"
  name        = "Winston Churchroom"
  id_lengths  = [10, 15, 30, 50]
}

output "label9_truncated_ids" {
  value = {
    id  = module.label9.id
    ids = module.label9.id_trunc
  }
}
