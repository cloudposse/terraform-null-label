resource "null_resource" "default" {
  triggers = {
    id = "${lower(join("-", compact(list(var.namespace, var.stage, var.module, var.name))))}"
    name = "${lower(format("%v", var.name))}"
    namespace = "${lower(format("%v", var.namespace))}"
    stage = "${lower(format("%v", var.stage))}"
    module = "${lower(format("%v", var.module))}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
