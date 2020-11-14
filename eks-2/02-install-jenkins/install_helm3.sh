#!/bin/sh

set -e
set -x

# install helm & kubectl cli

wget https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz
tar -zxvf helm-v3.4.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -r helm-v3.4.0-linux-amd64.tar.gz  linux-amd64/

helm plugin install https://github.com/databus23/helm-diff

# get aws eks kube-config

EKS_CLUSTER_NAME=`aws eks list-clusters | grep linc-eks | cut -d '"' -s -f2`
EKS_ADMIN_ARN=`aws iam list-roles | grep eksctl-linc-eks-cluster  | grep Arn | cut -d'"' -s -f4`
EKS_CLUSTER_ARN=`aws eks describe-cluster --name=$EKS_CLUSTER_NAME | jq '.cluster.arn' | cut -d '"' -s -f2`

aws eks update-kubeconfig --region ap-northeast-1 --name $EKS_CLUSTER_NAME

kubectl config use-context $EKS_CLUSTER_ARN

# install jenkins

helm repo add jenkins https://charts.jenkins.io

kubectl create ns jenkins

helm install jenkins --namespace jenkins  jenkins/jenkins

wget https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/values.yaml

helm diff upgrade  jenkins -f ./values.yaml --namespace jenkins  jenkins/jenkins
