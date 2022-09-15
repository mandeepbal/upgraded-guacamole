#!/bin/bash
set -ex

awsProfile=$1
awsRegion=$2
imgName="dockerhub-mirror/php"
acctNumber=$(aws sts get-caller-identity --profile ${awsProfile} --region ${awsRegion} --query Account --output text)
ecrPath=${acctNumber}.dkr.ecr.${awsRegion}.amazonaws.com

# Login to ECR
aws ecr get-login-password --profile ${awsProfile} --region ${awsRegion} | docker login --username AWS --password-stdin ${ecrPath}

# Build Image
cd ..
docker build -t ${ecrPath}/${imgName}:${tag} .
