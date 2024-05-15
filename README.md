#!/bin/bash

# Definindo os node pools
declare -a node_pools=("nodepool-bkl-api" "nodepool-bkl-infra" "nodepool-bkl-kafka")

# Cabeçalho da tabela
echo "NODE POOL | POD | CPU REQUESTS | MEMORY REQUESTS | CPU LIMITS | MEMORY LIMITS"
echo "-----------------------------------------------------------------------------------"

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
        # Agora estamos agregando os recursos de todos os containers dentro do mesmo pod
        kubectl get pods --all-namespaces --field-selector spec.nodeName=$node -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.containers[*]}{.resources.requests.cpu}{" "}{end}{"\t"}{range .spec.containers[*]}{.resources.requests.memory}{" "}{end}{"\t"}{range .spec.containers[*]}{.resources.limits.cpu}{" "}{end}{"\t"}{range .spec.containers[*]}{.resources.limits.memory}{" "}{end}{"\n"}{end}' | awk -v np="$node_pool" '{print np " | " $0}'
    done
    
    echo "-----------------------------------------------------------------------------------"
done | column -t -s '|'
