minikube status || minikube start --driver=docker

# Minikube's Docker daemon
eval $(minikube docker-env)

docker build -t backend:latest ./backend
docker build -t transactions:latest ./transactions

# Verify images inside the node's Docker
docker images | grep -E "backend|transactions|nginx"

# Apply all manifests
kubectl apply -f ./k8s/

# Restart deployments to pick up local images
kubectl rollout restart deployment/backend
kubectl rollout restart deployment/transactions
kubectl rollout restart deployment/nginx

# Launch the application
minikube service nginx