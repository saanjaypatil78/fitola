import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    // Simulate data loading
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: FitolaTheme.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.name ?? 'User',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Stats Cards
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.3,
                        children: [
                          _buildStatCard(
                            context,
                            'Workouts',
                            '24',
                            Icons.fitness_center,
                            Colors.blue,
                            '+3 this week',
                          ),
                          _buildStatCard(
                            context,
                            'Calories',
                            '2,450',
                            Icons.local_fire_department,
                            Colors.orange,
                            'Today',
                          ),
                          _buildStatCard(
                            context,
                            'Streak',
                            '7 days',
                            Icons.whatshot,
                            Colors.red,
                            'Keep it up!',
                          ),
                          _buildStatCard(
                            context,
                            'FitBuddies',
                            '12',
                            Icons.group,
                            Colors.green,
                            '2 nearby',
                          ),
                        ],
                      ),
                    ),
                    
                    // Quick Actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickAction(
                                  context,
                                  'Start Workout',
                                  Icons.play_circle_filled,
                                  FitolaTheme.primaryColor,
                                  () => Navigator.pushNamed(context, AppRoutes.workoutPlan),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildQuickAction(
                                  context,
                                  'AI Trainer',
                                  Icons.smart_toy,
                                  Colors.purple,
                                  () => Navigator.pushNamed(context, AppRoutes.aiTrainer),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickAction(
                                  context,
                                  'Find FitBuddies',
                                  Icons.map,
                                  Colors.green,
                                  () => Navigator.pushNamed(context, AppRoutes.fitbuddyMap),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildQuickAction(
                                  context,
                                  'Nutrition',
                                  Icons.restaurant,
                                  Colors.orange,
                                  () => Navigator.pushNamed(context, AppRoutes.nutritionPlan),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Recent Activity
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Activity',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildActivityItem(
                            context,
                            'Completed Upper Body Workout',
                            '2 hours ago',
                            Icons.fitness_center,
                            Colors.blue,
                          ),
                          _buildActivityItem(
                            context,
                            'Logged breakfast - 450 calories',
                            '5 hours ago',
                            Icons.restaurant,
                            Colors.orange,
                          ),
                          _buildActivityItem(
                            context,
                            'Connected with 2 new FitBuddies',
                            'Yesterday',
                            Icons.group_add,
                            Colors.green,
                          ),
                          _buildActivityItem(
                            context,
                            'Achieved 7-day streak!',
                            'Yesterday',
                            Icons.emoji_events,
                            Colors.amber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FitolaTheme.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title),
        subtitle: Text(time),
      ),
    );
  }
}
