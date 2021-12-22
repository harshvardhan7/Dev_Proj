resource "aws_security_group" "ecs-sg" {
    name = "ecs-sg"
    vpc_id = var.vpc_id
    #incoming traffic
    ingress {
        from_port = 22 #SSH Port
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["103.240.207.38/32"] #admin access people ip range
    }

    ingress {
        from_port = 8080 #application Port
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    #outgoing traffic
    egress {
        from_port = 0 
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name: "${var.env_prefix}-sg"
    }
}