module "label1" {
  source     = "../../"
  namespace  = "Namespace"
  stage      = "Stage"
  name       = "Name"
  attributes = ["1", "2", "3", ""]

  tags = {
    "SomeKey" = "SomeValue"
  }
}

module "label2" {
  source  = "../../"
  context = "${module.label1.context}"
  name    = "Test"
}
