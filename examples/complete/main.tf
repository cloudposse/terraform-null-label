module "label1" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = "CloudPosse"
  environment = "UAT"
  stage       = "build"
  name        = "Winston Churchroom"
  attributes  = ["fire", "water", "earth", "air"]
  delimiter   = "-"

  label_order = ["name", "environment", "stage", "attributes"]

  tags = {
    "City"        = "Dublin"
    "Environment" = "Private"
  }
}

module "label2" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  context   = "${module.label1.context}"
  name      = "Charlie"
  stage     = "test"
  delimiter = "+"

  tags = {
    "City"        = "London"
    "Environment" = "Public"
  }
}

module "label3" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  name      = "Starfish"
  stage     = "release"
  context   = "${module.label1.context}"
  delimiter = "."

  tags = {
    "Eat"    = "Carrot"
    "Animal" = "Rabbit"
  }
}
