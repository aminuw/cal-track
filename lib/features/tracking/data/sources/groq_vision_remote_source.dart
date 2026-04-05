import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/groq_analysis_result_model.dart';

abstract class GroqVisionRemoteSource {
  Future<GroqAnalysisResultModel> analyzeMeal(File imageFile);
}

class GroqVisionRemoteSourceImpl implements GroqVisionRemoteSource {
  final Dio dio;
  final String apiKey;
  
  // Endpoint Groq API compatible OpenAI
  static const String endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  GroqVisionRemoteSourceImpl({required this.dio, required this.apiKey}) {
    dio.options.headers['Authorization'] = 'Bearer $apiKey';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  @override
  Future<GroqAnalysisResultModel> analyzeMeal(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final dataUrl = 'data:image/jpeg;base64,$base64Image';

      // Payload JSON spécialisé Groq
      final payload = {
        "model": "llama-3.2-11b-vision-preview",
        "response_format": { "type": "json_object" }, 
        "messages": [
          {
            "role": "system",
            "content": '''
Tu es un nutritionniste expert en musculation. Analyse l'image fournie par l'utilisateur et renvoie UNIQUEMENT un objet JSON valide avec cette structure exacte :
{
  "food_item": "Nom du plat",
  "weight_est": "Poids estimé en grammes (ex: 250g)",
  "calories": 0,
  "protein": 0,
  "carbs": 0,
  "fat": 0,
  "analysis_logic": "Brève explication du calcul calorique"
}
'''
          },
          {
            "role": "user",
            "content": [
               {
                 "type": "image_url",
                 "image_url": { "url": dataUrl }
               }
            ]
          }
        ]
      };

      final response = await dio.post(endpoint, data: payload);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final String contentString = responseData['choices'][0]['message']['content'];
        
        final Map<String, dynamic> jsonResult = jsonDecode(contentString);
        return GroqAnalysisResultModel.fromJson(jsonResult);
      } else {
        throw Exception('Erreur API Groq: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Erreur réseau / DioException avec GroqVision: ${e.message}');
    } catch (e) {
      throw Exception('Erreur de parsing ou processus inconnu: $e');
    }
  }
}
