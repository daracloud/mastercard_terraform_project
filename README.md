This project will involve building a Terraform module that will deploy a web application that will be supported by a basic cloud infrastructure.

## Pre-Requisites for this project
Code Editor, where we write TF Configuration Code e.g. Visual Studio Code: https://code.visualstudio.com/download

Account on Github, because our Terraform's Configuration Code is hosted on Github

An AWS Account, because we are automating AWS infrastructure with Terraform

## Versions used in this project
Terraform - 0.12.17

AWS provider - 4.2.0

VPC module - 3.14.0

## Commands used 

### initialize

    terraform init

### preview terraform actions

    terraform plan

### apply configuration with variables

    terraform apply -var-file terraform-dev.tfvars

### destroy a single resource

terraform destroy -target aws_vpc.myapp-vpc

### destroy everything fromtf files

    terraform destroy

### show resources and components from current state

    terraform state list

### show current state of a specific resource/data

    terraform state show aws_vpc.myapp-vpc    

## Steps taken
One VPC was created with one subnet
Security Group for the web-server was created to allow HTTP connections to the instance
An Elastic Load Balancer was created in front of the EC2 instances with it's own Security Group, so we could make traffic rules more restrictive later if we want to.
An autoscalling group was created for traffic management

## Auto scaling policies
In order to add dynamism to the infrastructure, I created several ## Auto Scaling Policies and ## CloudWatch Alarms.
