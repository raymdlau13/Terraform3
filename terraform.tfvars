app-servers = {
        appd01 = {
            env = "dev"
            ami = "ami-03d315ad33b9d49c4"
            instance_type = "t2.micro"
        }
        appq01 = {
            env = "qa"
            ami = "ami-03d315ad33b9d49c4"
            instance_type = "t2.micro"        
        }
        appu01 = {
            env = "uat"
            ami = "ami-03d315ad33b9d49c4"
            instance_type = "t2.micro"        
        }
    }
