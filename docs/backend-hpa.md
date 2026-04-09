# 1.12. Technical Requirement (backend-hpa.yaml)

- API Version and Kind
- The apiVersion must be autoscaling/v2.
- The kind must be HorizontalPodAutoscaler.

## Metadata

- The HPA must have a metadata section.
- The name of the HPA must be backend-hpa.

## Specification (spec)

- The HPA must define a scaleTargetRef to specify the resource it will manage.
- The apiVersion of the target must be apps/v# 1.
- The kind of the target must be Deployment.
- The name of the target deployment must be backend.
- The minimum number of replicas (minReplicas) for the target deployment must be 3.
- The maximum number of replicas (maxReplicas) for the target deployment must be 10.
- The HPA must include a metrics array with a single metric defined.
    The type of the metric must be Resource.
- The resource metric must target the cpu resource.
- The target for the CPU metric must be of type Utilization.
- The averageUtilization target for the CPU metric must be 70. This means the HPA will scale the    number of pods up or down to try and maintain an average CPU utilization of 70% across all pods in the backend deployment
