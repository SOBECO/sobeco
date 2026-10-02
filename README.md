SOBECO — version gestion complète du contenu

Cette version conserve les fonctions précédentes et ajoute :
- Gestion des textes publics depuis l'administration
- Gestion des principaux textes de l'administration
- Thèmes et couleurs (normal, Noël, Nouvel An, Saint-Valentin, Pâques, Fête nationale du Bénin, personnalisé)
- Correction responsive du slogan pour éviter les coupures sur téléphone
- Carousel existant avec images affichées entièrement (object-fit: contain)

Avant déploiement : remplacer les fichiers actuels par index.html, admin.html et vercel.json.

## V4 — envoi fiable des demandes d'intégration
Exécuter `supabase_demandes_integration_v4.sql` dans Supabase. Le formulaire enregistre désormais la demande en premier via RPC; l'upload photo est ensuite optionnel, donc une photo qui échoue ne bloque plus l'envoi.
