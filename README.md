This project will involve building a Terraform module that will deploy a web application that will be supported by a basic cloud infrastructure.

## Pre-Requisites for this project
Code Editor, where we write TF Configuration Code e.g. Visual Studio Code: https://code.visualstudio.com/download

Account on GitlLab, because our Terraform's Configuration Code is hosted on GitLab

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
