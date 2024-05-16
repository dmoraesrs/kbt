#!/bin/bash

# Header
echo -e "NAMESPACE\tHPA_NAME\tMIN_REPLICAS\tMAX_REPLICAS\tCPU_TARGET\tMEMORY_TARGET"

# Fetch and format HPA data
kubectl get hpa --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.spec.minReplicas}{"\t"}{.spec.maxReplicas}{"\t"}{range .spec.metrics[*]}{.resource.name}{"\t"}{.resource.target.averageUtilization}{"\n"}{end}{end}' | awk '
BEGIN {
  OFS="\t"
}
{
  if ($5 == "cpu") {
    cpu_target=$6
  } else if ($5 == "memory") {
    memory_target=$6
  }
  if (cpu_target != "" && memory_target != "") {
    print $1, $2, $3, $4, cpu_target, memory_target
    cpu_target=""
    memory_target=""
  }
}' | column -t
