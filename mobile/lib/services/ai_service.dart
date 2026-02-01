import 'package:fitola/models/fitness_plan.dart';
import 'package:fitola/models/nutrition_plan.dart';
import 'package:fitola/services/api_client.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();
  
  final _apiClient = ApiClient();
  
  Future<String> chatWithAI(String message, {String? context}) async {
    try {
      final response = await _apiClient.post('/chat', {
        'message': message,
        'context': context,
      });
      
      return response['response'] as String;
    } catch (e) {
      throw AIException('AI chat failed: $e');
    }
  }
  
  Future<FitnessPlan> generateFitnessPlan({
    required String userId,
    required String ageGroup,
    required double weight,
    required double height,
    required String bodyType,
    required List<String> goals,
    int durationDays = 30,
  }) async {
    try {
      final response = await _apiClient.post('/plans/ai/fitness', {
        'user_id': userId,
        'age_group': ageGroup,
        'weight': weight,
        'height': height,
        'body_type': bodyType,
        'goals': goals,
        'duration_days': durationDays,
      });
      
      return FitnessPlan.fromJson(response);
    } catch (e) {
      throw AIException('Failed to generate fitness plan: $e');
    }
  }
  
  Future<NutritionPlan> generateNutritionPlan({
    required String userId,
    required String ageGroup,
    required double weight,
    required double height,
    required String bodyType,
    required List<String> goals,
    required String city,
    List<String>? allergies,
    int durationDays = 7,
  }) async {
    try {
      final response = await _apiClient.post('/plans/ai/nutrition', {
        'user_id': userId,
        'age_group': ageGroup,
        'weight': weight,
        'height': height,
        'body_type': bodyType,
        'goals': goals,
        'city': city,
        'allergies': allergies,
        'duration_days': durationDays,
      });
      
      return NutritionPlan.fromJson(response);
    } catch (e) {
      throw AIException('Failed to generate nutrition plan: $e');
    }
  }
  
  Future<Map<String, dynamic>> calculateBMI({
    required double weight,
    required double height,
  }) async {
    try {
      final response = await _apiClient.post('/user/bmi', {
        'weight': weight,
        'height': height,
      });
      
      return {
        'bmi': response['bmi'] as double,
        'category': response['category'] as String,
        'healthy_range': response['healthy_range'] as Map<String, dynamic>,
      };
    } catch (e) {
      throw AIException('BMI calculation failed: $e');
    }
  }
  
  Future<Map<String, dynamic>> analyzeBodyPhoto(String photoPath) async {
    try {
      // In a real implementation, this would upload the photo
      final response = await _apiClient.post('/plans/ai/analyze-photo', {
        'photo_path': photoPath,
      });
      
      return {
        'body_fat_percentage': response['body_fat_percentage'] as double?,
        'muscle_mass': response['muscle_mass'] as double?,
        'recommendations': response['recommendations'] as List<String>?,
      };
    } catch (e) {
      throw AIException('Photo analysis failed: $e');
    }
  }
  
  Future<List<String>> getWorkoutRecommendations({
    required String bodyType,
    required List<String> goals,
    required String fitnessLevel,
  }) async {
    try {
      final response = await _apiClient.post('/plans/ai/workout-recommendations', {
        'body_type': bodyType,
        'goals': goals,
        'fitness_level': fitnessLevel,
      });
      
      return List<String>.from(response['recommendations']);
    } catch (e) {
      throw AIException('Failed to get workout recommendations: $e');
    }
  }
  
  Future<List<String>> getRecipeSuggestions({
    required String ageGroup,
    required String city,
    List<String>? allergies,
    List<String>? dietaryPreferences,
  }) async {
    try {
      final response = await _apiClient.post('/plans/ai/recipe-suggestions', {
        'age_group': ageGroup,
        'city': city,
        'allergies': allergies,
        'dietary_preferences': dietaryPreferences,
      });
      
      return List<String>.from(response['recipes']);
    } catch (e) {
      throw AIException('Failed to get recipe suggestions: $e');
    }
  }
}

class AIException implements Exception {
  final String message;
  AIException(this.message);
  
  @override
  String toString() => message;
}
