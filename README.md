# LAMP Stack

This repo deploys a LAMP stack to AWS and 
## PHP Image
This build used the public docker-hub [apache tag of php](https://hub.docker.com/layers/library/php/apache/images/sha256-db79535bf6fc6ed888d3f99cd406a42f5aa7fa1a874e0807abbd5ca5ae6fd95a?context=explore).

## Terraform Deployment
Deploys to AWS


### Prequiste Steps
We need bucket for storing TF state.

#### TF State Bucket 
```bash
aws s3api create-bucket \
    --bucket my-bucket \
    --region us-east-1 \
    --object-ownership BucketOwnerEnforced

aws s3api put-bucket-encryption \
    --bucket my-bucket \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

### ECR Repo
we need a repo deployed before we can deploy the rest of the stack since the image is used in the ecs service deployment

## Gaps
- Missing extention in php container for mysql connection
