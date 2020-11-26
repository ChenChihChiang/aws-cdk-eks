#!/bin/bash

helm repo add cmak-operator https://eshepelyuk.github.io/cmak-operator/

helm install cmak --values values.yaml cmak-operator/cmak-operator --version 0.6.2

