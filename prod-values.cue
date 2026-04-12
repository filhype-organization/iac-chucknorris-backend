// prod-values.cue — Valeurs de production pour le module chuck-norris-backend.
//
// Ce fichier ne contient plus de secrets — le clientSecret Auth0 est dans
// auth0-sealed-secret.yaml (SealedSecret committé en clair, chiffré par le cluster).
//
// Utilisation manuelle :
//   timoni apply chuck-norris-backend ./infra/k8s/backend \
//     -n chuck-norris \
//     -f ./infra/k8s/backend/prod-values.cue
package main

values: {
	image: {
		// Mettre à jour le tag à chaque release CI/CD.
		// Format CI : leeson77/chuck-norris-backend:<sha>-snapshot-<arch>
		tag: "latest"
	}

	replicas: 1

	// En production, "validate" vérifie le schéma sans le modifier.
	// Passer à "none" si Flyway/Liquibase gère les migrations.
	hibernate: databaseGeneration: "validate"
}
