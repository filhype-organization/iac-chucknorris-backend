package templates

#Auth0SealedSecret: {
	#config: #Config

	apiVersion: "bitnami.com/v1alpha1"
	kind:       "SealedSecret"
	metadata: {
		creationTimestamp: null
		name:              #config.oidc.secretName
		namespace:         #config.metadata.namespace
	}
	spec: {
		encryptedData: {
			QUARKUS_OIDC_CREDENTIALS_SECRET: #config.sealedSecrets.auth0.encryptedClientSecret
		}
		template: metadata: {
			creationTimestamp: null
			name:              #config.oidc.secretName
			namespace:         #config.metadata.namespace
		}
	}
}

#DatabaseSealedSecret: {
	#config: #Config

	apiVersion: "bitnami.com/v1alpha1"
	kind:       "SealedSecret"
	metadata: {
		creationTimestamp: null
		name:              #config.database.credSecretName
		namespace:         #config.metadata.namespace
	}
	spec: {
		encryptedData: {
			username: #config.sealedSecrets.database.encryptedUsername
			password: #config.sealedSecrets.database.encryptedPassword
		}
		template: metadata: {
			creationTimestamp: null
			name:              #config.database.credSecretName
			namespace:         #config.metadata.namespace
		}
	}
}
