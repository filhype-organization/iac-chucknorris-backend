package templates

#Configmap: {
	#config: #Config

	_labels: {
		"app.kubernetes.io/name":       #config.metadata.name
		"app.kubernetes.io/managed-by": "timoni"
	} & #config.metadata.labels

	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "\(#config.metadata.name)-config"
		namespace: #config.metadata.namespace
		labels:    _labels
	}
	data: {
		NG_APP_API_URL:   #config.app.apiUrl
		NG_APP_AUTH_URL:  #config.app.authUrl
		NG_APP_CLIENT_ID: #config.app.clientId
	}
}
