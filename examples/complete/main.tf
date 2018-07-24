module "label1" {
  source      = "../../"
  namespace   = "CloudPosse"
  environment = "UAT"
  stage       = "build"
  name        = "Winston Churchroom"
  attributes  = ["fire", "water", "earth", "air"]

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
