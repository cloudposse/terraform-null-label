resource "null_resource" "default" {
  triggers = {
    id = "${lower(format("%v-%v-%v", var.namespace, var.stage, var.name))}"
    name = "${lower(format("%v", var.name))}"
    namespace = "${lower(format("%v", var.namespace))}"
    stage = "${lower(format("%v", var.stage))}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
