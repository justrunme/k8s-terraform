#!/bin/bash

set -e

NAMESPACE=demo

echo "Checking pods..."
kubectl get pods -n $NAMESPACE

echo "Checking if all pods are running..."
kubectl get pods -n $NAMESPACE | grep Running

echo "Checking service..."
kubectl get svc -n $NAMESPACE

echo "Checking ingress..."
kubectl get ingress -n $NAMESPACE

echo "Smoke tests completed!"
