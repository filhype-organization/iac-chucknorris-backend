package templates

#Instance: {
	config: #Config

	_ns:  #Namespace & {#config:             config}
	_ss1: #Auth0SealedSecret & {#config:     config}
	_ss2: #DatabaseSealedSecret & {#config:  config}
	_cm:  #Configmap & {#config:             config}
	_svc: #Service & {#config:               config}
	_mw:  #Middleware & {#config:            config}
	_dep: #Deployment & {#config:            config}
	_ing: #Ingress & {#config:               config}

	objects: {
		ns:  _ns
		ss1: _ss1
		ss2: _ss2
		cm:  _cm
		svc: _svc
		mw:  _mw
		dep: _dep
		if config.ingress.enabled {
			ing: _ing
		}
	}
}
