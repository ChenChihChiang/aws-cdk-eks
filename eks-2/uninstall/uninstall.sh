#!/bin/sh

set -x

# delete kubernetes resources

export AWS_REGION=ap-northeast-2

helm delete --purge jenkins --context john.chen@linc-eks-2.ap-northeast-2.eksctl.io 

kubectl delete pvc jenkins -n jenkins --context john.chen@linc-eks-2.ap-northeast-2.eksctl.io 

kubectl delete namespace jenkins --context john.chen@linc-eks-2.ap-northeast-2.eksctl.io 

export EKS_ADMIN_IAM_USERNAME=`aws sts get-caller-identity | jq '.Arn' | cut -d '"' -s -f2`

cd ../01-install-eks-cluster
/tmp/eksctl delete cluster -f cluster.yaml
