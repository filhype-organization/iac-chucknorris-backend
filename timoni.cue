package main

import timoniv1 "timoni.sh/core/v1alpha1"

_commonLabels: {
	"app.kubernetes.io/name":       values.metadata.name
	"app.kubernetes.io/managed-by": "timoni"
} & values.metadata.labels

values: #Values & {
	metadata: {
		name:      string @tag(name)
		namespace: string @tag(namespace)
	}
}

timoni: {
	apiVersion: "v1alpha1"
	instance: {
		config: {
			image: timoniv1.#Image & {
				repository: values.image.repository
				tag:        values.image.tag
				digest:     ""
				pullPolicy: values.image.pullPolicy
			}
		}
		objects: [
			#Namespace,
			#Auth0SealedSecret,
			#DatabaseSealedSecret,
			#Configmap,
			#Service,
			#Middleware,
			#Deployment,
			if values.ingress.enabled {#Ingress},
		]
	}
	apply: app: [for obj in instance.objects {obj}]
}
