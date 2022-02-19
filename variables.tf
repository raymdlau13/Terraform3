# variable "app_servers" {
#     type = map(object({
#         env = string
#         ami = string
#         instance_type = string
#     }))
# }

variable "vpc_id" {
    type = string
    default = "vpc-840ea0f9"
}

variable "region" {
    type = string
    default = "us-east-1"
}
variable "default_ami" {
    type = string
    default = "ami-03d315ad33b9d49c4"
}

variable "default_instance_type" {
    type = string
    default = "t2.micro"
}

variable "ux_app_public_key" {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkda0lVoW+ZGfXMsBBGdU2sXz10uGp8Mp7L+AyJSE+EZDbUtW1yS9JzT4WWIzUvZqoZcEfLUaM0kmiOTfIL8/sqtScPsloMor/yuPe8lL98/WKo86vR/bmG0aC4AzzMMXI/nVnq8eYfiOMwK6CYWB2lzOnvhFj6c9yjyEdZZTxXwOCiYluUEtk7fVxpOOqc2JTACsNODz+fVpCD2vjbpRpQGdLpK/89h5LN41sCtCaOUWwaHf4QvBJarw1VRLszdbWsxnEmkFcpVzQOMt+x9pAtUScZIo8LrxKxullaRxtmjDF0n/oSS15wS5zWlGdb7ZXeHL5M2YE2k6aOD+St4FB8qH+iyG1BYTRi/9GTKKt5jKadBuqgD3d+oyPt/gUlV0fZMR+DoPDJIgWFRUJseRlewKxbyfDYQfUFPq7ZvMadxLIGvBuCZUHrpmrm9dRJ2lXQDG79uhjmv1UvhaTO1Jpz/IsUYBiYkdM5VAVmM6C4B2qEyvah9+GbJnIfVzeRvU= "
}

