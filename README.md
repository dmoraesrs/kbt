      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: "topology.kubernetes.io/zone"
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app.kubernetes.io/name: kafka
            strimzi.io/cluster: {{ .Values.kafkaClusterName }} #${mskCorpCluster}
            strimzi.io/component-type: kafka
