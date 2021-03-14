# Tests for id_lengths

# Variable only
module "label9v" {
  source      = "../../"
  namespace   = "CloudPosse"
  environment = "UAT"
  stage       = "build"
  name        = "Winston Churchroom"
  id_lengths  = [10, 15]
}

output "label9v_ids" {
  value = module.label9v.id_trunc
}

# Context only
module "label9c" {
  source  = "../../"
  context = module.label9v.context
}

output "label9c_ids" {
  value = module.label9c.id_trunc
}

# Context and variable
module "label9cv" {
  source     = "../../"
  context    = module.label9v.context
  id_lengths = [30, 50]
}

output "label9cv_ids" {
  value = module.label9cv.id_trunc
}
