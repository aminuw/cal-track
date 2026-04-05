-- ==========================================
-- SCRIPT DE MIGRATION SUPABASE : CAL-TRACK
-- ==========================================
-- Instructions : Copie/Colle ce contenu dans le "SQL Editor" de Supabase et exécute-le.

-- 1. Active l'extension pour générer les ID des tables
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Création de la table 'meals'
CREATE TABLE public.meals (
    -- ID unique du repas
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    
    -- Le propriétaire du repas (lié upabase Auth)
    -- Le DEFAULT auth.uid() permet de l'assigner automatiquement sans l'envoyer dans Flutter !
    user_id UUID NOT NULL REFERENCES auth.users(id) DEFAULT auth.uid(),
    
    -- Les champs de l'IA
    food_item TEXT NOT NULL,
    calories INT2 NOT NULL,
    protein INT2 NOT NULL,
    carbs INT2 NOT NULL,
    fat INT2 NOT NULL,
    analysis_logic TEXT,
    
    -- Horodatage
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Activation de la sécurité RLS (Row Level Security - LE PLUS IMPORTANT !)
-- Si on ne l'active pas, n'importe qui peut lire les données de tout le monde.
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;

-- 4. Stratégie n°1 : Le droit d'ajouter un repas
-- Un utilisateur connecté a le droit d'ajouter un repas si et seulement si l'ID lui correspond.
CREATE POLICY "Users can insert their own meals" 
ON public.meals FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

-- 5. Stratégie n°2 : Le droit de lire ses repas
-- Un utilisateur connecté ne peut récupérer QUE les repas qui lui appartiennent.
CREATE POLICY "Users can view their own meals" 
ON public.meals FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

-- ==========================================
-- (Optionnel) Table profiles : Si tu as besoin plus tard du pseudo, objectif calorique de base...
-- ==========================================
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  username TEXT,
  target_calories INT2 DEFAULT 2500,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by owner." ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile." ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile." ON public.profiles
  FOR UPDATE USING (auth.uid() = id);
