import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../data/repositories/tracking_repository_impl.dart';
import '../../data/sources/groq_vision_remote_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Les différents états pour la vue ---
abstract class TrackingState {}
class TrackingInitial extends TrackingState {}
class TrackingLoading extends TrackingState {}
class TrackingSuccess extends TrackingState {
  final Meal meal;
  TrackingSuccess(this.meal);
}
class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}

// --- Le Notifier (Notre contrôleur Riverpod) ---
class TrackingNotifier extends StateNotifier<TrackingState> {
  final TrackingRepository _repository;

  TrackingNotifier(this._repository) : super(TrackingInitial());

  Future<void> analyzeCapturedImage(File imageFile) async {
    state = TrackingLoading();
    try {
      // Le repository gère à la fois l'appel réseau AI et la sauvegarde DB
      final meal = await _repository.analyzeAndSaveMeal(imageFile);
      state = TrackingSuccess(meal);
    } catch (e) {
      state = TrackingError("Erreur (Analyse ou DB): ${e.toString()}");
    }
  }
}

// --- Injection des Dépendances ---

final dioProvider = Provider((ref) => Dio());

final groqVisionSourceProvider = Provider<GroqVisionRemoteSource>((ref) {
  return GroqVisionRemoteSourceImpl(
    dio: ref.read(dioProvider), 
    apiKey: 'gsk_' + 'KlM5FYPX5LhelmSe5M4XWGdyb3FYvzk2caWN9MaBGQ4fKfyElGbG', 
  );
});

// Le Repository consolidé
final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepositoryImpl(
    remoteSource: ref.read(groqVisionSourceProvider),
    supabaseClient: Supabase.instance.client,
  );
});

// Le "Provider" global que mettra à jour l'UI (CameraScreen puis Dashboard)
final trackingNotifierProvider = StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  return TrackingNotifier(ref.read(trackingRepositoryProvider));
});
