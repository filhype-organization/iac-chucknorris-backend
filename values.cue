@if(!debug)

package main

values: {
	metadata: {
		labels:      {}
		annotations: {}
	}
	image: {
		repository: "leeson77/chuck-norris-backend"
		tag:        "latest"
		digest:     ""
		pullPolicy: "IfNotPresent"
	}
	replicas: 1
	resources: {
		requests: {
			cpu:    "100m"
			memory: "64Mi"
		}
		limits: {
			cpu:    "500m"
			memory: "256Mi"
		}
	}
	service: {
		port:       80
		targetPort: 8080
	}
	ingress: {
		enabled:          true
		host:             "chuck.filhype.ovh"
		path:             "/api"
		ingressClassName: "traefik"
	}
	database: {
		name:           "app"
		host:           "postgres-rw.postgres.svc.cluster.local"
		port:           5432
		credSecretName: "database-secret"
	}
	oidc: {
		clientId:           "2GSRAJdfhRYURWjwlnYwJlJN4J9cEi4o"
		issuer:             "https://dev-lesson.eu.auth0.com/"
		authServerUrl:      "https://dev-lesson.eu.auth0.com"
		audience:           "chuck-norris-api"
		applicationType:    "service"
		verifyWithUserInfo: "false"
		roleClaimPath:      "scope"
		secretName:         "auth0-oidc-secret"
	}
	hibernate: databaseGeneration: "validate"
	cors: {
		origins:          "https://chuck.filhype.ovh"
		methods:          "GET,POST,PUT,DELETE"
		headers:          "Content-Type,Authorization"
		exposedHeaders:   "X-Total-Count"
		allowCredentials: "true"
	}
}
