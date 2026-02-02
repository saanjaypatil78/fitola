import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _globalLeaderboard = [
    {'rank': 1, 'name': 'Alex Martinez', 'country': 'USA', 'points': 15420, 'streak': 45, 'change': 2},
    {'rank': 2, 'name': 'Yuki Tanaka', 'country': 'Japan', 'points': 14890, 'streak': 38, 'change': -1},
    {'rank': 3, 'name': 'Emma Wilson', 'country': 'UK', 'points': 14210, 'streak': 42, 'change': 1},
    {'rank': 4, 'name': 'Marco Silva', 'country': 'Brazil', 'points': 13950, 'streak': 35, 'change': 0},
    {'rank': 5, 'name': 'Sophie Dubois', 'country': 'France', 'points': 13680, 'streak': 40, 'change': 3},
    {'rank': 42, 'name': 'You', 'country': 'USA', 'points': 8420, 'streak': 12, 'change': 5, 'isMe': true},
  ];

  final List<Map<String, dynamic>> _nationalLeaderboard = [
    {'rank': 1, 'name': 'Jennifer Davis', 'city': 'New York', 'points': 12340, 'streak': 35},
    {'rank': 2, 'name': 'Michael Brown', 'city': 'Los Angeles', 'points': 11890, 'streak': 30},
    {'rank': 3, 'name': 'Sarah Johnson', 'city': 'Chicago', 'points': 11210, 'streak': 28},
    {'rank': 8, 'name': 'You', 'city': 'San Francisco', 'points': 8420, 'streak': 12, 'isMe': true},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Achievements coming soon')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'National'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardView(_globalLeaderboard, isGlobal: true),
          _buildLeaderboardView(_nationalLeaderboard, isGlobal: false),
        ],
      ),
    );
  }

  Widget _buildLeaderboardView(List<Map<String, dynamic>> leaderboard, {required bool isGlobal}) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadLeaderboard,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: leaderboard.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }

          final user = leaderboard[index - 1];
          final rank = user['rank'] as int;
          final isMe = user['isMe'] == true;

          if (rank <= 3 && index <= 3) {
            return _buildTopThreeCard(user, rank, isGlobal: isGlobal);
          }

          return _buildLeaderboardCard(user, isGlobal: isGlobal);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FitolaTheme.primaryColor,
            FitolaTheme.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
          const SizedBox(height: 12),
          Text(
            'Compete & Win',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete workouts and challenges to earn points and climb the ranks!',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreeCard(Map<String, dynamic> user, int rank, {required bool isGlobal}) {
    final colors = [Colors.amber, Colors.grey[400]!, Colors.orange[700]!];
    final icons = [Icons.looks_one, Icons.looks_two, Icons.looks_3];
    final isMe = user['isMe'] == true;

    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 16),
      color: isMe ? FitolaTheme.primaryColor.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isMe
            ? const BorderSide(color: FitolaTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors[rank - 1].withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icons[rank - 1],
                size: 40,
                color: colors[rank - 1],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isMe ? FitolaTheme.primaryColor : null,
                          ),
                        ),
                      ),
                      if (isMe)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: FitolaTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'YOU',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isGlobal ? Icons.public : Icons.location_city,
                        size: 14,
                        color: FitolaTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isGlobal ? user['country'] as String : user['city'] as String,
                        style: const TextStyle(
                          color: FitolaTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatBadge('${user['points']} pts', Icons.star, Colors.amber),
                      const SizedBox(width: 8),
                      _buildStatBadge('${user['streak']} days', Icons.whatshot, Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard(Map<String, dynamic> user, {required bool isGlobal}) {
    final isMe = user['isMe'] == true;
    final rank = user['rank'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isMe ? FitolaTheme.primaryColor.withOpacity(0.1) : null,
      shape: isMe
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: FitolaTheme.primaryColor, width: 2),
            )
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isMe ? FitolaTheme.primaryColor : Colors.grey[300],
          child: Text(
            rank.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isMe ? Colors.white : Colors.black87,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user['name'] as String,
                style: TextStyle(
                  fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                  color: isMe ? FitolaTheme.primaryColor : null,
                ),
              ),
            ),
            if (user['change'] != null)
              _buildRankChange(user['change'] as int),
          ],
        ),
        subtitle: Row(
          children: [
            Icon(
              isGlobal ? Icons.public : Icons.location_city,
              size: 12,
              color: FitolaTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(isGlobal ? user['country'] as String : user['city'] as String),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${user['points']} pts',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.whatshot, size: 14, color: Colors.red),
                const SizedBox(width: 2),
                Text(
                  '${user['streak']}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankChange(int change) {
    if (change == 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: change > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            change > 0 ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: change > 0 ? Colors.green : Colors.red,
          ),
          Text(
            change.abs().toString(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: change > 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
