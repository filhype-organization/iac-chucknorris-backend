package templates

#Service: {
	#config: #Config

	_labels: {
		"app.kubernetes.io/name":       #config.metadata.name
		"app.kubernetes.io/managed-by": "timoni"
	} & #config.metadata.labels

	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      "\(#config.metadata.name)-svc"
		namespace: #config.metadata.namespace
		labels:    _labels
	}
	spec: {
		type: "ClusterIP"
		selector: "app.kubernetes.io/name": #config.metadata.name
		ports: [{
			name:       "http"
			port:       #config.service.port
			targetPort: #config.service.targetPort
			protocol:   "TCP"
		}]
	}
}
