#!/bin/bash

kubectl config use-context  eks-1

kubectl get deploy -n prod -o wide

sleep 5

kubectl config use-context  eks-2

kubectl get deploy -n prod -o wide

sleep 5

sed -i 's/1.19.4/1.19.3/g' nginx.yaml

kubectl config use-context  eks-1

kubectl apply -f nginx.yaml

kubectl config use-context  eks-1

kubectl get deploy -n prod -o wide

sleep 5

kubectl config use-context  eks-2

kubectl get deploy -n prod -o wide

sleep 5

sed -i 's/1.19.3/1.19.4/g' nginx.yaml

kubectl config use-context  eks-1

kubectl apply -f nginx.yaml

kubectl config use-context  eks-1

kubectl get deploy -n prod -o wide

sleep 5

kubectl config use-context  eks-2

kubectl get deploy -n prod -o wide

sleep 5

kubectl config use-context  eks-1

kubectl apply -f http.yaml

kubectl get deploy -n prod -o wide

sleep 5

kubectl config use-context  eks-2

kubectl get deploy -n prod -o wide

sleep 5
