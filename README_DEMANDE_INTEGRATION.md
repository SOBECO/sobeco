# SOBECO — Demandes d’intégration v1

Cette version part directement de **sobeco_suggestions_reclamations_v2**. Elle ajoute uniquement la fonction de demande d’intégration d’un point de vente.

## Nouvelles catégories
- 💊 Pharmacie
- 🛒 Supermarché
- 💄 Boutique de cosmétiques
- ⋯ Autre (grossiste, parfumerie, institut de beauté, etc.)

## Ce qui est conservé
- Les images existantes du site ne sont ni remplacées ni modifiées.
- Le carousel existant reste intact.
- Les suggestions et réclamations restent fonctionnelles.
- Les points de vente existants et leur gestion restent intacts.
- L’apparence générale du site reste celle de la version précédente.

## À faire avant le déploiement
1. Dans Supabase > SQL Editor, exécuter une seule fois `supabase_demandes_integration.sql`.
2. Ensuite, envoyer le contenu du dossier `sobeco_v3` sur Vercel comme d’habitude.

La demande d’intégration est enregistrée dans une table séparée `point_vente_demandes`, afin de ne pas mélanger ces demandes avec les suggestions/réclamations.

Dans l’espace privé, une nouvelle rubrique **📍 Demandes d’intégration** permet de consulter les demandes et de faire évoluer leur statut : Nouveau → En cours de vérification → Intégré / Non retenu.
