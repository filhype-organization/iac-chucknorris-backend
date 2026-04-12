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

// Objets Kubernetes générés par ce module.
// Le Secret auth0-oidc-secret est géré hors du module via un SealedSecret
// (auth0-sealed-secret.yaml) — le Deployment le référence mais Timoni ne le crée pas.
instance: v1alpha1.#Instance & {
	objects: [
		#Configmap,
		#Deployment,
		#Service,
		if values.ingress.enabled {#Ingress},
	]
}
