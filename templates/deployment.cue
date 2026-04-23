package templates

#Deployment: {
	#config: #Config

	_labels: {
		"app.kubernetes.io/name":       #config.metadata.name
		"app.kubernetes.io/managed-by": "timoni"
	} & #config.metadata.labels

	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name:      #config.metadata.name
		namespace: #config.metadata.namespace
		labels:    _labels
	}
	spec: {
		replicas: #config.replicas
		selector: matchLabels: "app.kubernetes.io/name": #config.metadata.name
		template: {
			metadata: labels: _labels
			spec: {
				containers: [{
					name:            #config.metadata.name
					image:           "\(#config.image.repository):\(#config.image.tag)"
					imagePullPolicy: #config.image.pullPolicy

					ports: [{
						name:          "http"
						containerPort: #config.service.targetPort
						protocol:      "TCP"
					}]

					envFrom: [
						{configMapRef: name: "\(#config.metadata.name)-config"},
						{secretRef: name: #config.oidc.secretName},
					]

					env: [
						{
							name: "QUARKUS_DATASOURCE_USERNAME"
							valueFrom: secretKeyRef: {
								name: #config.database.credSecretName
								key:  "username"
							}
						},
						{
							name: "QUARKUS_DATASOURCE_PASSWORD"
							valueFrom: secretKeyRef: {
								name: #config.database.credSecretName
								key:  "password"
							}
						},
					]

					livenessProbe: {
						httpGet: {
							path: "/q/health/live"
							port: #config.service.targetPort
						}
						initialDelaySeconds: 5
						periodSeconds:       15
						failureThreshold:    3
						timeoutSeconds:      2
					}

					readinessProbe: {
						httpGet: {
							path: "/q/health/ready"
							port: #config.service.targetPort
						}
						initialDelaySeconds: 5
						periodSeconds:       10
						failureThreshold:    3
						timeoutSeconds:      2
					}

					resources: {
						requests: {
							cpu:    #config.resources.requests.cpu
							memory: #config.resources.requests.memory
						}
						limits: {
							cpu:    #config.resources.limits.cpu
							memory: #config.resources.limits.memory
						}
					}

					securityContext: {
						allowPrivilegeEscalation: false
						readOnlyRootFilesystem:   true
						runAsNonRoot:             true
						runAsUser:                1001
						capabilities: drop: ["ALL"]
					}

					volumeMounts: [{
						name:      "tmp"
						mountPath: "/tmp"
					}]
				}]

				volumes: [{
					name: "tmp"
					emptyDir: {}
				}]
			}
		}
	}
}
