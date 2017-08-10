# tf_label

Terraform module designed to generate consistent label names and tags for resources. Use `tf_label` to implement a strict naming convention. 

All Cloud Posse modules use this module to ensure resources can be instantiated multiple times within an account.

## Usage

Include this repository as a module in your existing terraform code:

```
module "example_label" {
  source          = "git::https://github.com/cloudposse/tf_label.git?ref=tags/0.2.0"
  namespace       = "example"
  stage           = "prod"
  name            = "bastion"
  attributes      = "public"
  delimiter       = "-"
  tags            = {"BusinessUnit": "XYZ"}
}
```

This will create an `id` with the value of `example-prod-bastion-public`. 

Now reference the label when creating an instance (for example):
```
resource "aws_instance" "example" {
  instance_type = "t1.micro"
  tags          = "${module.example_label.tags}"
}
```

Or define a security group:
```
resource "aws_security_group" "default" {
  vpc_id = "${var.vpc_id}"
  name   = "${module.example_label.id}"
  tags   = "${module.example_label.tags}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

## Variables

|  Name                        |  Default       |  Decription                                              | Required |
|:----------------------------:|:--------------:|:--------------------------------------------------------:|:--------:|
| namespace                    | ``             | Namespace (e.g. `cp` or `cloudposse`)                    | Yes      |
| stage                        | ``             | Stage (e.g. `prod`, `dev`, `staging`                     | Yes      |
| name                         | ``             | Name  (e.g. `bastion` or `db`)                           | Yes      | 
| attributes                   | []             | Additional attributes (e.g. `policy` or `role`)          | No       | 
| tags                         | {}             | Additional tags  (e.g. `{"BusinessUnit": "XYZ"}`         | No       |

## Outputs

| Name              | Decription            |
|:-----------------:|:---------------------:|
| id                | Disambiguated ID      |
| name              | Normalized name       |
| namespace         | Normalized namespace  |
| stage             | Normalized stage      |
| attributes        | Normalized attributes |
| tags              | Normalized Tag map    |

