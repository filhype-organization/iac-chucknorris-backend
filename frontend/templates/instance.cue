package templates

#Instance: {
	config: #Config

	_cm:  #Configmap & {#config:  config}
	_svc: #Service & {#config:    config}
	_dep: #Deployment & {#config: config}
	_ing: #Ingress & {#config:    config}

	objects: {
		cm:  _cm
		svc: _svc
		dep: _dep
		if config.ingress.enabled {
			ing: _ing
		}
	}
}
