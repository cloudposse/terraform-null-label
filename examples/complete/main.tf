module "label" {
  source     = "../../"
  namespace  = "Namespace"
  stage      = "Stage"
  name       = "Name"
  attributes = ["1", "2", "3", ""]
  tags       = "${map("Key", "Value")}"
}
