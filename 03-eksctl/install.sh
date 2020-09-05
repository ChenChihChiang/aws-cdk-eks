#!/bin/sh

set -e
set -x

eksctl create cluster -f cluster.yaml
