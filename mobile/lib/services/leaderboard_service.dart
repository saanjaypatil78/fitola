import 'package:fitola/services/api_client.dart';

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

class LeaderboardEntry {
  final int rank;
  final String userId;
  final String name;
  final String? country;
  final int points;
  final String? avatarUrl;
  
  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.name,
    this.country,
    required this.points,
    this.avatarUrl,
  });
  
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      country: json['country'] as String?,
      points: json['points'] as int,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'user_id': userId,
      'name': name,
      'country': country,
      'points': points,
      'avatar_url': avatarUrl,
    };
  }
}

class LeaderboardException implements Exception {
  final String message;
  LeaderboardException(this.message);
  
  @override
  String toString() => message;
}
