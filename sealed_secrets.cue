package main

// #Auth0SealedSecret génère le SealedSecret déchiffré par le controller
// bitnami/sealed-secrets. Le blob chiffré est cluster-spécifique et
// fourni via prod-values.cue (safe à commiter, chiffré avec la clé publique du cluster).
#Auth0SealedSecret: {
	apiVersion: "bitnami.com/v1alpha1"
	kind:       "SealedSecret"
	metadata: {
		creationTimestamp: null
		name:              values.oidc.secretName
		namespace:         values.metadata.namespace
	}
	spec: {
		encryptedData: {
			QUARKUS_OIDC_CREDENTIALS_SECRET: values.sealedSecrets.auth0.encryptedClientSecret
		}
		template: metadata: {
			creationTimestamp: null
			name:              values.oidc.secretName
			namespace:         values.metadata.namespace
		}
	}
}

// #DatabaseSealedSecret génère le SealedSecret pour les credentials PostgreSQL.
// Les clés "username" et "password" correspondent aux clés attendues
// dans le Deployment (via secretKeyRef).
#DatabaseSealedSecret: {
	apiVersion: "bitnami.com/v1alpha1"
	kind:       "SealedSecret"
	metadata: {
		creationTimestamp: null
		name:              values.database.credSecretName
		namespace:         values.metadata.namespace
	}
	spec: {
		encryptedData: {
			username: values.sealedSecrets.database.encryptedUsername
			password: values.sealedSecrets.database.encryptedPassword
		}
		template: metadata: {
			creationTimestamp: null
			name:              values.database.credSecretName
			namespace:         values.metadata.namespace
		}
	}
}
