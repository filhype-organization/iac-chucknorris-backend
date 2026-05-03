// bundle.cue — Timoni Bundle pour le déploiement GitOps chuck-norris.
//
// Ce fichier est la source de vérité pour les déploiements en production.
// Les jobs CI update-iac mettent à jour les tags image automatiquement.
// Le CronJob timoni-runner (namespace timoni-system) applique ce bundle toutes les 2 minutes.
bundle: {
	apiVersion: "v1alpha1"
	name:       "chuck-norris-backend"
	instances: {
		"chuck-norris-backend": {
			module: {
				url:     "oci://registry-1.docker.io/leeson77/chuck-norris-backend-timoni"
				version: "latest"
			}
			namespace: "chuck-norris"
			values: {
				image: {
					// CI:backend updates this line automatically — do not edit manually.
					tag: "latest"
				}
				sealedSecrets: {
					auth0: {
						encryptedClientSecret: "AgCYGDrMTV5I5ohLLwrYNbzn4pGP4V/cQ7eO5HznnR9YaAq1bcqWVMQQAdP2mGGZId3ZiLqkvvqQzEQQWTfEmrl+4Rbq0f7PPZB+4FNQZagyLn2zef/NNml9XVntZAHGiyp2Df/LAAH1UeLtMGtFbU9bI9W7Lp6SEo7u+z/VF6kYX6qTDVtg1iaAs5fh5RyENNC/y2oO3hFtsdSB+/jyKF6TfijQvY9xa45CafKTD3mKnFRdNcceDP+i8tIKI8VzjSRz9I7mWl+zVvqVgtsU9esQtlYAURovMpjYDIXFGXDJf7nMYB97L18vrj8r3GI8cFlJqDzx1VeM+m5q1PGEeSRtMs++2JHRLk5AZEquer7vbwrip/GhQOml3fJPMYnLUHnRMI3ethBH7DZMhJVXPxabbW27mPn9u2CvYOoXKtzGZ0skbfWsSHtYDuCB4EMJM/mgfBF26qKm3FliQBuFpJ/o3uORBzwR8g5Mdmj47WQcYqs1q2dC/aRHE+aDQHU88RLWwgsEniTenXvg0LBUWPGXf716U+Ccu3euyFYLOXmqnZ+qT7ed/dUw4IwlIyH42P8xb29Ef/GN95iQ74KY33eR9y4S3Oj1jm+E/XFZQvZrXBUfkIDudIB6z1ZG9U3KyvXc+YP/n3evBX6RK7ZyXUdgHKo/r+QfmGP2Sp6b58dTW3/EZTurflAAJPDNZJXcy0AqLcIfcs6fj/vwVMKrB5Vy1vkSSJ78Iz7NeJr2iBRqz97lgsuPQSRFraTimIkxRdj1rqHPcyAirMr7i7q+T2uq"
					}
					database: {
						encryptedUsername: "AgBHM0zr5EHN1ksv9mepHiXIrMXG/bVd5qJZP6XkvIH5hpuXn78qdSQaM7QfcVciwBbBylhk/AcZri4CrbtJrIGbLQhpYsPAIH1bWSWMKq+CJ9pv0Or4X2qVpX9iWQ8m3Fep6tRlmLoEY0lPmR90jbNNd7C7uf6/HqJboBaJi8ZcuuF8a8HX19glk1RDOha+h/n4iPLkQBZd5mnv/wm3/bvtXoBHlpzxSzwmPkLtvUBwz3TrYzxI8Z5bI4JawamrtxTsG4uXnIfWbY5ioxitxXQ1rO6oSeZ0w0DLim4Gp6LPcJsM4vHvFMDHQJaq6WHd8U9jGl6vBnMOUlsbkCJtqB49tBxUJZlYE+vRxk+vDhZ17EErJfCMFsw5pKLZaE57GwlVyD2SsJ8qO3uEGZyzl/xZrDPqMBBMYeZAnWH/ZbQypRrFxIn6e1TrKuhAZ1uqSC89NBQ/duz93htSwM3HRkxldFIb0iDzd7PWAii58IzMhIwMasc5yzd/6GMQlurkwPdPap7qJFtePuIHRbAnjLTGe2FhMbeiKPZ4kUVIwm0acNr20dM4Wii2i9mj7KBwFlHQEESOWazjPLyh6FfVXuNZ+vfiEgWkDHCVZw/9Pu9Z3CyCVYtiWeBONadOZA0VDOTVyT63xB9AuQ3a+iIxSLRE4hxHXabEMv/Pl3bDcCDcNmiduwrkV8vlSxoZWev3aVxn/y0="
						encryptedPassword: "AgA4uYZ34azrdo0g/yU+qbfOFxdF3fjgkfZ8uYRPFB82prxRrIL5MOp+m9As9zaBLiKqlfrfr3uEmsUNc7AnaWaTe1V7oFvK/wtC9ouc8OlmLwxrW/00ZaxrXpO7Yg95sW9KsWni9fFQTAHLLkIl2Roz5G1ivf29I/X2pbxVy8Z0+rsSyLJpEa5BWalNVXUaTws02ErlNSylS3SL2h7sYPPKNeZYJBQ+iatUGMYcrC/dhccZKY6VlJmirk2hJJyXJfInC9ofVkj7x+HqP+TXjgJbJ0J984WY2vrDjc0qeFW7NZlEpuDaqc7M4VQybUglLpKrZRAJjhzs8S5RdechSw6s14OsjWCkwiBYxScFFry7as58dDFedAP/9EY8QJihHQr1DUkdcBOzr/1sWSpsjpUi3BYCrIE4CvO1tgtw51QA9Rgp7Qx7MMl5jVThAu3ff+G+N0U5Y1QChbBJh9MwUwE4mqwn1QSBbcDkshRnen2G5X0etHy/Hb6gPUBJspiMC6H3kqsCdrxjR0mnXnf0sBbUxyM1WOyDfwQcJ+zP+VlayI4huRZzLWYqvB9UQTlJb926MdzXegSVneKmIi0FAH5dgaXRGav5LtuVgCyGZia40DhFIsTjlCSBF87umu17Eg8yPY+1dH79sgfO8izcrwEN4DDF4AznFC9V+cYp0OSQx4JpyW0bwy4nm7SgbTLVc+LavhHVABzPD9tk+xu9/hiF/aKsiLCMZrUN/fztdo4NOKP+4TEtrLEMCKvqhn7NkuSr5ppLsjXp8H5CLBzxRU8w"
					}
				}
			}
		}
		"chuck-norris-frontend": {
			module: {
				url:     "oci://registry-1.docker.io/leeson77/chuck-norris-frontend-timoni"
				version: "latest"
			}
			namespace: "chuck-norris"
			values: {
				image: {
					tag: "6a7e54e" // CI:frontend updates this line automatically — do not edit manually.
				}
				app: {
					apiUrl:   "https://chuck.filhype.ovh"
					authUrl:  "https://dev-lesson.eu.auth0.com"
					clientId: "4LbdqWChDwptSbOBz4ljZ8Le7sYDLZPr"
				}
			}
		}
	}
}
