import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock workout plan data
  final List<Map<String, dynamic>> _workoutDays = [
    {
      'day': 'Monday',
      'title': 'Upper Body Strength',
      'exercises': [
        {'name': 'Push-ups', 'sets': 3, 'reps': '12-15', 'rest': '60s'},
        {'name': 'Dumbbell Rows', 'sets': 3, 'reps': '10-12', 'rest': '60s'},
        {'name': 'Shoulder Press', 'sets': 3, 'reps': '10-12', 'rest': '60s'},
        {'name': 'Bicep Curls', 'sets': 3, 'reps': '12-15', 'rest': '45s'},
        {'name': 'Tricep Dips', 'sets': 3, 'reps': '10-12', 'rest': '45s'},
      ],
      'completed': true,
    },
    {
      'day': 'Tuesday',
      'title': 'Lower Body Power',
      'exercises': [
        {'name': 'Squats', 'sets': 4, 'reps': '12-15', 'rest': '90s'},
        {'name': 'Lunges', 'sets': 3, 'reps': '10 each leg', 'rest': '60s'},
        {'name': 'Leg Press', 'sets': 3, 'reps': '12-15', 'rest': '60s'},
        {'name': 'Calf Raises', 'sets': 3, 'reps': '15-20', 'rest': '45s'},
      ],
      'completed': false,
    },
    {
      'day': 'Wednesday',
      'title': 'Cardio & Core',
      'exercises': [
        {'name': 'Running', 'sets': 1, 'reps': '20 min', 'rest': '-'},
        {'name': 'Plank', 'sets': 3, 'reps': '45-60s', 'rest': '30s'},
        {'name': 'Russian Twists', 'sets': 3, 'reps': '20', 'rest': '30s'},
        {'name': 'Mountain Climbers', 'sets': 3, 'reps': '15', 'rest': '30s'},
      ],
      'completed': false,
    },
    {
      'day': 'Thursday',
      'title': 'Rest & Recovery',
      'exercises': [],
      'completed': false,
    },
    {
      'day': 'Friday',
      'title': 'Full Body',
      'exercises': [
        {'name': 'Burpees', 'sets': 3, 'reps': '10-12', 'rest': '60s'},
        {'name': 'Pull-ups', 'sets': 3, 'reps': '8-10', 'rest': '90s'},
        {'name': 'Deadlifts', 'sets': 3, 'reps': '10-12', 'rest': '90s'},
        {'name': 'Kettlebell Swings', 'sets': 3, 'reps': '15', 'rest': '60s'},
      ],
      'completed': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _workoutDays.length, vsync: this);
    _loadWorkoutPlan();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkoutPlan() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plan'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workout history coming soon')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _workoutDays.map((day) {
            final isCompleted = day['completed'] as bool;
            return Tab(
              child: Row(
                children: [
                  if (isCompleted)
                    const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  if (isCompleted) const SizedBox(width: 4),
                  Text(day['day'] as String),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: _workoutDays.map((day) {
                return _buildWorkoutDay(day);
              }).toList(),
            ),
    );
  }

  Widget _buildWorkoutDay(Map<String, dynamic> day) {
    final exercises = day['exercises'] as List<Map<String, dynamic>>;
    final isRestDay = exercises.isEmpty;
    final isCompleted = day['completed'] as bool;

    if (isRestDay) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 80, color: FitolaTheme.primaryColor),
            const SizedBox(height: 16),
            Text(
              day['title'] as String,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a break and let your body recover',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: FitolaTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            color: FitolaTheme.primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day['title'] as String,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.fitness_center, size: 16, color: FitolaTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      '${exercises.length} exercises',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: FitolaTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.timer, size: 16, color: FitolaTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      '45-60 min',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: FitolaTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Exercises List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return _buildExerciseCard(exercise, index + 1);
            },
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: isCompleted ? null : () {
                setState(() {
                  day['completed'] = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${day['day']} workout completed! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  isCompleted ? 'Completed ✓' : 'Mark as Complete',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise, int number) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: FitolaTheme.primaryColor,
          child: Text(
            number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          exercise['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${exercise['sets']} sets × ${exercise['reps']} reps',
          style: const TextStyle(color: FitolaTheme.textSecondary),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoColumn('Sets', exercise['sets'].toString()),
                    _buildInfoColumn('Reps', exercise['reps'] as String),
                    _buildInfoColumn('Rest', exercise['rest'] as String),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: FitolaTheme.primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Maintain proper form. If you feel pain, stop immediately.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: FitolaTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: FitolaTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: FitolaTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
