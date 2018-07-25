
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_tag_map | Additional tags for appending to each tag map. | map | `<map>` | no |
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| context | Default context to use for passing state between label invocations | map | `<map>` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | string | `` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `` | no |
| namespace | Namespace, which could be your organization name, e.g. 'cp' or 'cloudposse' | string | `` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| attributes | Normalized attributes |
| context | Context of this module to pass between other modules |
| delimiter | Delimiter used in label ID |
| environment | Normalized environment |
| id | Disambiguated ID |
| name | Normalized name |
| namespace | Normalized namespace |
| stage | Normalized stage |
| tags | Normalized Tag map |
| tags_as_list_of_maps | Additional tags as a list of maps, which can be used in several AWS resources |

