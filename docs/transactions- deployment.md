# 1.5. Deployment Specifications Technical Requirements (transactions-deployment.yaml)

- Workload Type: The application must be deployed using a Deployment named
  transactions.
- Replicas: The deployment must maintain 2 replicas to ensure high availability
  and proper load distribution.
- Rollout History: Set revisionHistoryLimit to 2 to manage the number of stored
  old ReplicaSets, enabling quick rollbacks.
- Pod Selector: The deployment must use a selector with the label app:
  transactions to manage the correct pods.
  
## Pod Template

- Labels: The pods must be labeled with app: transactions.
- Container: The container must use the transactions:latest image.
- Ports: The container must expose port 3000 with the name http.

## Environment Variables

- The MONGO_URI environment variable must be set to mongodb://mongo:27017
  to connect to the MongoDB service.
- The PORT environment variable must be set to "3000".

## Health Probes

- Readiness Probe: A TCP socket probe on port 3000 must be used to determine
  if the pod is ready to accept traffic. The probe should have an
  initialDelaySeconds of 8 and a periodSeconds of 5.
- Liveness Probe: A TCP socket probe on port 3000 must be used to check the
  pod's health. The probe should have an initialDelaySeconds of 25 and a
  periodSeconds of 10.

## Resource Management

- Requests: Each pod should request 100m CPU and 128Mi memory.
- Limits: Each pod's resource usage must be capped at 500m CPU and 512Mi memory.
