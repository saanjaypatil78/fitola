import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock detailed ranking data
    final userData = {
      'name': 'Your Stats',
      'rank': 42,
      'totalRanks': 15420,
      'points': 8420,
      'streak': 12,
      'totalWorkouts': 87,
      'totalCalories': 45230,
      'achievements': 15,
      'weeklyProgress': [85, 92, 78, 95, 88, 90, 100],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Rankings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FitolaTheme.primaryColor,
                    FitolaTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: FitolaTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData['name'] as String,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Rank #${userData['rank']} of ${userData['totalRanks']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Stats Grid
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    context,
                    'Total Points',
                    userData['points'].toString(),
                    Icons.star,
                    Colors.amber,
                  ),
                  _buildStatCard(
                    context,
                    'Current Streak',
                    '${userData['streak']} days',
                    Icons.whatshot,
                    Colors.red,
                  ),
                  _buildStatCard(
                    context,
                    'Total Workouts',
                    userData['totalWorkouts'].toString(),
                    Icons.fitness_center,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    'Calories Burned',
                    '${userData['totalCalories']}',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ],
              ),
            ),
            
            // Weekly Progress
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildDayBar('M', (userData['weeklyProgress'] as List<int>)[0]),
                          _buildDayBar('T', (userData['weeklyProgress'] as List<int>)[1]),
                          _buildDayBar('W', (userData['weeklyProgress'] as List<int>)[2]),
                          _buildDayBar('T', (userData['weeklyProgress'] as List<int>)[3]),
                          _buildDayBar('F', (userData['weeklyProgress'] as List<int>)[4]),
                          _buildDayBar('S', (userData['weeklyProgress'] as List<int>)[5]),
                          _buildDayBar('S', (userData['weeklyProgress'] as List<int>)[6]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Achievements
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Achievements',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: FitolaTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${userData['achievements']}/30',
                              style: const TextStyle(
                                color: FitolaTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildAchievement(
                        'First Workout',
                        'Complete your first workout',
                        Icons.fitness_center,
                        Colors.blue,
                        true,
                      ),
                      _buildAchievement(
                        'Week Warrior',
                        'Complete 7 workouts in a week',
                        Icons.whatshot,
                        Colors.red,
                        true,
                      ),
                      _buildAchievement(
                        'Social Butterfly',
                        'Connect with 10 FitBuddies',
                        Icons.group,
                        Colors.green,
                        false,
                      ),
                      _buildAchievement(
                        'Marathon Master',
                        'Complete 100 workouts',
                        Icons.emoji_events,
                        Colors.amber,
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FitolaTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBar(String day, int percentage) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 100,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 30,
            height: percentage.toDouble(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  FitolaTheme.primaryColor,
                  FitolaTheme.primaryColor.withOpacity(0.6),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: FitolaTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievement(
    String title,
    String description,
    IconData icon,
    Color color,
    bool isUnlocked,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isUnlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isUnlocked ? color : Colors.grey,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? null : Colors.grey,
                        ),
                      ),
                    ),
                    if (isUnlocked)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? FitolaTheme.textSecondary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
