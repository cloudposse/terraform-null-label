module "label1" {
  source     = "../../"
  namespace  = "CloudPosse"
  stage      = "Production"
  name       = "Winston Churchroom"
  attributes = ["fire", "water", "earth", "air"]

  tags = {
    "City"        = "Dublin"
    "Environment" = "Private"
  }
}

module "label2" {
  source  = "../../"
  context = "${module.label1.context}"
  name    = "Charlie"

  tags = {
    "City"        = "London"
    "Environment" = "Public"
  }
}

module "label3" {
  source = "../../"
  name   = "Starfish"

  tags = {
    "Eat"    = "Carrot"
    "Animal" = "Rabbit"
  }
}
