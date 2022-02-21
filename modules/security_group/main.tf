locals {
  security_group_rules_yaml  = yamldecode(file(var.security_group_rules_yaml_file))
  sg_rules                   = (local.security_group_rules_yaml.rules == null) ? {} : local.security_group_rules_yaml.rules
  sg_tags                    = (local.security_group_rules_yaml.tags == null) ? {} : local.security_group_rules_yaml.tags
  security_group_name        = local.security_group_rules_yaml.security_group_name
  security_group_description = local.security_group_rules_yaml.security_group_description
}

resource "aws_security_group" "sg" {
  name        = local.security_group_name
  description = local.security_group_description
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    for tag in local.sg_tags:
      tag.name => tag.value
  }
}

resource "aws_security_group_rule" "sg_rule" {
  for_each          = local.sg_rules
  type              = each.value.type
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = each.value.description
  depends_on = [
    aws_security_group.sg
  ]
}
