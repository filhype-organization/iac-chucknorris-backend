package templates

#Middleware: {
	#config: #Config

	_labels: {
		"app.kubernetes.io/name":       #config.metadata.name
		"app.kubernetes.io/managed-by": "timoni"
	} & #config.metadata.labels

	apiVersion: "traefik.io/v1alpha1"
	kind:       "Middleware"
	metadata: {
		name:      "strip-api-prefix"
		namespace: #config.metadata.namespace
		labels:    _labels
	}
	spec: stripPrefix: prefixes: [#config.ingress.path]
}
