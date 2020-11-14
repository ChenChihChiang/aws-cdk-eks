#!/bin/bash

kubectl create ns kube-federation-system

helm install --name kubefed --namespace kube-federation-system kubefed-charts/kubefed --version=0.3.0

kubectl get pod  -n kube-federation-system


