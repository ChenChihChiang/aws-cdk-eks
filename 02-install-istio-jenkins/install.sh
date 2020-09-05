#!/bin/sh

set -e
set -x

# install helm & kubectl cli

wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz
tar -zxvf helm-v2.16.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -r helm-v2.16.1-linux-amd64.tar.gz  linux-amd64/

sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# get aws eks kube-config

EKS_CLUSTER_NAME=`aws eks list-clusters | grep istio-eks | cut -d '"' -s -f2`
EKS_ADMIN_ARN=`aws iam list-roles | grep istio-eks-cluster-AdminRole | grep Arn | cut -d'"' -s -f4`
EKS_CLUSTER_ARN=`aws eks describe-cluster --name $EKS_CLUSTER_NAME | jq '.cluster.arn' | cut -d '"' -s -f2`

aws eks update-kubeconfig --region ap-northeast-1 --name $EKS_CLUSTER_NAME --role-arn $EKS_ADMIN_ARN

kubectl config use-context $EKS_CLUSTER_ARN

# install service mesh

helm init --service-account tiller --wait

curl -o pre_upgrade_check.sh https://raw.githubusercontent.com/aws/eks-charts/master/stable/appmesh-controller/upgrade/pre_upgrade_check.sh

chmod 755 ./pre_upgrade_check.sh

./pre_upgrade_check.sh

helm repo add eks https://aws.github.io/eks-charts

kubectl apply -k "https://github.com/aws/eks-charts/stable/appmesh-controller/crds?ref=master"

kubectl create ns appmesh-system

export CLUSTER_NAME=`aws eks list-clusters | grep istio-eks | cut -d '"' -s -f2`
export AWS_REGION=ap-northeast-1

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

chmod 755 /tmp/eksctl

/tmp/eksctl utils associate-iam-oidc-provider \
    --region=$AWS_REGION \
    --cluster $CLUSTER_NAME \
    --approve


/tmp/eksctl create iamserviceaccount \
    --cluster $CLUSTER_NAME \
    --namespace appmesh-system \
    --name appmesh-controller \
    --attach-policy-arn  arn:aws:iam::aws:policy/AWSCloudMapFullAccess,arn:aws:iam::aws:policy/AWSAppMeshFullAccess \
    --override-existing-serviceaccounts \
    --approve


helm upgrade -i appmesh-controller eks/appmesh-controller \
    --namespace appmesh-system \
    --set region=$AWS_REGION \
    --set serviceAccount.create=false \


kubectl get deployment appmesh-controller \
    -n appmesh-system \
    -o json  | jq -r ".spec.template.spec.containers[].image" | cut -f2 -d ':'
    --set serviceAccount.name=appmesh-controller
