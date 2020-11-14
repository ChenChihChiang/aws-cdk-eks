#!/bin/bash

/tmp/kubefedctl join linc-eks-1 --cluster-context linc-eks-1  --host-cluster-context linc-eks-1 --v=2 

/tmp/kubefedctl join linc-eks-2 --cluster-context linc-eks-2  --host-cluster-context linc-eks-1 --v=2 

