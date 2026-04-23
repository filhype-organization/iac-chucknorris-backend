package main

// #Configmap contient toute la configuration non-sensible de Quarkus sous forme
// de variables d'environnement. Quarkus 3 lit les propriétés quarkus.* depuis les
// env vars en convertissant : -> _, majuscules et - -> _.
// Ex: quarkus.oidc.auth-server-url → QUARKUS_OIDC_AUTH_SERVER_URL
//
// NOTE : les propriétés préfixées %dev dans application.properties ne s'activent
// PAS en production. Ce ConfigMap les fournit explicitement pour l'environnement K8s.
#Configmap: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "\(values.metadata.name)-config"
		namespace: values.metadata.namespace
		labels:    _commonLabels
	}
	data: {
		// ── Datasource ───────────────────────────────────────────────────────────
		// Le JDBC URL est construit dynamiquement à partir des valeurs du module.
		QUARKUS_DATASOURCE_JDBC_URL:              "jdbc:postgresql://\(values.database.host):\(values.database.port)/\(values.database.name)"

		// ── Hibernate ORM ────────────────────────────────────────────────────────
		// "validate" vérifie le schéma sans le modifier — ne jamais utiliser
		// "create" ou "drop-and-create" sur une base de production.
		QUARKUS_HIBERNATE_ORM_DATABASE_GENERATION: values.hibernate.databaseGeneration

		// ── OIDC Auth0 (champs non-sensibles) ───────────────────────────────────
		// Le clientSecret est injecté depuis le Secret K8s (voir secret.cue).
		QUARKUS_OIDC_CLIENT_ID:                                values.oidc.clientId
		QUARKUS_OIDC_TOKEN_ISSUER:                             values.oidc.issuer
		QUARKUS_OIDC_AUTH_SERVER_URL:                          values.oidc.authServerUrl
		QUARKUS_OIDC_TOKEN_AUDIENCE:                           values.oidc.audience
		QUARKUS_OIDC_APPLICATION_TYPE:                         values.oidc.applicationType
		QUARKUS_OIDC_TOKEN_VERIFY_ACCESS_TOKEN_WITH_USER_INFO: values.oidc.verifyWithUserInfo
		QUARKUS_OIDC_ROLES_ROLE_CLAIM_PATH:                    values.oidc.roleClaimPath

		// ── CORS ─────────────────────────────────────────────────────────────────
		QUARKUS_HTTP_CORS:                                     "true"
		QUARKUS_HTTP_CORS_ORIGINS:                             values.cors.origins
		QUARKUS_HTTP_CORS_METHODS:                             values.cors.methods
		QUARKUS_HTTP_CORS_HEADERS:                             values.cors.headers
		QUARKUS_HTTP_CORS_EXPOSED_HEADERS:                     values.cors.exposedHeaders
		QUARKUS_HTTP_CORS_ACCESS_CONTROL_ALLOW_CREDENTIALS:    values.cors.allowCredentials
	}
}
