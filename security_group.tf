#Create a security group
resource "aws_security_group" "App_SG" {
    name = "App_SG"
    description = "Allow Web inbound traffic"
    vpc_id = aws_vpc.my_vpc.id
    ingress  {
        protocol = "tcp"
        from_port = 80
        to_port  = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        protocol = "tcp"
        from_port = 22
        to_port  = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress  {
        protocol = "-1"
        from_port = 0
        to_port  = 0
        cidr_blocks = ["0.0.0.0/0"]



    }
    tags = {
         Name: "${var.env_prefix}-App_SG"
}
}
