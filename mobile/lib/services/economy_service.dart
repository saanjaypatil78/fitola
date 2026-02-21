import 'package:fitola/models/economy_profile.dart';
import 'package:fitola/services/api_client.dart';

class EconomyService {
  final ApiClient _apiClient = ApiClient();

  Future<EconomyProfile> getEconomyProfile(String userId) async {
    try {
      final response = await _apiClient.get('/economy/profile/$userId');
      return EconomyProfile.fromJson(response);
    } catch (e) {
      throw EconomyException('Failed to load economy profile: $e');
    }
  }

  Future<Map<String, dynamic>> completeSession({
    required String userId,
    required int workoutMinutes,
    String intensity = 'moderate',
    bool sharedProgress = false,
  }) async {
    try {
      return await _apiClient.post('/economy/session-complete', {
        'user_id': userId,
        'workout_minutes': workoutMinutes,
        'intensity': intensity,
        'shared_progress': sharedProgress,
      });
    } catch (e) {
      throw EconomyException('Failed to complete economy session: $e');
    }
  }

  Future<Map<String, dynamic>> claimP2ERewards({
    required String userId,
    required int amountFitcoins,
  }) async {
    try {
      return await _apiClient.post('/economy/claim', {
        'user_id': userId,
        'amount_fitcoins': amountFitcoins,
      });
    } catch (e) {
      throw EconomyException('Failed to claim P2E rewards: $e');
    }
  }
}

class EconomyException implements Exception {
  final String message;

  EconomyException(this.message);

  @override
  String toString() => message;
}
