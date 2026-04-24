@if(!debug)

package main

values: {
	metadata: {
		labels:      {}
		annotations: {}
	}
	image: {
		repository: "leeson77/chuck-norris-frontend"
		tag:        "latest"
		digest:     ""
		pullPolicy: "IfNotPresent"
	}
	replicas: 1
	resources: {
		requests: {
			cpu:    "50m"
			memory: "32Mi"
		}
		limits: {
			cpu:    "200m"
			memory: "128Mi"
		}
	}
	service: {
		port:       80
		targetPort: 80
	}
	ingress: {
		enabled:          true
		host:             "chuck.filhype.ovh"
		ingressClassName: "traefik"
	}
	app: {
		apiUrl:   "https://chuck.filhype.ovh/api"
		authUrl:  "https://dev-lesson.eu.auth0.com"
		clientId: ""
	}
}
