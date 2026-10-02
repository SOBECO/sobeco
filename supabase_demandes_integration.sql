-- SOBECO : demandes d’intégration de points de vente
-- À exécuter UNE SEULE FOIS dans Supabase > SQL Editor.

CREATE TABLE IF NOT EXISTS public.point_vente_demandes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type text NOT NULL CHECK (type IN ('pharmacie','supermarche','boutique_cosmetiques','autre')),
  nom text NOT NULL,
  ville text NOT NULL,
  quartier text NOT NULL,
  telephone text,
  demandeur_nom text,
  demandeur_telephone text,
  informations text,
  photo_url text,
  statut text NOT NULL DEFAULT 'nouveau' CHECK (statut IN ('nouveau','en_cours','integre','non_retenu')),
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.point_vente_demandes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can submit integration requests" ON public.point_vente_demandes;
CREATE POLICY "Public can submit integration requests"
ON public.point_vente_demandes
FOR INSERT TO anon, authenticated
WITH CHECK (
  type IN ('pharmacie','supermarche','boutique_cosmetiques','autre')
  AND length(trim(nom)) > 0
  AND length(trim(ville)) > 0
  AND length(trim(quartier)) > 0
);

DROP POLICY IF EXISTS "Admins can read integration requests" ON public.point_vente_demandes;
CREATE POLICY "Admins can read integration requests"
ON public.point_vente_demandes FOR SELECT TO authenticated
USING ((select public.is_admin()));

DROP POLICY IF EXISTS "Admins can update integration requests" ON public.point_vente_demandes;
CREATE POLICY "Admins can update integration requests"
ON public.point_vente_demandes FOR UPDATE TO authenticated
USING ((select public.is_admin()))
WITH CHECK ((select public.is_admin()));

DROP POLICY IF EXISTS "Admins can delete integration requests" ON public.point_vente_demandes;
CREATE POLICY "Admins can delete integration requests"
ON public.point_vente_demandes FOR DELETE TO authenticated
USING ((select public.is_admin()));

-- Espace séparé pour les photos envoyées avec une demande.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'point-vente-demandes',
  'point-vente-demandes',
  true,
  5242880,
  ARRAY['image/jpeg','image/png','image/webp']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 5242880,
  allowed_mime_types = ARRAY['image/jpeg','image/png','image/webp'];

DROP POLICY IF EXISTS "Public can upload integration photos" ON storage.objects;
CREATE POLICY "Public can upload integration photos"
ON storage.objects FOR INSERT TO anon, authenticated
WITH CHECK (bucket_id = 'point-vente-demandes');

DROP POLICY IF EXISTS "Public can read integration photos" ON storage.objects;
CREATE POLICY "Public can read integration photos"
ON storage.objects FOR SELECT TO anon, authenticated
USING (bucket_id = 'point-vente-demandes');
