import 'dart:io';
import '../entities/meal.dart';

abstract class TrackingRepository {
  Future<Meal> analyzeAndSaveMeal(File imageFile);
}
