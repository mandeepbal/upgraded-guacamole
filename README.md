# LAMP Stack

This repo deploys a LAMP stack to AWS.

## Prerequisite Steps

Before we can deploy the rest of the project we need a bucket for storing the terraform state and ECR repositories for the container images.

### Deploy CFT:

```bash
AWS_PROFILE=ktacct AWS_DEFAULT_REGION=us-east-2 aws cloudformation deploy \
  --template-file cloudformation/lamp-prereq.yaml \
  --stack-name "lamp-prereq"
```

#### Resources Created:
| Logical ID | Type |
| --- | ----------- |
| ECRbase | AWS::ECR::Repository |
| ECRweb | AWS::ECR::Repository |
| S3Bucket | AWS::S3::Bucket |


### Building Web/App Image

Use the make command to build the php image to be run in AWS. You have to specify the tag you want to use for the image.
This build used the public docker-hub [apache tag of php](https://hub.docker.com/layers/library/php/apache/images/sha256-db79535bf6fc6ed888d3f99cd406a42f5aa7fa1a874e0807abbd5ca5ae6fd95a?context=explore). This image was also mirrored to ECR in case of dockerhub rate limit issues.


```bash
make mirror-base tag=202209151750
```

## Terraform Deployment of App

Requirements:
  - [Terraform Installed](https://github.com/tfutils/tfenv) (`tfenv use 1.2.9`)

Once the image is uploaded to ECR, create a `settings.auto.tfvars` with the image uri in the `./terraform` directory.

Example `settings.auto.tfvars`
```hcl
img_uri = "<ACCOUNT_NUMBER>.dkr.ecr.us-east-2.amazonaws.com/lamp/web:<TAG-HERE>"
```
`./terraform` Directory:
```
./terraform
├── main.tf
├── outputs.tf
├── settings.auto.tfvars
├── variables.tf
└── versions.tf
```

Check Terraform plan:
```
AWS_PROFILE=ktacct AWS_DEFAULT_REGION=us-east-2 make plan
```

Deploy Terraform:
```
AWS_PROFILE=ktacct AWS_DEFAULT_REGION=us-east-2 make apply
```

## Pushing changes to AWS

1. Build and push new image
```
make push tag=202209152305
```
2. Update `settings.auto.tfvars` file with new tag
```
img_uri = "487169596959.dkr.ecr.us-east-2.amazonaws.com/lamp/web:202209152248"
```
3. Terraform apply to update the ECS service and task definition
```
AWS_PROFILE=ktacct AWS_DEFAULT_REGION=us-east-2 make apply
```
