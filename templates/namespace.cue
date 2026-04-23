package templates

#Namespace: {
	#config: #Config

	_labels: {
		"app.kubernetes.io/name":       #config.metadata.name
		"app.kubernetes.io/managed-by": "timoni"
	} & #config.metadata.labels

	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name:   #config.metadata.namespace
		labels: _labels
	}
}
