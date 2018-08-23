module "label1" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = "CloudPosse"
  environment = "UAT"
  stage       = "build"
  name        = "Winston Churchroom"
  attributes  = ["fire", "water", "earth", "air"]

  label_order = ["name", "environment", "stage"]

  tags = {
    "City"        = "Dublin"
    "Environment" = "Private"
  }
}

module "label2" {
  source  = "../../"
  context = "${module.label1.context}"
  name    = "Charlie"
  stage   = "test"

  tags = {
    "City"        = "London"
    "Environment" = "Public"
  }
}

module "label3" {
  source = "../../"
  name   = "Starfish"
  stage  = "release"

  tags = {
    "Eat"    = "Carrot"
    "Animal" = "Rabbit"
  }
}
