# SOBECO — site public + administration

Projet prêt pour GitHub + Vercel.

- `index.html` : site public
- `admin.html` : espace d’administration protégé par Supabase Auth/RLS
- `vercel.json` : permet d’ouvrir `/admin`

Le site public conserve une copie de secours des 52 points et charge les points actifs depuis Supabase. Les doublons éventuels de la base sont masqués côté public par combinaison type/nom/quartier/ville/téléphone.

Ne jamais ajouter de clé Supabase `service_role` ou `secret` dans ces fichiers.
