package main

import "timoni.sh/core/v1alpha1"

// Labels communs injectés sur toutes les ressources K8s du module.
_commonLabels: {
	"app.kubernetes.io/name":       values.metadata.name
	"app.kubernetes.io/managed-by": "timoni"
} & values.metadata.labels

// Configuration du module Timoni.
timoni: v1alpha1.#Config & {}

// Valeurs par défaut — surcharger avec -f prod-values.cue au déploiement.
values: #Values & {}

// Objets Kubernetes générés par ce module, appliqués dans l'ordre.
// L'ordre garantit que le Namespace et les Secrets existent avant le Deployment.
instance: v1alpha1.#Instance & {
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
