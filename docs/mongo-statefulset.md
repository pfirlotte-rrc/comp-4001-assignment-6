# 1.2. Technical Requirements (mongo-statefulset.yaml)

- Workload Type: Deploy a StatefulSet named mongo to manage the database
  pods, ensuring each pod has a unique, stable network identifier and persistent
  storage.
- Replicas: Initially, the StatefulSet should have a single replica (replicas: 1).

## Pod Template

- Labels: Pods must have the label app: mongo.
- Container: The container must use the mongo:4.4.18 image.
- Ports: The container must expose port 27017 named mongo.
- Arguments: The MongoDB instance must accept connections from all IP
  addresses by using the args: ["--bind_ip_all"].

## Liveness and Readiness Probes

- Liveness Probe: Implement a TCP socket probe on port 27017 to check the
  pod's health. The initial delay should be 20 seconds, and the period between
  checks should be 10 seconds.
- Readiness Probe: Implement a TCP socket probe on port 27017 to determine if
  the pod is ready to serve traffic. The initial delay should be 10 seconds, and
  the period between checks should be 5 seconds.
  Resource Management:
- Requests: Each pod should request 100m CPU and 256Mi memory.
- Limits: Each pod's resource usage should be limited to 500m CPU and 1Gi
  memory.

## Persistent Storage

- Volume Claim Template: Create a Persistent Volume Claim (PVC) template
  named mongo-data.
- Access Mode: The PVC must have the ReadWriteOnce access mode.
- Storage Request: The PVC must request 2Gi of persistent storage.
- Volume Mount: Mount the volume to the container at the path /data/db, which is
  the default location for MongoDB data.
