package main

// #Ingress expose le backend via Traefik sur chuck.filhype.ovh/api.
//
// Réécriture de chemin :
//   Le Quarkus app sert ses endpoints à la racine ("/").
//   Un Middleware Traefik (strip-api-prefix) capture le préfixe /api et le
//   réécrit avant de transmettre au pod :
//     /api        → /
//     /api/jokes  → /jokes
//   Annotation utilisée :
//     traefik.ingress.kubernetes.io/router.middlewares: <ns>-strip-api-prefix@kubernetescrd
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
			"cert-manager.io/cluster-issuer": values.ingress.clusterIssuer

			// Réécriture du préfixe /api → / via Middleware Traefik
			"traefik.ingress.kubernetes.io/router.middlewares": "\(values.metadata.namespace)-strip-api-prefix@kubernetescrd"

			// Forcer HTTPS via l'entrypoint websecure
			"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
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
				path:     values.ingress.path
				pathType: "Prefix"
				backend: service: {
					name: "\(values.metadata.name)-svc"
					port: number: values.service.port
				}
			}]
		}]
	}
}
