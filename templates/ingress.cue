package main

// #Ingress expose le backend via Traefik sur chuck.filhype.ovh/api.
//
// TLS terminé par Cloudflare — le trafic Cloudflare → cluster est HTTP.
//
// Réécriture de chemin :
//   Le Quarkus app sert ses endpoints à la racine ("/").
//   Un Middleware Traefik (strip-api-prefix) réécrit avant de transmettre au pod :
//     /api        → /
//     /api/jokes  → /jokes
#Ingress: {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		name:      "\(values.metadata.name)-ingress"
		namespace: values.metadata.namespace
		labels:    _commonLabels
		annotations: {
			// Réécriture du préfixe /api → / via Middleware Traefik
			"traefik.ingress.kubernetes.io/router.middlewares": "\(values.metadata.namespace)-strip-api-prefix@kubernetescrd"

			// Entrypoint HTTP (TLS géré par Cloudflare)
			"traefik.ingress.kubernetes.io/router.entrypoints": "web"
		} & values.metadata.annotations
	}
	spec: {
		ingressClassName: values.ingress.ingressClassName
		rules: [{
			host: values.ingress.host
			http: paths: [{
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
