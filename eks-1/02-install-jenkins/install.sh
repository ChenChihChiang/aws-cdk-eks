#!/bin/sh

set -e
set -x

# install helm & kubectl cli

wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz
tar -zxvf helm-v2.16.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -r helm-v2.16.1-linux-amd64.tar.gz  linux-amd64/

# get aws eks kube-config

EKS_CLUSTER_NAME=`aws eks list-clusters | grep linc-eks | cut -d '"' -s -f2`
EKS_ADMIN_ARN=`aws iam list-roles | grep eksctl-linc-eks-cluster  | grep Arn | cut -d'"' -s -f4`
EKS_CLUSTER_ARN=`aws eks describe-cluster --name=$EKS_CLUSTER_NAME | jq '.cluster.arn' | cut -d '"' -s -f2`

aws eks update-kubeconfig --region ap-northeast-1 --name $EKS_CLUSTER_NAME

kubectl config use-context $EKS_CLUSTER_ARN

# install helm

kubectl create serviceaccount --namespace kube-system tiller

kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller --wait

# install jenkins

helm upgrade --install --recreate-pods jenkins --namespace jenkins --version 1.9.21 -f jenkins/jenkins-values.yaml stable/jenkins
