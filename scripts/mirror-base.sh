#!/bin/bash
set -ex

awsProfile=$1
awsRegion=$2
acctNumber=$(aws sts get-caller-identity --profile ${awsProfile} --region ${awsRegion} --query Account --output text)
ecrPath=${acctNumber}.dkr.ecr.${awsRegion}.amazonaws.com

# Login to ECR
aws ecr get-login-password --profile ${awsProfile} --region ${awsRegion} | docker login --username AWS --password-stdin ${ecrPath}

# Push Image
docker pull php:apache
docker tag php:apache ${ecrPath}/dockerhub-mirror/php:apache
docker push ${ecrPath}/dockerhub-mirror/php:apache
