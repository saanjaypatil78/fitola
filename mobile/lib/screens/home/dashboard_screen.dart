import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/providers/auth_provider.dart';
import 'package:fitola/providers/fitness_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser != null) {
      final fitnessProvider = context.read<FitnessProvider>();
      await Future.wait([
        fitnessProvider.loadFitnessPlans(authProvider.currentUser!.id),
        fitnessProvider.loadNutritionPlans(authProvider.currentUser!.id),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitolaTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, FitnessProvider>(
        builder: (context, authProvider, fitnessProvider, child) {
          if (fitnessProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authProvider.currentUser;
          final activePlan = fitnessProvider.activeFitnessPlan;

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Card
                  _buildWelcomeCard(context, user?.name ?? 'User'),
                  const SizedBox(height: 16),
                  
                  // Active Plan Card
                  if (activePlan != null) ...[
                    _buildActivePlanCard(context, activePlan),
                    const SizedBox(height: 16),
                  ],
                  
                  // Stats Grid
                  _buildStatsGrid(context),
                  const SizedBox(height: 16),
                  
                  // Progress Chart
                  _buildProgressChart(context),
                  const SizedBox(height: 16),
                  
                  // Quick Actions
                  _buildQuickActions(context),
                  const SizedBox(height: 16),
                  
                  // Recent Activity
                  _buildRecentActivity(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, String userName) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [FitolaTheme.primaryColor, FitolaTheme.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName! 👋',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Let's crush your fitness goals today!",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanCard(BuildContext context, dynamic plan) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.workoutPlan);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.fitness_center, color: FitolaTheme.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Active Plan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                plan.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                plan.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FitolaTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: plan.progressPercentage / 100,
                backgroundColor: FitolaTheme.primaryColor.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(FitolaTheme.primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Day ${plan.currentDay ?? 0} of ${plan.durationDays}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(context, 'Workouts', '12', Icons.fitness_center, FitolaTheme.primaryColor),
        _buildStatCard(context, 'Calories', '2450', Icons.local_fire_department, FitolaTheme.errorColor),
        _buildStatCard(context, 'Duration', '6.5h', Icons.timer, FitolaTheme.secondaryColor),
        _buildStatCard(context, 'Streak', '7 days', Icons.whatshot, FitolaTheme.warningColor),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 4),
                        const FlSpot(2, 3.5),
                        const FlSpot(3, 5),
                        const FlSpot(4, 4),
                        const FlSpot(5, 6),
                        const FlSpot(6, 5.5),
                      ],
                      isCurved: true,
                      color: FitolaTheme.primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: FitolaTheme.primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Start Workout',
                Icons.play_circle_filled,
                FitolaTheme.primaryColor,
                () => Navigator.pushNamed(context, AppRoutes.workoutPlan),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'AI Trainer',
                Icons.smart_toy,
                FitolaTheme.secondaryColor,
                () => Navigator.pushNamed(context, AppRoutes.aiTrainer),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
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
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activities = [
                {'title': 'Full Body Workout', 'time': '2 hours ago', 'icon': Icons.fitness_center},
                {'title': 'Nutrition Plan Updated', 'time': 'Yesterday', 'icon': Icons.restaurant},
                {'title': 'Weekly Goal Achieved', 'time': '2 days ago', 'icon': Icons.emoji_events},
              ];
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: FitolaTheme.primaryColor.withOpacity(0.2),
                  child: Icon(activity['icon'] as IconData, color: FitolaTheme.primaryColor),
                ),
                title: Text(activity['title'] as String),
                subtitle: Text(activity['time'] as String),
              );
            },
          ),
        ),
      ],
    );
  }
}
