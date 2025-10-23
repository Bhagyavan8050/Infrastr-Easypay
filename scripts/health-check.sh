#!/bin/bash
set -e
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get svc --all-namespaces
