module "test" {
  source = "../"
  namespace = "Namespace"
  stage = "Stage"
  name = "Name"
  attributes = ["1", "2", "3", ""]
  tags = "${map("Key", "Value")}"
}

output "id" {
  value = "${module.test.id}"
}

output "name" {
  value = "${module.test.name}"
}

output "namespace" {
  value = "${module.test.namespace}"
}

output "stage" {
  value = "${module.test.stage}"
}

output "attributes" {
  value = "${module.test.attributes}"
}

output "tags" {
  value = "${module.test.tags}"
}
