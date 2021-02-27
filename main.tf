# variable "app-servers" {
#     type = list(object({
#         env = string
#         num_of_server = number
#         symbol = string
#         name = string
#     }))
#     default = [{
#         env = "dev"
#         num_of_server = 3
#         symbol = "d"
#         name = "app"
#     },{
#         env = "qa"
#         num_of_server = 3
#         symbol = "a"
#         name = "app"
#     },{
#         env = "uat"
#         num_of_server = 3
#         symbol = "u"
#         name = "app"
#     }
#     ]
# }
provider "aws" {
    region = "us-east-1"
}

variable "vpc_id" {
    type = string
    default = "vpc-840ea0f9"
}
data "aws_vpc" "selected" {
    id = var.vpc_id
}
output "app-server" {
    #value = var.app-servers["dev"].servers
    value = flatten(values(var.app-servers)[*].servers)
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
}

data "aws_security_groups" "sgroups" {
    filter {
        name = "vpc-id"
        values = [var.vpc_id]
    }
    # filter {
    #     name = "group-name"
    #     values = ["allow_ssh"]
    # }
}

output "all_sg" {
    #value = data.aws_security_group.sgs
    value = tolist(data.aws_security_groups.sgroups.ids)
}

resource "aws_key_pair" "ux-app-key" {
    key_name = "ux-app-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQE3EwG1kpc/tQkNlXvmBDPhhqTWS1U4Psr9ojQzscG3PVY1y2QjMNXdatL4P6yv/5uV7cxJxn9ivOXdDP2lso1lanrm69RP7aCzSQ7eZ4EOPpE88iTTKDqnVVG1i0LdS4byO/bQNtysebw0oLqhUzJqQhqkSz59sFyVGV4LyLjk6WZxWXFEOTZZw98KEvivvIVVvhyZgmEoQ1NUM7EqlVRmFVC/tXbc3czUjCd6T38MBMY5pcmapxAg9oRMCzrSSDBcXMJfWULpUXNc0NTE9uvTf5tap19ccAe3fTsNaq5TsEHm/KGK0RchpB1ki0CFrJS3lD3/3bHasnrdgxvjzO2q9TDxdz7XCN4lyNCQ+Fo4T7Unv1ZwRDr20Y4nthjIvwt/M8lK2A9k/S9bv+xiqgTiPeP60zAM999mhXRePOmFkABMyYzyLtJ0wGs3SHMrGY0AJz/R6RMoH/f9QTW64PuWDs69ibJmQM0dVA9QkAxC20IEp7eAu0PZtpLeGccWc= kingwanlau@cepp-mba-01.T-mobile.com"
}

resource "aws_instance" "ux-app" {
#    for_each = toset(var.app-servers["dev"].servers)
    for_each = toset(flatten(values(var.app-servers)[*].servers))
    ami = "ami-03d315ad33b9d49c4"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ux-app-key.key_name
    #security_groups = ["${data.aws_security_groups.sg.ids}[0]"]
    #vpc_security_group_ids = ["sg-0a7b3d5d67b1800bc"]
    vpc_security_group_ids = tolist(data.aws_security_groups.sgroups.ids)    
    tags = {
        Name = each.value
    }
}