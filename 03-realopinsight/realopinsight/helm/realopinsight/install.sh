#!/bin/bash

kubectl create ns monitoring

helm upgrade --namespace monitoring --install realopinsight -f ./values.yaml ../realopinsight


