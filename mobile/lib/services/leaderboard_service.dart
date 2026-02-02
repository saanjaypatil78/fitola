import 'package:fitola/services/api_client.dart';
import 'package:fitola/models/leaderboard_entry.dart';

class LeaderboardService {
  static final LeaderboardService _instance = LeaderboardService._internal();
  factory LeaderboardService() => _instance;
  LeaderboardService._internal();
  
  final _apiClient = ApiClient();
  
  /// Get global leaderboard rankings
  Future<List<LeaderboardEntry>> getGlobalLeaderboard({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.get(
        '/leaderboard/global?limit=$limit&offset=$offset',
      );
      
      final leaderboardData = response['leaderboard'];
      if (leaderboardData == null) {
        return [];
      }
      
      final entries = (leaderboardData as List)
          .map((json) => LeaderboardEntry.fromJson(json))
          .toList();
      
      return entries;
    } catch (e) {
      throw LeaderboardException('Failed to load global leaderboard: $e');
    }
  }
  
  /// Get national leaderboard for specific country
  Future<List<LeaderboardEntry>> getNationalLeaderboard(
    String country, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.get(
        '/leaderboard/national/$country?limit=$limit&offset=$offset',
      );
      
      final leaderboardData = response['leaderboard'];
      if (leaderboardData == null) {
        return [];
      }
      
      final entries = (leaderboardData as List)
          .map((json) => LeaderboardEntry.fromJson(json))
          .toList();
      
      return entries;
    } catch (e) {
      throw LeaderboardException('Failed to load national leaderboard: $e');
    }
  }
  
  /// Get friends leaderboard
  Future<List<LeaderboardEntry>> getFriendsLeaderboard(
    String userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.get(
        '/leaderboard/friends/$userId?limit=$limit&offset=$offset',
      );
      
      final leaderboardData = response['leaderboard'];
      if (leaderboardData == null) {
        return [];
      }
      
      final entries = (leaderboardData as List)
          .map((json) => LeaderboardEntry.fromJson(json))
          .toList();
      
      return entries;
    } catch (e) {
      throw LeaderboardException('Failed to load friends leaderboard: $e');
    }
  }
}

class LeaderboardException implements Exception {
  final String message;
  LeaderboardException(this.message);
  
  @override
  String toString() => message;
}
