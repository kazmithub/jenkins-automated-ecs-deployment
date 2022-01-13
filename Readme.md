# terraform-ecs-deployment

## Description

A jenkins server is configured on an  EC2 instance. 

## Pre-requisutes

Before reading this, 
- AWS account 
- AWS services basic knowledge
- Terraform knowledge
- Extensive knowledge of Docker
- Extensive knowledge of Amazon ECS service 
- Jenkins knowledge
- Groovy syntax
is required

## Modules

| Module Name   | Function                                                  |
| ------------- | ----------------------------------------------------------|
| vpc           | - A VPC with a provided CIDR.                             |
|               | - Two public Subnets within the above VPC.                |
|               | - Internet Gateway for internet access.                   |
|               | - Route table for routing.                                |
|               | - DHCP options.                                           |
|               | - Security groups.                                        |
|               |                                                           |
|               |                                                           |
| ec2           | - An EC2 instance with jenkins and aws-cli configured.    |

## Deployment

In this project, the module aws is the main in which we have to configure Jenkins server on the instance 
on port 8080 which is its default port.

Then, clone [this repository](https://github.com/kazmithub/terraform-ECS-deployment-with-ASG-ALB). 

Run
```
terraform init
terraform plan -var-file='var-file-name'
terraform apply -var-file='var-file-name'
```
Our deployment is to automate the addition of a service which will pull an image from ECR and add it 
inside a task definition. It will eventually run a task inside a service of its own which we will create ourselves.
All of this will be done using aws-cli commands. 


Firstly, create a ECR repository. 
For the deployment, first we have to add the basic configurations to Jenkins. Then, install the basic plugins required.
We have to add Docker plugin and Cloudbees AWS Credentials plugin by ourselves. Amazon ECR plugin will be a plus. Then, 
configure jenkins for the URL of the webhook. Add the webhook to the Gitub repository settings.
Add a new job of pipeline type and select "GitHub hook trigger for GITScm polling" for build triggers. Add variables to the 
configuration through parameters.Add the script through scm and link this repository. Create AWS credentials in Jenkins.

### taskdef.json

This file contains the task definition which will determine the behavior of the task running in the service.

### Jenkinsfile

This file automates the pipeline. It builds Docker image from ECR. Adds it to task definition and pushes it back to ECR.

```
def last_commit= sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
  stage 'Checkout'
  git 'repo link'
  stage 'Docker build'
  docker.build('demo')
# demo-ecr-credentials is the credentials ID in Jenkins.
  stage 'Docker push'
  docker.withRegistry('https://853219876644.dkr.ecr.us-west-2.amazonaws.com', 'ecr:us-west-2:demo-ecr-credentials') {
    docker.image('demo').push("${last_commit}")
  }
  stage('Deploy') {
      sh "sed -i 's|{{image}}|${docker_repo_uri}:${last_commit}|' taskdef.json"
      sh "aws ecs register-task-definition --execution-role-arn arn:aws:iam::853219876644:role/Jenkins --cli-input-json file://taskdef.json --region ${region}"
      sh "aws ecs update-service --cluster ${cluster} --service v1-WebServer-Service --task-definition ${task_def_arn} --region ${region}"
  }
```
## Dockerfile

Contains the build file for Dockerimage.



