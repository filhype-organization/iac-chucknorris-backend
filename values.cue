package main

// #Values définit le schéma et les valeurs par défaut du module chuck-norris-backend.
// Les champs sans valeur par défaut (ex: oidc.clientSecret) sont obligatoires
// et doivent être fournis via -f prod-values.cue au moment du déploiement.
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
		// Le tag doit correspondre à un digest publié sur hub.docker.com/r/leeson77/chuck-norris-backend.
		tag:        *"latest" | string
		pullPolicy: *"IfNotPresent" | "Always" | "Never"
	}

	// Nombre de répliques. Le binaire natif Quarkus démarre en ~20 ms,
	// donc un rolling-update même à replicas:1 est viable.
	replicas: *1 | int & >=0

	// Ressources CPU / mémoire du conteneur.
	// Le binaire natif consomme très peu de RAM (~50 Mi en idle).
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

	// Ingress nginx avec TLS via cert-manager.
	ingress: {
		enabled:          *true | bool
		host:             *"chuck.filhype.ovh" | string
		// Le préfixe /api est réécrit vers / via rewrite-target (voir ingress.cue).
		path:             *"/api" | string
		tlsSecretName:    *"filhype-ingress-tls" | string
		clusterIssuer:    *"lets-encrypt" | string
		ingressClassName: *"nginx" | string
	}

	// Connexion à la base PostgreSQL — CloudNativePG dans le namespace "postgres".
	// Les credentials (username/password) sont dans le SealedSecret db-sealed-secret.yaml
	// (namespace chuck-norris) — ce module ne le recrée pas.
	database: {
		// Base "app" créée par défaut par CloudNativePG.
		name:           *"app" | string
		// Service read-write du cluster CNPG, adressé en cross-namespace via FQDN.
		host:           *"postgres-rw.postgres.svc.cluster.local" | string
		port:           *5432 | int
		credSecretName: *"database-secret" | string
	}

	// Configuration OIDC Auth0.
	// Le clientSecret est dans le SealedSecret auth0-sealed-secret.yaml (hors module Timoni).
	oidc: {
		clientId:           *"2GSRAJdfhRYURWjwlnYwJlJN4J9cEi4o" | string
		issuer:             *"https://dev-lesson.eu.auth0.com/" | string
		authServerUrl:      *"https://dev-lesson.eu.auth0.com" | string
		audience:           *"chuck-norris-api" | string
		applicationType:    *"service" | string
		verifyWithUserInfo: *"false" | string
		roleClaimPath:      *"scope" | string
		// Nom du Secret K8s créé par le SealedSecret (doit correspondre à auth0-sealed-secret.yaml).
		secretName: *"auth0-oidc-secret" | string
	}

	// DDL Hibernate ORM.
	// "validate" : vérifie le schéma au démarrage sans le modifier (recommandé en prod).
	// "none"     : pas de vérification (plus rapide, à utiliser si vous gérez le schéma vous-même).
	hibernate: {
		databaseGeneration: *"validate" | string
	}

	// CORS pour le frontend en production.
	cors: {
		origins:          *"https://chuck.filhype.ovh" | string
		methods:          *"GET,POST,PUT,DELETE" | string
		headers:          *"Content-Type,Authorization" | string
		exposedHeaders:   *"X-Total-Count" | string
		allowCredentials: *"true" | string
	}
}
