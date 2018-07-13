locals {
  id         = "${lower(join(var.delimiter, compact(list(var.name, "rival", local.env))))}"
  name       = "${lower(format("%v", var.name))}"

  # If you don't have these set in the tags, an error will be raised
  env        = "${var.tags["Env"]}"
  stack      = "${var.tags["Stack"]}"

  tags = "${
      merge( 
        map(
          "Name", "${local.id}",
          "tf", "true"
        ), var.tags
      )
    }"
}
