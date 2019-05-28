module "label1" {
  source      = "../../"
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
  source    = "../../"
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
  source    = "../../"
  name      = "Starfish"
  stage     = "release"
  context   = "${module.label1.context}"
  delimiter = "."

  tags = {
    "Eat"    = "Carrot"
    "Animal" = "Rabbit"
  }
}
