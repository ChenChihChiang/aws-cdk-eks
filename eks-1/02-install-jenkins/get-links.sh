#!/bin/sh

ep=$(kubectl get svc jenkins -n jenkins -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

echo "jenkins"
echo "http://${ep}:8080"