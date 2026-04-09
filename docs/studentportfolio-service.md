# 1.8.  Service Specifications (studentportfolio-service.yaml)

- Service Specifications
- Service Name: The service must be named studentportfolio.
- Service Type: The service should be of type ClusterIP to restrict access to the internal cluster network.
- Selector: The service must select pods with the label app: studentportfolio to correctly route traffic.

## Port Configuration

- The service must expose port 80 with the name http.
- The service must route traffic to the container's named port http on the selected pods, which corresponds to port 80.
