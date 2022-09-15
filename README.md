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

Deploys to AWS

