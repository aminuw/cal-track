import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../domain/entities/meal.dart';
import '../sources/groq_vision_remote_source.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final GroqVisionRemoteSource _remoteSource;
  final SupabaseClient _supabaseClient;

  TrackingRepositoryImpl({
    required GroqVisionRemoteSource remoteSource,
    required SupabaseClient supabaseClient,
  }) : _remoteSource = remoteSource,
       _supabaseClient = supabaseClient;

  @override
  Future<Meal> analyzeAndSaveMeal(File imageFile) async {
    // 1. Analyse IA via Groq
    final analysisResult = await _remoteSource.analyzeMeal(imageFile);

    // 2. Préparation du payload Supabase
    final Map<String, dynamic> mealData = {
      'food_item': analysisResult.foodItem,
      'calories': analysisResult.calories,
      'protein': analysisResult.protein,
      'carbs': analysisResult.carbs,
      'fat': analysisResult.fat,
      'created_at': DateTime.now().toIso8601String(),
    };

    // 3. Sauvegarde dans Supabase
    final response = await _supabaseClient.from('meals').insert(mealData).select().single();
    final String insertedId = response['id'].toString();

    // 4. Renvoi du Domain Model
    return Meal(
      id: insertedId,
      foodItem: analysisResult.foodItem,
      calories: analysisResult.calories,
      protein: analysisResult.protein,
      carbs: analysisResult.carbs,
      fat: analysisResult.fat,
      createdAt: DateTime.now(),
    );
  }
}
