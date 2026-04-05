import 'package:freezed_annotation/freezed_annotation.dart';

part 'groq_analysis_result_model.g.dart';

@JsonSerializable()
class GroqAnalysisResultModel {
  @JsonKey(name: 'food_item')
  final String foodItem;
  
  @JsonKey(name: 'weight_est')
  final String weightEst;
  
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  
  @JsonKey(name: 'analysis_logic')
  final String analysisLogic;

  GroqAnalysisResultModel({
    required this.foodItem,
    required this.weightEst,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.analysisLogic,
  });

  factory GroqAnalysisResultModel.fromJson(Map<String, dynamic> json) => _$GroqAnalysisResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroqAnalysisResultModelToJson(this);
}
