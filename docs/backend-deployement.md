# 1.3. Technical Requirements(backend-deployment.yaml)

- Workload Type: The application must be deployed using a Deployment named
backend to manage its stateless pods.
- Replicas: The deployment should maintain 3 replicas to ensure high availability
and load balancing.
- Rollout History: A revisionHistoryLimit of 2 must be set to manage the
number of stored old ReplicaSets, allowing for rollbacks.
- Pod Selector: The deployment must use a selector with the label app: backend
to manage the correct pods.

## Pod Template

- Labels: The pods must be labeled with app: backend.
- Container: The container must use the backend:latest image.
- Ports: The container must expose port 5000 with the name http.

## Environment Variables

- The MONGO_URI environment variable must be set to
  mongodb://mongo:27017/bank_app to connect to the MongoDB service.
- The SECRET_KEY environment variable must be populated from the backend-secret Secret.

## Health Probes:

- Readiness Probe: An httpGet probe on the path / and port http must be
  configured. It should have an initialDelaySeconds of 5 and a periodSeconds
  of 5 to determine if the pod is ready to serve traffic.
- Liveness Probe: An httpGet probe on the path / and port http must be
  configured. It should have an initialDelaySeconds of 20 and a periodSeconds
  of 10 to check for pod health and trigger restarts if necessary.

## Resource Management

- Requests: Each pod should request 100m CPU and 128Mi memory.
- Limits: Each pod's resource usage must be capped at 500m CPU and 512Mi
  memory.

## Secret Management

- Secret Name: A Secret named backend-secret must be created.
- Data: This Secret should contain a key named secret-key with the value
  supersecretkey to be used by the backend application for security purposes. The
  type should be Opaque.
  