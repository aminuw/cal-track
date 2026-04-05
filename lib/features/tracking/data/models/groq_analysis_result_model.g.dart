// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groq_analysis_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroqAnalysisResultModel _$GroqAnalysisResultModelFromJson(
        Map<String, dynamic> json) =>
    GroqAnalysisResultModel(
      foodItem: json['food_item'] as String,
      weightEst: json['weight_est'] as String,
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toInt(),
      carbs: (json['carbs'] as num).toInt(),
      fat: (json['fat'] as num).toInt(),
      analysisLogic: json['analysis_logic'] as String,
    );

Map<String, dynamic> _$GroqAnalysisResultModelToJson(
        GroqAnalysisResultModel instance) =>
    <String, dynamic>{
      'food_item': instance.foodItem,
      'weight_est': instance.weightEst,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'analysis_logic': instance.analysisLogic,
    };
