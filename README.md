# LAMP Stack

This repo deploys a LAMP stack to AWS.

## PHP Image

This build used the public docker-hub [apache tag of php](https://hub.docker.com/layers/library/php/apache/images/sha256-db79535bf6fc6ed888d3f99cd406a42f5aa7fa1a874e0807abbd5ca5ae6fd95a?context=explore).

## Terraform Deployment

Deploys to AWS

### Perquisite Steps

Before we can deploy the rest of the project we need a bucket for storing the terraform state and ECR repositories for the container images.

#### Deploy Step

```bash
AWS_PROFILE=ktacct AWS_DEFAULT_REGION=us-east-2 aws cloudformation deploy \
  --template-file cloudformation/lamp-prereq.yaml \
  --stack-name "lamp-prereq"
```

#### TF State Bucket


### ECR Repo

we need a repo deployed before we can deploy the rest of the stack since the image is used in the ecs service deployment

## Gaps

- Missing extension in php container for mysql connection
