package main

// #Ingress expose le backend via Traefik sur chuck.filhype.ovh/api.
// TLS terminé par Cloudflare — le trafic Cloudflare → cluster est HTTP.
// Le Middleware strip-api-prefix réécrit /api → / avant de transmettre au pod.
#Ingress: {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		name:      "\(values.metadata.name)-ingress"
		namespace: values.metadata.namespace
		labels:    _commonLabels
		annotations: {
			"traefik.ingress.kubernetes.io/router.middlewares": "\(values.metadata.namespace)-strip-api-prefix@kubernetescrd"
			"traefik.ingress.kubernetes.io/router.entrypoints": "web"
		} & values.metadata.annotations
	}
	spec: {
		ingressClassName: values.ingress.ingressClassName
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
