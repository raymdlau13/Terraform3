variable "app-servers" {
    type = map(object({
        servers = list(string)
    }))
    default = {
        dev = {
            servers = [ "appd01", "appd02", "appd03"]
        }
        qa = {
            servers = [ "appa02"]
        }
        uat = {
            servers = [ "appu01"]
        }
        prod = {
            servers = [ "appp02"]
        }
    }
}

