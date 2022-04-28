resource "aws_instance" "webserver" {
   ami = data.aws_ami.latest-amazon-linux-image.id
   instance_type = var.instance_type

   subnet_id = aws_subnet.my_app-subnet.id
   vpc_security_group_ids = [aws_security_group.App_SG.id]
   availability_zone = var.avail_zone

   user_data = file("entry-script.sh")

   tags = {
         Name: "${var.env_prefix}-webserver"

associate_public_ip_address = true
key_name = aws_key_pair.ssh-key.key_name

}
}

    data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
 }
output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}


resource "aws_launch_template" "my_template" {
  name_prefix   = "my_template"
  image_id      = "ami-0b0af3577fe5e3532"
  instance_type = "t2.micro"
}
