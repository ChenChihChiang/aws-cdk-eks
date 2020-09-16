#!/bin/sh

ep=$(kubectl get svc jenkins -n jenkins -o jsonpath="{.status.loadBalancer}")

echo "jenkins"
echo "http://${ep}:8080"
