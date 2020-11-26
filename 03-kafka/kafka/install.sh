#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install --name kafka --values values-production.yaml bitnami/kafka

