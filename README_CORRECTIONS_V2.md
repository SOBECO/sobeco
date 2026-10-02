# SOBECO — Corrections demandes d’intégration + tableau de bord

Cette version corrige deux points signalés :

1. **Demande d’intégration — type « Autre »**
   - Le formulaire conserve les 4 types : Pharmacie, Supermarché, Boutique de cosmétiques, Autre.
   - Le script SQL inclus normalise la contrainte de la table `point_vente_demandes` afin que `autre` soit bien accepté même si la table avait été créée auparavant avec une ancienne contrainte.
   - La demande est enregistrée dans `point_vente_demandes` et apparaît ensuite dans **Demandes d’intégration** côté administration.

2. **Tableau de bord / menu privé**
   - Les intitulés du menu utilisent désormais la même structure et la même police.
   - Correction du problème CSS qui forçait certains textes dans une largeur de 24 px, ce qui provoquait « Tableau / de / bord » et des intitulés coupés.
   - Les libellés sont maintenant alignés, lisibles et adaptables.
   - Le menu latéral peut défiler si nécessaire afin qu’aucune rubrique ne soit inaccessible.
   - La typographie du tableau de bord est uniformisée.

## Images existantes

Aucune image existante du site n’a été remplacée, supprimée ou modifiée dans cette version.

## À faire avant / après déploiement

1. Dans Supabase > SQL Editor, exécuter le fichier `supabase_demandes_integration.sql` de cette version.
2. Déployer `index.html` et `admin.html` avec les autres fichiers du ZIP sur Vercel.
