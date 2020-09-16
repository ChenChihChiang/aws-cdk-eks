#!/bin/sh

set -x

# delete kubernetes resources

helm delete --purge jenkins

kubectl delete pvc jenkins -n jenkins

kubectl delete namespace jenkins

export EKS_ADMIN_IAM_USERNAME=`aws sts get-caller-identity | jq '.Arn' | cut -d '"' -s -f2`

cd ../01-install-eks-cluster
/tmp/eksctl delete cluster -f cluster.yaml
