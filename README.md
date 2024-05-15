#!/bin/bash

# Definindo os node pools
declare -a node_pools=("nodepool-bkl-api" "nodepool-bkl-infra" "nodepool-bkl-kafka")

# Cabeçalho da tabela
echo "NODE POOL | NAMESPACE | POD | CONTAINER | NODE | CPU REQUESTS | MEMORY REQUESTS | CPU LIMITS | MEMORY LIMITS"
echo "-------------------------------------------------------------------------------------------"

# Iterando sobre cada node pool
for node_pool in "${node_pools[@]}"; do
    echo "Checking node pool: $node_pool"
    
    # Obtendo a lista de nodes no node pool
    node_names=$(kubectl get nodes -l cloud.google.com/gke-nodepool=$node_pool -o jsonpath='{.items[*].metadata.name}')
    
    # Verificando se a lista de nodes não está vazia
    if [ -z "$node_names" ]; then
        echo "No nodes found for the node pool: $node_pool"
        echo ""
        continue
    fi
    
    # Listando os pods com requests e limits nos nodes específicos
    for node in $node_names; do
        kubectl get pods --all-namespaces -o custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,CONTAINER:.spec.containers[*].name,NODE:.spec.nodeName,CPU_REQUESTS:.spec.containers[*].resources.requests.cpu,MEMORY_REQUESTS:.spec.containers[*].resources.requests.memory,CPU_LIMITS:.spec.containers[*].resources.limits.cpu,MEMORY_LIMITS:.spec.containers[*].resources.limits.memory' --field-selector spec.nodeName=$node | tail -n +2 | awk -v np="$node_pool" -v n="$node" '{print np " | " $0 " | " n}'
    done
    
    echo "-------------------------------------------------------------------------------------------"
done | column -t -s '|'
