package main

// #Deployment gère les pods chuck-norris-backend.
//
// Stratégie d'injection de configuration :
//  - envFrom configMapRef  → toute la config non-sensible (OIDC, CORS, JDBC URL…)
//  - envFrom secretRef     → QUARKUS_OIDC_CREDENTIALS_SECRET depuis auth0-oidc-secret
//  - env valueFrom         → username / password DB depuis database-secret (SealedSecret)
//    Les clés du SealedSecret sont "username" et "password", pas des noms d'env vars
//    Quarkus, d'où le mapping explicite.
//
// Health probes : SmallRye Health expose /q/health/live et /q/health/ready.
// Le binaire natif Quarkus démarre en < 100 ms, donc initialDelaySeconds peut
// rester faible.
#Deployment: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      values.metadata.name
		namespace: values.metadata.namespace
		labels:    _commonLabels
	}
	spec: {
		replicas: values.replicas
		selector: matchLabels: "app.kubernetes.io/name": values.metadata.name
		template: {
			metadata: labels: _commonLabels
			spec: {
				containers: [{
					name:            values.metadata.name
					image:           "\(values.image.repository):\(values.image.tag)"
					imagePullPolicy: values.image.pullPolicy

					ports: [{
						name:          "http"
						containerPort: values.service.targetPort
						protocol:      "TCP"
					}]

					// Chargement de la configuration depuis le ConfigMap et les Secrets.
					envFrom: [
						// Toute la config non-sensible : OIDC (non-secret), CORS, JDBC URL, Hibernate.
						{configMapRef: name: "\(values.metadata.name)-config"},
						// Secret OIDC : injecte QUARKUS_OIDC_CREDENTIALS_SECRET directement.
						{secretRef: name: values.oidc.secretName},
					]

					// Credentials DB : les clés du SealedSecret sont "username"/"password",
					// pas des noms de variables Quarkus → mapping explicite.
					env: [
						{
							name: "QUARKUS_DATASOURCE_USERNAME"
							valueFrom: secretKeyRef: {
								name: values.database.credSecretName
								key:  "username"
							}
						},
						{
							name: "QUARKUS_DATASOURCE_PASSWORD"
							valueFrom: secretKeyRef: {
								name: values.database.credSecretName
								key:  "password"
							}
						},
					]

					// Liveness : K8s redémarre le pod si l'app ne répond plus.
					livenessProbe: {
						httpGet: {
							path: "/q/health/live"
							port: values.service.targetPort
						}
						initialDelaySeconds: 5
						periodSeconds:       15
						failureThreshold:    3
						timeoutSeconds:      2
					}

					// Readiness : K8s retire le pod du Service tant qu'il n'est pas prêt.
					// Quarkus attend la connexion DB avant de passer ready.
					readinessProbe: {
						httpGet: {
							path: "/q/health/ready"
							port: values.service.targetPort
						}
						initialDelaySeconds: 5
						periodSeconds:       10
						failureThreshold:    3
						timeoutSeconds:      2
					}

					resources: {
						requests: {
							cpu:    values.resources.requests.cpu
							memory: values.resources.requests.memory
						}
						limits: {
							cpu:    values.resources.limits.cpu
							memory: values.resources.limits.memory
						}
					}

					// Durcissement de sécurité du conteneur natif.
					securityContext: {
						allowPrivilegeEscalation: false
						readOnlyRootFilesystem:   true
						runAsNonRoot:             true
						runAsUser:                1001
						capabilities: drop: ["ALL"]
					}
				}]

				// Volume tmpfs pour les fichiers temporaires du runtime Quarkus natif.
				volumes: [{
					name: "tmp"
					emptyDir: {}
				}]
			}
		}
	}
}
