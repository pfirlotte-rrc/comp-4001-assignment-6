# 1.4.  Technical Requirements (backend-service.yaml)Service Specifications

- Service Name: The service must be named backend.
- Service Type: The service should be of type ClusterIP, making it accessible only from within the Kubernetes cluster.
- Selector: The service must select pods with the label app: backend to correctly route network traffic.

## Port Configuration

- The service must expose port 5000 as the primary service port.
- The service port must be named http.
- This service port must route traffic to the container's named port http (which corresponds to port 5000) on the selected pods.
