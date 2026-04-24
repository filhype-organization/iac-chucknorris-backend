package templates

#Config: {
	metadata: {
		name:        *"chuck-norris-frontend" | string
		namespace:   *"chuck-norris" | string
		labels:      *{} | {[string]: string}
		annotations: *{} | {[string]: string}
	}

	image: {
		repository: *"leeson77/chuck-norris-frontend" | string
		tag:        *"latest" | string
		digest:     *"" | string
		pullPolicy: *"IfNotPresent" | "Always" | "Never"
	}

	replicas: *1 | int & >=0

	resources: {
		requests: {
			cpu:    *"50m" | string
			memory: *"32Mi" | string
		}
		limits: {
			cpu:    *"200m" | string
			memory: *"128Mi" | string
		}
	}

	service: {
		port:       *80 | int
		targetPort: *80 | int
	}

	ingress: {
		enabled:          *true | bool
		host:             *"chuck.filhype.ovh" | string
		ingressClassName: *"traefik" | string
	}

	app: {
		apiUrl:   *"https://chuck.filhype.ovh/api" | string
		authUrl:  *"https://dev-lesson.eu.auth0.com" | string
		clientId: *"" | string
	}
}
