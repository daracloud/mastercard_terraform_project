provider "aws" {
  region  = "us-east-1"
  profile = "default"
}



#Create a virtual network
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr_block    
    tags = {
        Name = "${var.env_prefix}-vpc"
  }
}
#Create your subnet
resource "aws_subnet" "my_app-subnet" {
  
    vpc_id = aws_vpc.my_vpc.id
    cidr_block =  var.subnet_cidr_block  
    availability_zone = var.avail_zone
    map_public_ip_on_launch = true
   depends_on= [aws_vpc.my_vpc]

     tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
 }
   #create your route table
   resource "aws_route_table" "myapp-route-table" {
     vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
        
    }
   }
   
# create internet gateway
   resource "aws_internet_gateway" "myapp-igw" {
       vpc_id = aws_vpc.my_vpc.id
       tags = {
         Name: "${var.env_prefix}-igw"
        }
  }


resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.my_app-subnet.id
    route_table_id = aws_route_table.myapp-route-table.id

  }
#create default route table
   resource "aws_default_route_table" "main-rtb" {
     default_route_table_id = aws_vpc.my_vpc.default_route_table_id

route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.myapp-igw.id
}
tags = {
  Name: "${var.env_prefix}-main-rtb"
}
   }

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


#create autoscaling group
resource "aws_autoscaling_group" "EC2_AutoScaling_Group" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
}
resource "aws_key_pair"  "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}
  #create autoscaling policy 
resource "aws_autoscaling_policy" "EC2_AutoScaling_Policy" {
  name                   = "EC2-AutoScaling-Policy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.EC2_AutoScaling_Group.name
  depends_on = [
    aws_autoscaling_group.EC2_AutoScaling_Group
  ]
}

#create cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "EC2_metric_alarm" {
  alarm_name          = "EC2-metric-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  depends_on = [
    aws_autoscaling_group.EC2_AutoScaling_Group,
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.EC2_AutoScaling_Group.name
  }
  

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.EC2_AutoScaling_Policy.arn]
}


