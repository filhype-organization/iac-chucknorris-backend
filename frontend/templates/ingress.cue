package templates

#Ingress: {
	#config: #Config

	_labels: {
		"app.kubernetes.io/name":       #config.metadata.name
		"app.kubernetes.io/managed-by": "timoni"
	} & #config.metadata.labels

	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		name:      "\(#config.metadata.name)-ingress"
		namespace: #config.metadata.namespace
		labels:    _labels
		annotations: {
			"traefik.ingress.kubernetes.io/router.entrypoints": "web"
		} & #config.metadata.annotations
	}
	spec: {
		ingressClassName: #config.ingress.ingressClassName
		rules: [{
			host: #config.ingress.host
			http: paths: [{
				path:     "/"
				pathType: "Prefix"
				backend: service: {
					name: "\(#config.metadata.name)-svc"
					port: number: #config.service.port
				}
			}]
		}]
	}
}
