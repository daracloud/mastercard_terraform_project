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
## VPC
One VPC was created with one subnet

## Security Group
Security Group for the web-server was created to allow HTTP connections to the instance

## Elastic Load Balancer
An Elastic Load Balancer was created in front of the EC2 instances with it's own Security Group, so we could make traffic rules more restrictive later if we want to.

## Autoscaling group
An autoscalling group was created to automatically add and remove nodes based on load

## Entry Script
A launch configuration file was created to initialize docker & nginx configuration

## Auto scaling policies
In order to add dynamism to the infrastructure, I created several Auto Scaling Policies and CloudWatch Alarms.

*aws_autoscaling_policy* defines how AWS should change Auto Scaling Group instances count in case of aws_cloudwatch_metric_alarm.

*cooldown option* is needed to give our infrastructure some time (300 seconds) before increasing Auto Scaling Group again.

*aws_cloudwatch_metric_alarm* is a straightforward alarm, which will be fired, if the total CPU utilization of all instances in our Auto Scaling Group is greater or equal threshold (60% CPU utilization) during 120 seconds.
