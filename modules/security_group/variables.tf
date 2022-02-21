# variable "security_group_name" {
#     type = string
# }

# variable "security_group_description" {
#     type = string
#     default = ""
# }

variable "vpc_id" {
    type = string
}

# variable "cidr_blocks" {
#     type = list
# }

variable "security_group_rules_yaml_file" {
    type = string
}