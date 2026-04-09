#!/bin/bash

echo "Deleting Kubernetes resources..."
kubectl delete deploy,service,statefulset,hpa,configmap,secret --all --ignore-not-found

echo "Stopping and deleting Minikube..."
minikube stop
minikube delete --all --purge

echo "Cleaning up Docker..."
sudo docker rmi $(docker images -aq) 2>/dev/null || true
sudo docker system prune -a -f

echo "Cleanup complete!"