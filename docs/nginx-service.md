# 1.11. Service Specifications (nginx-service.yaml)

- The service must have a metadata section.
- The name of the service must be nginx.
- The service must have a labels key with the label app set to the value nginx.
- Specification (spec)
- The spec section must define a selector. The selector must match pods with the label app: nginx.
- The service type must be NodePort. This exposes the service on each node's IP at a static port.
- The service must define a ports array with a single entry.
- The port entry must have a name set to http.
- The port exposed by the service must be 80.
- The targetPort that the service forwards traffic to must be http.
- The nodePort must be explicitly defined and set to 30080.
