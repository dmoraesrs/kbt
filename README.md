#!/bin/bash

NAMESPACE="kafka"
PVC_NAMES=("pvc-1" "pvc-2" "pvc-3")

# Deletar PVCs
for PVC in "${PVC_NAMES[@]}"; do
  kubectl delete pvc "$PVC" -n "$NAMESPACE"
done

# Aguardar um momento para os PVCs serem deletados
sleep 5

# Verificar e deletar PVs associados
for PVC in "${PVC_NAMES[@]}"; do
  PV=$(kubectl get pv -o json | jq -r '.items[] | select(.spec.claimRef.name=="'$PVC'") | .metadata.name')
  if [ ! -z "$PV" ]; then
    kubectl delete pv "$PV"
  fi
done
