package main

// #Service expose les pods du backend à l'intérieur du cluster (ClusterIP).
// L'ingress nginx route le trafic externe vers ce service.
#Service: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      "\(values.metadata.name)-svc"
		namespace: values.metadata.namespace
		labels:    _commonLabels
	}
	spec: {
		type: "ClusterIP"
		selector: "app.kubernetes.io/name": values.metadata.name
		ports: [{
			name:       "http"
			port:       values.service.port
			targetPort: values.service.targetPort
			protocol:   "TCP"
		}]
	}
}
