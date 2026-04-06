import 'package:flutter/foundation.dart';

class ProfileModel {
  final double weight;
  final double height;
  final int age;
  final String gender;
  final double activityLevel;
  final int targetCalories;

  ProfileModel({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.targetCalories,
  });

  // Calcul basé sur l'équation Mifflin-St Jeor (Standard Fitness)
  factory ProfileModel.calculateGoals({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required double activityLevel,
  }) {
    double bmr;
    if (gender == 'M') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    
    // Total Daily Energy Expenditure
    final double tdee = bmr * activityLevel;
    
    // Par défaut, cible calorique pour un maintien (ajustable pour sèche/prise de masse)
    int target = tdee.round();

    return ProfileModel(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      targetCalories: target,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'activity_level': activityLevel,
      'target_calories': targetCalories,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      weight: (json['weight'] as num?)?.toDouble() ?? 70.0,
      height: (json['height'] as num?)?.toDouble() ?? 175.0,
      age: (json['age'] as num?)?.toInt() ?? 25,
      gender: json['gender'] as String? ?? 'M',
      activityLevel: (json['activity_level'] as num?)?.toDouble() ?? 1.2,
      targetCalories: (json['target_calories'] as num?)?.toInt() ?? 2500,
    );
  }
}
