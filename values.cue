package main

// #Values définit le schéma et les valeurs par défaut du module chuck-norris-backend.
// Les champs sans valeur par défaut (ex: sealedSecrets.*) sont obligatoires
// et doivent être fournis via prod-values.cue au moment du déploiement.
#Values: {
	// Métadonnées appliquées à toutes les ressources Kubernetes.
	metadata: {
		name:        *"chuck-norris-backend" | string
		namespace:   *"chuck-norris" | string
		labels:      *{} | {[string]: string}
		annotations: *{} | {[string]: string}
	}

	// Image du conteneur.
	image: {
		repository: *"leeson77/chuck-norris-backend" | string
		// Le tag est mis à jour automatiquement par le job CI update-iac.
		tag:        *"latest" | string
		pullPolicy: *"IfNotPresent" | "Always" | "Never"
	}

	// Nombre de répliques. Le binaire natif Quarkus démarre en ~20 ms,
	// donc un rolling-update même à replicas:1 est viable.
	replicas: *1 | int & >=0

	// Ressources CPU / mémoire du conteneur.
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

	// Service Kubernetes (ClusterIP).
	service: {
		port:       *80 | int
		targetPort: *8080 | int
	}

	// Ingress Traefik — TLS terminé par Cloudflare, pas de cert-manager.
	ingress: {
		enabled:          *true | bool
		host:             *"chuck.filhype.ovh" | string
		path:             *"/api" | string
		ingressClassName: *"traefik" | string
	}

	// Connexion à la base PostgreSQL — CloudNativePG dans le namespace "postgres".
	database: {
		name:           *"app" | string
		host:           *"postgres-rw.postgres.svc.cluster.local" | string
		port:           *5432 | int
		credSecretName: *"database-secret" | string
	}

	// Configuration OIDC Auth0 (champs non-sensibles).
	// Le clientSecret est dans le SealedSecret généré par #Auth0SealedSecret.
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

	// DDL Hibernate ORM.
	hibernate: {
		databaseGeneration: *"validate" | string
	}

	// CORS pour le frontend.
	cors: {
		origins:          *"https://chuck.filhype.ovh" | string
		methods:          *"GET,POST,PUT,DELETE" | string
		headers:          *"Content-Type,Authorization" | string
		exposedHeaders:   *"X-Total-Count" | string
		allowCredentials: *"true" | string
	}

	// Blobs chiffrés pour les SealedSecrets — cluster-spécifiques, safe à commiter.
	// Générés avec : kubeseal --fetch-cert | kubeseal --cert ...
	sealedSecrets: {
		auth0: {
			// Clé résultante dans le Secret : QUARKUS_OIDC_CREDENTIALS_SECRET
			encryptedClientSecret: string
		}
		database: {
			// Clés résultantes dans le Secret : username, password
			encryptedUsername: string
			encryptedPassword: string
		}
	}
}
