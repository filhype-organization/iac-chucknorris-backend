package templates

#Configmap: {
	#config: #Config

	_labels: {
		"app.kubernetes.io/name":       #config.metadata.name
		"app.kubernetes.io/managed-by": "timoni"
	} & #config.metadata.labels

	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "\(#config.metadata.name)-config"
		namespace: #config.metadata.namespace
		labels:    _labels
	}
	data: {
		QUARKUS_DATASOURCE_JDBC_URL:                               "jdbc:postgresql://\(#config.database.host):\(#config.database.port)/\(#config.database.name)"
		QUARKUS_HIBERNATE_ORM_DATABASE_GENERATION:                 #config.hibernate.databaseGeneration
		QUARKUS_OIDC_CLIENT_ID:                                    #config.oidc.clientId
		QUARKUS_OIDC_TOKEN_ISSUER:                                 #config.oidc.issuer
		QUARKUS_OIDC_AUTH_SERVER_URL:                              #config.oidc.authServerUrl
		QUARKUS_OIDC_TOKEN_AUDIENCE:                               #config.oidc.audience
		QUARKUS_OIDC_APPLICATION_TYPE:                             #config.oidc.applicationType
		QUARKUS_OIDC_TOKEN_VERIFY_ACCESS_TOKEN_WITH_USER_INFO:     #config.oidc.verifyWithUserInfo
		QUARKUS_OIDC_ROLES_ROLE_CLAIM_PATH:                        #config.oidc.roleClaimPath
		QUARKUS_HTTP_CORS:                                         "true"
		QUARKUS_HTTP_CORS_ORIGINS:                                 #config.cors.origins
		QUARKUS_HTTP_CORS_METHODS:                                 #config.cors.methods
		QUARKUS_HTTP_CORS_HEADERS:                                 #config.cors.headers
		QUARKUS_HTTP_CORS_EXPOSED_HEADERS:                         #config.cors.exposedHeaders
		QUARKUS_HTTP_CORS_ACCESS_CONTROL_ALLOW_CREDENTIALS:        #config.cors.allowCredentials
	}
}
