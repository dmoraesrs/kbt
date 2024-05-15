#!/bin/bash

# Arquivo de saída CSV
output_file="node_pools_pod_resources.csv"

# Escrevendo o cabeçalho do arquivo CSV
echo "Node Pool,Pod,Container,CPU Requests,Memory Requests,CPU Limits,Memory Limits" > "$output_file"

# Definindo os node pools
declare -a node_pools=("nodepool-bkl-api" "nodepool-bkl-infra" "nodepool-bkl-kafka")

# Iterando sobre cada node pool
for node_pool in "${node_pools[@]}"; do
    
    # Obtendo a lista de nodes no node pool
    node_names=$(kubectl get nodes -l cloud.google.com/gke-nodepool=$node_pool -o jsonpath='{.items[*].metadata.name}')
    
    # Verificando se a lista de nodes não está vazia
    if [ -z "$node_names" ]; then
        echo "No nodes found for the node pool: $node_pool"
        continue
    fi
    
    # Listando os pods com requests e limits nos nodes específicos
    for node in $node_names; do
        kubectl get pods --all-namespaces -o custom-columns='POD:.metadata.name,CONTAINER:.spec.containers[*].name,CPU_REQUESTS:.spec.containers[*].resources.requests.cpu,MEMORY_REQUESTS:.spec.containers[*].resources.requests.memory,CPU_LIMITS:.spec.containers[*].resources.limits.cpu,MEMORY_LIMITS:.spec.containers[*].resources.limits.memory' --field-selector spec.nodeName=$node | tail -n +2 | awk -v np="$node_pool" -F"," 'BEGIN {OFS=","} {print np,$1,$2,$3,$4,$5,$6}' >> "$output_file"
    done
    
done

echo "CSV file created: $output_file"
