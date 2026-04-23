package main

#Namespace: {
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name:   values.metadata.namespace
		labels: _commonLabels
	}
}
