import 'package:flutter/material.dart';

/// Metadata generated from a VIP level.
class VipBenefits {
  static const int minLevel = 1;
  static const int maxLevel = 999;
  static const int maxDiamondTier = 5;
  static const int levelsPerTier = 200;

  static const List<String> smartFeatureTrack = [
    'Priority coach responses',
    'Advanced workout analytics',
    'Custom nutrition templates',
    'Elite leaderboard visibility',
    'Recovery score insights',
    'AI form correction tips',
    'Premium community challenges',
    'Extended chat translation pack',
  ];

  final int level;
  final int unlockedFeatures;
  final int diamondTier;
  final String latestFeature;
  final int nextLevel;

  const VipBenefits({
    required this.level,
    required this.unlockedFeatures,
    required this.diamondTier,
    required this.latestFeature,
    required this.nextLevel,
  });

  factory VipBenefits.fromLevel(int vipLevel, {int baseFeatures = 3}) {
    final normalizedLevel = vipLevel.clamp(minLevel, maxLevel);
    final tier = ((normalizedLevel - 1) ~/ levelsPerTier) + 1;
    final featureIndex = (normalizedLevel - 1) % smartFeatureTrack.length;

    return VipBenefits(
      level: normalizedLevel,
      unlockedFeatures: baseFeatures + normalizedLevel,
      diamondTier: tier.clamp(minLevel, maxDiamondTier),
      latestFeature: smartFeatureTrack[featureIndex],
      nextLevel: normalizedLevel == maxLevel ? maxLevel : normalizedLevel + 1,
    );
  }

  bool get isMaxLevel => level >= maxLevel;

  int get levelsToNextDiamondTier {
    final tierCap = diamondTier * levelsPerTier;
    if (isMaxLevel || level >= tierCap) {
      return 0;
    }
    return tierCap - level;
  }
}

/// Premium badge that supports levels from VIP 1 to VIP 999.
///
/// Every level unlocks one additional feature and highlights the newest
/// reward in a smart rotating feature track.
class VipDiamondBadge extends StatelessWidget {
  final int vipLevel;
  final int baseFeatures;
  final bool showFeatureText;
  final bool showNextLevelHint;

  const VipDiamondBadge({
    super.key,
    required this.vipLevel,
    this.baseFeatures = 3,
    this.showFeatureText = true,
    this.showNextLevelHint = true,
  });

  VipBenefits get benefits =>
      VipBenefits.fromLevel(vipLevel, baseFeatures: baseFeatures);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF3023AE), Color(0xFFC86DD7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                benefits.diamondTier,
                (_) => const Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: Icon(Icons.diamond, size: 14, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'VIP ${benefits.level}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          if (showFeatureText) ...[
            const SizedBox(height: 4),
            Text(
              '${benefits.unlockedFeatures} features unlocked',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'New: ${benefits.latestFeature}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
          if (showNextLevelHint && !benefits.isMaxLevel) ...[
            const SizedBox(height: 4),
            Text(
              'Next unlock at VIP ${benefits.nextLevel}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
