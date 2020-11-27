#!/bin/bash


helm repo add eks https://aws.github.io/eks-charts

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy --policy-name linc-eks-alb --policy-document file://iam-policy.json

/tmp/eksctl utils associate-iam-oidc-provider --region ap-northeast-1 --cluster linc-eks --approve

/tmp/eksctl create iamserviceaccount --cluster=linc-eks --namespace=kube-system --name=aws-load-balancer-controller  --attach-policy-arn=arn:aws:iam::312490145519:policy/linc-eks-alb --override-existing-serviceaccounts --approve

helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=linc-eks --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --namespace kube-system

kubectl apply -k github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master

kubectl get crd

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/examples/2048/2048_full.yaml

kubectl get ingress/ingress-2048 -n game-2048


