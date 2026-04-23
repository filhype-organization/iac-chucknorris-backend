package main

// #Middleware configure le StripPrefix Traefik qui réécrit /api → /
// avant de transmettre la requête au pod Quarkus.
#Middleware: {
	apiVersion: "traefik.io/v1alpha1"
	kind:       "Middleware"
	metadata: {
		name:      "strip-api-prefix"
		namespace: values.metadata.namespace
		labels:    _commonLabels
	}
	spec: stripPrefix: prefixes: [values.ingress.path]
}
