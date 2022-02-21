provider "aws" {
    region = var.region
}

locals {
    yamlservers = yamldecode(file("app_servers.yaml"))
    appservers = ( local.yamlservers.app_servers == null ) ? {} : local.yamlservers.app_servers
}

module "security_groups" {
    source = "./modules/security_group"
    for_each = fileset("${path.root}/variables/security_groups","*.yaml")
    # security_group_name = "ux_app"
    # security_group_description = "ux_app security group"
    vpc_id = var.vpc_id
    security_group_rules_yaml_file = "${path.root}/variables/security_groups/${each.value}"
}
data "aws_security_groups" "sgroups" {
    filter {
        name = "vpc-id"
        values = [var.vpc_id]
    }
    depends_on = [
        module.security_groups
    ]
}

resource "aws_key_pair" "ux_app_key" {
    key_name = "ux_app_key"
    public_key = var.ux_app_public_key
}

resource "aws_instance" "ux_app" {
    for_each = local.appservers
    #for_each = var.app_servers
    ami = each.value.ami != "" ? each.value.ami : var.default_ami
    instance_type = each.value.instance_type != "" ? each.value.instance_type : var.default_instance_type
    key_name = aws_key_pair.ux_app_key.key_name
    vpc_security_group_ids = tolist(data.aws_security_groups.sgroups.ids)    
    #vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    tags = {
        Name = each.key
        Environment = each.value.env
    }
    depends_on = [
      aws_key_pair.ux_app_key,
      data.aws_security_groups.sgroups
    ]
}