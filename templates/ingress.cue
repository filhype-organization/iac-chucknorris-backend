package main

// #Ingress expose le backend via nginx sur chuck.filhype.ovh/api.
//
// Réécriture de chemin :
//   Le Quarkus app sert ses endpoints à la racine ("/").
//   L'ingress capture le préfixe /api et le réécrit avant de transmettre au pod :
//     /api        → /
//     /api/jokes  → /jokes
//   Annotations utilisées :
//     rewrite-target: /$2   (groupe de capture 2 = tout après /api)
//     use-regex: "true"     (nécessaire pour les groupes de capture dans le path)
//
// TLS : cert-manager génère automatiquement le certificat Let's Encrypt.
#Ingress: {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		name:      "\(values.metadata.name)-ingress"
		namespace: values.metadata.namespace
		labels:    _commonLabels
		annotations: {
			// TLS via cert-manager
			"cert-manager.io/cluster-issuer":                 values.ingress.clusterIssuer

			// Réécriture du préfixe /api → /
			"nginx.ingress.kubernetes.io/rewrite-target":     "/$2"
			"nginx.ingress.kubernetes.io/use-regex":          "true"

			// Forcer HTTPS
			"nginx.ingress.kubernetes.io/ssl-redirect":       "true"
			"nginx.ingress.kubernetes.io/force-ssl-redirect": "true"

			// Logs d'accès (format identique à l'ingress existant)
			"nginx.ingress.kubernetes.io/enable-access-log": "true"
		} & values.metadata.annotations
	}
	spec: {
		ingressClassName: values.ingress.ingressClassName
		tls: [{
			hosts: [values.ingress.host]
			secretName: values.ingress.tlsSecretName
		}]
		rules: [{
			host: values.ingress.host
			http: paths: [{
				// Le groupe (/|$)(.*) est nécessaire pour la réécriture :
				//   /api       → /$2 = /
				//   /api/jokes → /$2 = /jokes
				path:     "\(values.ingress.path)(/|$)(.*)"
				pathType: "ImplementationSpecific"
				backend: service: {
					name: "\(values.metadata.name)-svc"
					port: number: values.service.port
				}
			}]
		}]
	}
}
