variable "app_servers" {
    type = map(object({
        env = string
        ami = string
        instance_type = string
    }))
}

variable "default_ami" {
    type = string
    default = "ami-03d315ad33b9d49c4"
}

variable "default_instance_type" {
    type = string
    default = "t2.micro"
}