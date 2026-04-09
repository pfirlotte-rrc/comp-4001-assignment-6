# 1.10. Deployment Specifications Technical Requirement (nginx-deployment.yaml)

- Workload Type: The application must be deployed using a Deployment named nginx.
- Replicas: The deployment must maintain 2 replicas to ensure high availability.
- Rollout History: Set revisionHistoryLimit to 2 to retain a history of old ReplicaSets, allowing for rollbacks.
- Pod Selector: The deployment must use a selector with the label app: nginx to manage the correct pods.
