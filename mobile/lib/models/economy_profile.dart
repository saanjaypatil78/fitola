class EconomyProfile {
  final String userId;
  final bool f2pEnabled;
  final bool p2eEnabled;
  final int fitcoins;
  final int xp;
  final int seasonLevel;
  final bool eligibleToClaim;

  const EconomyProfile({
    required this.userId,
    required this.f2pEnabled,
    required this.p2eEnabled,
    required this.fitcoins,
    required this.xp,
    required this.seasonLevel,
    required this.eligibleToClaim,
  });

  factory EconomyProfile.fromJson(Map<String, dynamic> json) {
    final model = (json['model'] as Map<String, dynamic>?) ?? {};
    final wallet = (json['wallet'] as Map<String, dynamic>?) ?? {};

    return EconomyProfile(
      userId: json['user_id'] as String? ?? '',
      f2pEnabled: (model['f2p'] as Map<String, dynamic>?)?['enabled'] == true,
      p2eEnabled: (model['p2e'] as Map<String, dynamic>?)?['enabled'] == true,
      fitcoins: (wallet['fitcoins'] as num?)?.toInt() ?? 0,
      xp: (wallet['xp'] as num?)?.toInt() ?? 0,
      seasonLevel: (wallet['season_level'] as num?)?.toInt() ?? 0,
      eligibleToClaim: wallet['eligible_to_claim'] == true,
    );
  }
}
