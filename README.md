#!/bin/bash

# Definindo os node pools
declare -a node_pools=("nodepool-bkl-api", "nodepool-bkl-infra", "nodepool-bkl-kafka")

# Arquivo de saída CSV
output_file="pod_resources.csv"

# Cabeçalho da tabela
echo "Node Pool,Pod,CPU Requests,Memory Requests,CPU Limits,Memory Limits" > "$output_file"

# Iterando sobre cada node pool
for node_pool in "${node_pools[@]}"; do
    # Obtendo a lista de nodes no node pool
    node_names=$(kubectl get nodes -l cloud.google.com/gke-nodepool=$node_pool -o jsonpath='{.items[*].metadata.name}')
    
    # Verificando se a lista de nodes não está vazia
    if [ -z "$node_names" ]; then
        continue
    fi
    
    # Listando os pods com requests e limits nos nodes específicos e escrevendo no CSV
    for node in $node_names; do
        kubectl get pods --all-namespaces --field-selector spec.nodeName=$node -o jsonpath='{range .items[*]}{.metadata.name}{","}{range .spec.containers[*]}{.resources.requests.cpu}{" "}{end}{","}{range .spec.containers[*]}{.resources.requests.memory}{" "}{end}{","}{range .spec.containers[*]}{.resources.limits.cpu}{" "}{end}{","}{range .spec.containers[*]}{.resources.limits.memory}{" "}{end}{"\n"}{end}' | awk -v np="$node_pool" -F, -v OFS=',' '{print np,$0}' >> "$output_file"
    done
done

echo "CSV file created: $output_file"
