provider "aws" {
    region = var.region
}

# variable "vpc_id" {
#     type = string
#     default = var.vpc_id
# }

# data "aws_vpc" "selected" {
#     id = var.vpc_id
# }

locals {
    yamlservers = yamldecode(file("app_servers.yaml"))
    appservers = ( local.yamlservers.app_servers == null ) ? {} : local.yamlservers.app_servers
}

resource "aws_security_group" "allow_ssh" {
    name = "allow_ssh"
    vpc_id = var.vpc_id
    description = "Allow SSH inbound traffic"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh"
        Environment = "Linux"
    }
}

data "aws_security_groups" "sgroups" {
    filter {
        name = "vpc-id"
        values = [var.vpc_id]
    }
    depends_on = [
        aws_security_group.allow_ssh
    ]
}

resource "aws_key_pair" "ux_app_key" {
    key_name = "ux-app-key"
    public_key = var.ux_app_public_key
}

resource "aws_instance" "ux-app" {
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