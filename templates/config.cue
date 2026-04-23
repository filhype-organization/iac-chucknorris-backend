package templates

#Config: {
	metadata: {
		name:        *"chuck-norris-backend" | string
		namespace:   *"chuck-norris" | string
		labels:      *{} | {[string]: string}
		annotations: *{} | {[string]: string}
	}

	image: {
		repository: *"leeson77/chuck-norris-backend" | string
		tag:        *"latest" | string
		digest:     *"" | string
		pullPolicy: *"IfNotPresent" | "Always" | "Never"
	}

	replicas: *1 | int & >=0

	resources: {
		requests: {
			cpu:    *"100m" | string
			memory: *"64Mi" | string
		}
		limits: {
			cpu:    *"500m" | string
			memory: *"256Mi" | string
		}
	}

	service: {
		port:       *80 | int
		targetPort: *8080 | int
	}

	ingress: {
		enabled:          *true | bool
		host:             *"chuck.filhype.ovh" | string
		path:             *"/api" | string
		ingressClassName: *"traefik" | string
	}

	database: {
		name:           *"app" | string
		host:           *"postgres-rw.postgres.svc.cluster.local" | string
		port:           *5432 | int
		credSecretName: *"database-secret" | string
	}

	oidc: {
		clientId:           *"2GSRAJdfhRYURWjwlnYwJlJN4J9cEi4o" | string
		issuer:             *"https://dev-lesson.eu.auth0.com/" | string
		authServerUrl:      *"https://dev-lesson.eu.auth0.com" | string
		audience:           *"chuck-norris-api" | string
		applicationType:    *"service" | string
		verifyWithUserInfo: *"false" | string
		roleClaimPath:      *"scope" | string
		secretName:         *"auth0-oidc-secret" | string
	}

	hibernate: {
		databaseGeneration: *"validate" | string
	}

	cors: {
		origins:          *"https://chuck.filhype.ovh" | string
		methods:          *"GET,POST,PUT,DELETE" | string
		headers:          *"Content-Type,Authorization" | string
		exposedHeaders:   *"X-Total-Count" | string
		allowCredentials: *"true" | string
	}

	sealedSecrets: {
		auth0: {
			encryptedClientSecret: *"" | string
		}
		database: {
			encryptedUsername: *"" | string
			encryptedPassword: *"" | string
		}
	}
}
