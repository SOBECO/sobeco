-- SOBECO — Envoi fiable des demandes d'intégration
-- Cette version utilise des fonctions RPC sécurisées pour garantir l'enregistrement
-- même si l'upload de photo rencontre un problème.

CREATE OR REPLACE FUNCTION public.submit_point_vente_demande(
  p_type text,
  p_nom text,
  p_ville text,
  p_quartier text,
  p_telephone text DEFAULT NULL,
  p_demandeur_nom text DEFAULT NULL,
  p_demandeur_telephone text DEFAULT NULL,
  p_informations text DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_id uuid;
BEGIN
  IF p_type NOT IN ('pharmacie','supermarche','boutique_cosmetiques','autre') THEN
    RAISE EXCEPTION 'Type de point de vente non autorisé.';
  END IF;

  IF length(trim(coalesce(p_nom,''))) = 0
     OR length(trim(coalesce(p_ville,''))) = 0
     OR length(trim(coalesce(p_quartier,''))) = 0 THEN
    RAISE EXCEPTION 'Le nom, la ville et le quartier sont obligatoires.';
  END IF;

  INSERT INTO public.point_vente_demandes (
    type, nom, ville, quartier, telephone,
    demandeur_nom, demandeur_telephone, informations
  )
  VALUES (
    p_type,
    trim(p_nom),
    trim(p_ville),
    trim(p_quartier),
    NULLIF(trim(coalesce(p_telephone,'')),''),
    NULLIF(trim(coalesce(p_demandeur_nom,'')),''),
    NULLIF(trim(coalesce(p_demandeur_telephone,'')),''),
    NULLIF(trim(coalesce(p_informations,'')),'')
  )
  RETURNING id INTO new_id;

  RETURN new_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.attach_point_vente_demande_photo(
  p_id uuid,
  p_photo_url text
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF p_photo_url IS NULL
     OR p_photo_url NOT LIKE 'https://tivvkxtbswvgqpjwbvns.supabase.co/storage/v1/object/public/point-vente-demandes/%' THEN
    RAISE EXCEPTION 'URL de photo non autorisée.';
  END IF;

  UPDATE public.point_vente_demandes
  SET photo_url = p_photo_url
  WHERE id = p_id;

  RETURN FOUND;
END;
$$;

REVOKE ALL ON FUNCTION public.submit_point_vente_demande(text,text,text,text,text,text,text,text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.submit_point_vente_demande(text,text,text,text,text,text,text,text) TO anon, authenticated;

REVOKE ALL ON FUNCTION public.attach_point_vente_demande_photo(uuid,text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.attach_point_vente_demande_photo(uuid,text) TO anon, authenticated;

-- Les politiques RLS restent actives pour l'accès admin.
ALTER TABLE public.point_vente_demandes ENABLE ROW LEVEL SECURITY;
