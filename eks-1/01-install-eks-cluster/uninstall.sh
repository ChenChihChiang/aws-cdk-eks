#!/bin/sh

set -e
set -x

/tmp/eksctl delete cluster -f cluster.yaml
