# Contexte du Projet "Cal-Track"

**Destinataire** : Agent IA (Handoff / Reprise de contexte)
**Type d'application** : Application Flutter (Web & Mobile) de tracking nutritionnel (Musculation)
**Architecture** : Clean Architecture
**State Management** : Riverpod
**Backend** : Supabase
**IA Intégrée** : Grok vision-beta (xAI) via API/Edge Function

---

## 🟢 Ce qui a DÉJÀ été codé (Implémenté)

La base structurelle "Boilerplate" et la configuration avancée ont été produites.

1. **Configuration et Thème** :
   - `pubspec.yaml` : Ajout de Riverpod, Dio, Supabase, Freezed, Camera.
   - `lib/main.dart` : ProviderScope et base d'initialisation de Supabase.
   - `lib/core/theme/app_theme.dart` : Design system "Dark Gym" (#121212, couleurs néons pour les macros).

2. **Présentation (UI/UX)** :
   - `lib/features/tracking/presentation/screens/dashboard_screen.dart` : L'écran principal, avec jauges imbriquées et lecture d'état (Riverpod Provider statique).
   - `lib/features/tracking/presentation/widgets/macros_circular_progress.dart` : Un CustomPainter optimisé créant un liseré "Neon" pour la progression (Prots, Glucides, Lipides).
   - `lib/features/tracking/presentation/screens/camera_capture_screen.dart` : Module caméra avec robustesse Web (try/catch d'exemptions d'accès, prompt Permission navigateur).

3. **Logique Métier & Data (Riverpod / API)** :
   - `lib/features/tracking/presentation/providers/tracking_notifier.dart` : Le contrôleur d'états asynchrone liant UI et réseau.
   - `lib/features/tracking/data/sources/grok_vision_remote_source.dart` : Connecteur API utilisant `Dio`, encodage en `Base64`, envoi de requêtes JSON prêtes pour Grok Vision.
   - `lib/features/tracking/data/models/grok_analysis_result_model.dart` : Le DTO avec attributs stricts (food_item, calories, macros) utilisant `json_serializable`.

4. **Backend (Supabase / Web CORS)** :
   - `supabase/functions/grok_proxy/index.ts` : Une Edge Function (Deno TypeScript) agissant comme reverse-proxy. C'est elle qui appelle réellement Grok pour échapper aux restrictions pré-flight CORS des navigateurs lors de la compilation Flutter Web.

---

## 🟢 Ce qui Vient d'être Implémenté (Clean Architecture Completée)

1. **Génération de Code (Build Runner)** :
   - Génération manuelle/automatique de `grok_analysis_result_model.g.dart` effectuée avec succès.

2. **Couche de Domaine (Domain Layer Clean Architecture)** :
   - Entité pure `Meal` (`lib/features/tracking/domain/entities/meal.dart`).
   - Contrat du repository (`lib/features/tracking/domain/repositories/tracking_repository.dart`).

3. **Implémentation Data pour Supabase** :
   - Création de `TrackingRepositoryImpl` (`lib/features/tracking/data/repositories/tracking_repository_impl.dart`). Le repository gère désormais la requête API de la remote source et simule (en isolation) le `supabase.insert` final.

4. **Finition du Câblage global** :
   - `CameraCaptureScreen` est devenu un `ConsumerStatefulWidget` Riverpod.
   - Son bouton Action déclenche `ref.read(trackingNotifierProvider.notifier).analyzeCapturedImage`.
   - `TrackingNotifier` écoute le `TrackingRepository` et propage les étas `TrackingLoading`, `TrackingSuccess(meal)`.
 
---

## 🎯 Prochaines étapes (Backlog Restant)

- Substituer le "Fake Insert" avec les vraies clés Supabase lorsque l'étudiant/jury les fournira (dans `main.dart` et `TrackingRepositoryImpl`).
- Interagir avec `TrackingSuccess` dans l'UI du Dashboard pour dynamiser l'interface avec la vraie donnée.
