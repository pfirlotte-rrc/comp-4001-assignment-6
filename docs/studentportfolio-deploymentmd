# 1.7.  Deployment Specifications Technical Requirements (studentportfolio-deployment.yaml)

- Workload Type: The application must be deployed using a Deployment named studentportfolio.
- Replicas: The deployment must maintain 2 replicas to ensure high availability and load distribution.
- Rollout History: Set revisionHistoryLimit to 2 to manage the number of stored old ReplicaSets for potential rollbacks.
- Pod Selector: The deployment must use a selector with the label app: studentportfolio to manage the correct pods.

## Pod Template

- Labels: Pods must be labeled with app: studentportfolio.
- Container: The container must use the studentportfolio:latest image.
- Ports: The container must expose port 80 with the name http.
- Health Probes:
- Readiness Probe: An httpGet probe on the path / and port http must be configured. The probe should have an initialDelaySeconds of 3 and a periodSeconds of 5 to determine if the pod is ready to accept traffic.
- Liveness Probe: An httpGet probe on the path / and port http must be configured. The probe should have an initialDelaySeconds of 20 and a periodSeconds of 10 to check for pod health and trigger restarts if necessary.

## Resource Management

- Requests: Each pod should request 50m CPU and 64Mi memory.
- Limits: Each pod's resource usage must be capped at 200m CPU and 256Mi memory.
