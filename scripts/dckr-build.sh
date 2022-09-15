#!/bin/bash
set -ex

awsProfile=$1
tag=$2
acctNumber=$(aws sts get-caller-identity --profile ${awsProfile} --query Account --output text)
ecrPath=${acctNumber}.dkr.ecr.region.amazonaws.com

# Login to ECR
aws ecr get-login-password --profile ${awsProfile} | docker login --username AWS --password-stdin ${ecrPath}

# Build Image
cd ..
docker build -t ${ecrPath}/php-hw:${tag} .
