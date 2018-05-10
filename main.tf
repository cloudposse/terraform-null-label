locals {
  enabled    = "${var.enabled == "true" ? true : false }"
  id         = "${local.enabled ? lower(join(var.delimiter, compact(concat(list(var.namespace, var.stage, var.name), var.attributes)))) : ""}"
  name       = "${local.enabled ? lower(format("%v", var.name)) : ""}"
  namespace  = "${local.enabled ? lower(format("%v", var.namespace)) : ""}"
  stage      = "${local.enabled ? lower(format("%v", var.stage)) : ""}"
  attributes = "${local.enabled ? lower(format("%v", join(var.delimiter, compact(var.attributes)))) : ""}"

  tags = "${
      merge( 
        map(
          "Name", "${local.id}",
          "Namespace", "${local.namespace}",
          "Stage", "${local.stage}"
        ), var.tags
      )
    }"

  tags_asg_propagate_true  = ["${null_resource.tags_asg_propagate_true.*.triggers}"]
  tags_asg_propagate_false = ["${null_resource.tags_asg_propagate_false.*.triggers}"]
}

provider "null" {
  version = "~> 1.0"
}

resource "null_resource" "tags_asg_propagate_true" {
  count = "${length(keys(local.tags))}"

  triggers {
    key                 = "${element(keys(local.tags), count.index)}"
    value               = "${element(values(local.tags), count.index)}"
    propagate_at_launch = "true"
  }
}

resource "null_resource" "tags_asg_propagate_false" {
  count = "${length(keys(local.tags))}"

  triggers {
    key                 = "${element(keys(local.tags), count.index)}"
    value               = "${element(values(local.tags), count.index)}"
    propagate_at_launch = "false"
  }
}
