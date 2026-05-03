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
			metadata: {
				labels: _labels
				annotations: "checksum/config": "\(#config.app.authUrl)|\(#config.app.apiUrl)|\(#config.app.clientId)"
			}
			spec: {
				nodeSelector: "kubernetes.io/arch": "amd64"

				containers: [{
					name:            #config.metadata.name
					image:           "\(#config.image.repository):\(#config.image.tag)"
					imagePullPolicy: #config.image.pullPolicy

					ports: [{
						name:          "http"
						containerPort: #config.service.targetPort
						protocol:      "TCP"
					}]

					envFrom: [{
						configMapRef: name: "\(#config.metadata.name)-config"
					}]

					livenessProbe: {
						httpGet: {
							path: "/"
							port: #config.service.targetPort
						}
						initialDelaySeconds: 5
						periodSeconds:       15
						failureThreshold:    3
						timeoutSeconds:      2
					}

					readinessProbe: {
						httpGet: {
							path: "/"
							port: #config.service.targetPort
						}
						initialDelaySeconds: 3
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
				}]
			}
		}
	}
}
