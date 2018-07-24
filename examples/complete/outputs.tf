output "label1" {
  value = {
    id         = "${module.label1.id}"
    name       = "${module.label1.name}"
    namespace  = "${module.label1.namespace}"
    stage      = "${module.label1.stage}"
    attributes = "${module.label1.attributes}"
  }
}

output "label2" {
  value = {
    id         = "${module.label2.id}"
    name       = "${module.label2.name}"
    namespace  = "${module.label2.namespace}"
    stage      = "${module.label2.stage}"
    attributes = "${module.label2.attributes}"
  }
}

output "label3" {
  value = {
    id         = "${module.label3.id}"
    name       = "${module.label3.name}"
    namespace  = "${module.label3.namespace}"
    stage      = "${module.label3.stage}"
    attributes = "${module.label3.attributes}"
  }
}

output "label1_tags" {
  value = "${module.label1.tags}"
}

output "label1_context" {
  value = "${module.label1.context}"
}

output "label2_tags" {
  value = "${module.label2.tags}"
}

output "label2_context" {
  value = "${module.label2.context}"
}

output "label3_tags" {
  value = "${module.label3.tags}"
}

output "label3_context" {
  value = "${module.label3.context}"
}
