#!/bin/bash

/tmp/kubefedctl join linc-eks-2.ap-northeast-2.eksctl.io  --host-cluster-name=linc-eks.ap-northeast-1.eksctl.io --host-cluster-context=john.chen@linc-eks-2.ap-northeast-2.eksctl.io --cluster-context=john.chen@linc-eks-2.ap-northeast-2.eksctl.io 

/tmp/kubefedctl join linc-eks.ap-northeast-1.eksctl.io  --host-cluster-name=linc-eks-2.ap-northeast-2.eksctl.io --host-cluster-context=john.chen@linc-eks.ap-northeast-1.eksctl.io --cluster-context=john.chen@linc-eks.ap-northeast-1.eksctl.io 

kubectl -n kube-federation-system get kubefedclusters --context john.chen@linc-eks.ap-northeast-1.eksctl.io

kubectl -n kube-federation-system get kubefedclusters --context john.chen@linc-eks-2.ap-northeast-2.eksctl.io


