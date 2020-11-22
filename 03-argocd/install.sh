#!/bin/bash

helm repo add argo https://argoproj.github.io/argo-helm

helm install --name argo-cd --values values.yaml argo/argo-cd --version 2.9.5

helm repo add gitops https://raw.githubusercontent.com/chenchihchiang/gitops/main
