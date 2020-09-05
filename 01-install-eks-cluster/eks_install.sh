#!/bin/sh

set -e
set -x

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

chmod 755 /tmp/eksctl

/tmp/eksctl create cluster -f cluster.yaml