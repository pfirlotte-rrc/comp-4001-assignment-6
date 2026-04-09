# 1.6.  Service Specifications (transactions-service.yaml)

- Service Name: The service must be named transactions.
- Service Type: The service must be of type ClusterIP to restrict access to the internal cluster network.
- Selector: The service must use a selector that matches pods with the label app: transactions to route traffic correctly.

## Port Configuration

- The service should expose port 3000 as its primary port.
- The port must be named http.
- The service must map its port to the container's named port http on the selected pods, which corresponds to port 3000.
