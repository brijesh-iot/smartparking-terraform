# SmartParking - AWS IoT Infrastructure setup

- Setup environment variables in Jenkins for AWS Secret Keys

  Jenkins -> Configuration -> Global Properties -> Environment variables
  
- Create a new Pipeline in Jenkins providing Github URL. (If require add credentials for private repository)

- Setup Jenkins GitHub webhook - https://medium.com/faun/triggering-jenkins-build-on-push-using-github-webhooks-52d4361542d4


#### Create GitHub Personal Access Token (Optional: As of now we are using AWS CodeCommit)

- Create Personal Access Token in GitHub.
  https://docs.aws.amazon.com/codepipeline/latest/userguide/GitHub-create-personal-token-CLI.html
  
- Create New Secret in AWS Secret Manager
  https://console.aws.amazon.com/secretsmanager/home?region=us-east-1#/newSecret?step=selectSecret
  
   

### Infrastructure setup for SmartParking IoT Application using Terraform

Create S3 bucket to store the state information of Terraform

```bash
aws s3api create-bucket --bucket smartparking-jenkins-terraform --region us-east-1 --acl private --profile cnative
```

- AWS resources will be created using Terraform

```bash
terraform init
terraform fmt
terraform validate
terraform plan --auto-approve
terraform apply --auto-approve
```

#### Follwing AWS Resources will be created 

- S3 Buckets to hold pipeline artifacts and IoT resource such as Certificates for IoT Things
- AWS CodeCommit Respositories 
- Roles required to call AWS web services
- Core infrastructure services such as VPC, Subnets, Security Groups, Internet Gateways, S3 & DynamodDB endpoints, Route Tables
- MySQL database
- EC2 Edge stack for Greengrass, ThingWorx Kepware server, Ignition Edge & Gateway servers
- EC2 for Device Simulators
- AWS CodePipeline for deployment at Edge in Greengrass
- AWS CodePipeline for deployment at IoT Core
- AWS CodePipeline for deployment of APIs


#### GitHub Code Repo support

- https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-GitHub.html#action-reference-GitHub-auth
- https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-cloudformation-github.html
- https://docs.aws.amazon.com/codepipeline/latest/userguide/samples/codepipeline-github-events-yaml.zip


#### RDS Database setup 

- As of now we have are manually running the script to setup Master/Testing data.
  (Have plant to create Lambda function for the same and configuring the same as Custom Resource in CloudFormation)
-   



#### IMP Note

###### Common
- Before this IoT Edge code will be deployed in Edge Greengrass, Very first thing we have to manually create dummy Greengrass group in IoT Core and do dummy Deployment. Otherwise it will not be able to perform Greengrass deployment as initially Greengrass Service Role has not attached to that Region even thought CloudFormation creates the role. It has to be manually attached this way.
- Go to AWS IoT Settings and enable Logging. (Create required role from the same enable logging screen)
- Enable Logging at Greengrass level by visiting Greegrass group settings page.

###### IoT Core 
- Make sure you provide the proper value of CoreName in smartparking-iot-core-repo -> configuration.json (Same value provided in CloudFormation Template)
- Modify file smartparking-iot-core-repo -> alerts -> mysqlconfig.json
- Modify file smartparking-iot-core-repo -> device-register -> config.json
- Modify file smartparking-iot-core-repo -> device-status -> config.json
- Find and execute database scripts from smartparking-iot-core-repo -> dbscript.txt

###### IoT APIs
- Make sure you provide the proper value of CoreName in smartparking-api-repo -> configuration.json (Same value provided in CloudFormation Template)
- Modify file smartparking-api-repo -> parking_nodejs -> config.json

#### Pending/On Going Items 

- Building of Packer Golden AMIs with installation of ThingWork Kepware server and Ignition Edge & Gateway servers
- AWS CodePipeline integration with GitHub & Jenkins
- Currently we are using Python Device Simulations Scripts for provision of things and sending device data, which needs to be taken care of Ignition & ThingWorx

 
  