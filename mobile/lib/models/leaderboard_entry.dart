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
      rank: (json['rank'] as num).toInt(),
      userId: json['user_id'] as String,
      name: json['name'] as String,
      country: json['country'] as String?,
      points: (json['points'] as num).toInt(),
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
