# 1.10. Deployment Specifications Technical Requirement (nginx-deployment.yaml)

- Workload Type: The application must be deployed using a Deployment named nginx.
- Replicas: The deployment must maintain 2 replicas to ensure high availability.
- Rollout History: Set revisionHistoryLimit to 2 to retain a history of old ReplicaSets, allowing for rollbacks.
- Pod Selector: The deployment must use a selector with the label app: nginx to manage the correct pods.

# Pod Template

- Labels: Pods must be labeled with app: nginx.
- Container: The container must use the nginx:alpine image.
- Ports: The container must expose port 80 with the name http.

## Volume Mounts

- The container needs a volume mount named nginx-conf at the path /etc/nginx/nginx.conf.
- The mount should specifically use the nginx.conf file from the referenced ConfigMap.

## Health Probes

- Readiness Probe: An httpGet probe on the path / and port http must be configured. The probe should have an initialDelaySeconds of 3 and a periodSeconds of 5 to determine if the pod is ready to accept traffic.
- Liveness Probe: An httpGet probe on the path / and port http must be configured. The probe should have an initialDelaySeconds of 20 and a periodSeconds of 10 to check for pod health and trigger restarts if necessary.

## Resource Management

- Requests: Each pod should request 50m CPU and 64Mi memory.
- Limits: Each pod's resource usage must be capped at 200m CPU and 256Mi memory.

## Volumes

- A volume named nginx-conf must be defined.
- This volume must source its data from a ConfigMap named nginx-conf, which contains the custom Nginx configuration file.
