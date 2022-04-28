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
