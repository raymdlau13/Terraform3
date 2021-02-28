variable "app-servers" {
    type = map(object({
        env = string
        ami = string
        instance_type = string
    }))
}

