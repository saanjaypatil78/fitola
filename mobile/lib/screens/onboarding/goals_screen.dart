import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/config/theme.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final Set<String> _selectedGoals = {};
  String _selectedDuration = '3 months';
  bool _interestedInCompetition = false;

  final List<Map<String, dynamic>> _goals = [
    {'name': 'Lose Weight', 'icon': Icons.trending_down, 'color': Colors.red},
    {'name': 'Build Muscle', 'icon': Icons.fitness_center, 'color': Colors.blue},
    {'name': 'Improve Endurance', 'icon': Icons.run_circle, 'color': Colors.green},
    {'name': 'Increase Flexibility', 'icon': Icons.self_improvement, 'color': Colors.purple},
    {'name': 'General Fitness', 'icon': Icons.favorite, 'color': Colors.pink},
    {'name': 'Sports Performance', 'icon': Icons.sports_basketball, 'color': Colors.orange},
  ];

  final List<String> _durations = [
    '1 month',
    '3 months',
    '6 months',
    '1 year',
  ];

  void _handleComplete() {
    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one goal')),
      );
      return;
    }
    
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Goals'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'What are your fitness goals?',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select one or more goals',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FitolaTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Goals Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final isSelected = _selectedGoals.contains(goal['name']);
                  
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedGoals.remove(goal['name']);
                        } else {
                          _selectedGoals.add(goal['name'] as String);
                        }
                      });
                    },
                    child: Card(
                      elevation: isSelected ? 8 : 2,
                      color: isSelected 
                          ? (goal['color'] as Color).withOpacity(0.1) 
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected 
                              ? (goal['color'] as Color)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            goal['icon'] as IconData,
                            size: 48,
                            color: isSelected 
                                ? (goal['color'] as Color)
                                : FitolaTheme.textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            goal['name'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: isSelected 
                                  ? FontWeight.bold 
                                  : FontWeight.normal,
                              color: isSelected 
                                  ? (goal['color'] as Color)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Duration Selection
              const Text(
                'Time Frame',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDuration,
                      isExpanded: true,
                      items: _durations.map((duration) {
                        return DropdownMenuItem(
                          value: duration,
                          child: Text(duration),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDuration = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Competition Interest
              Card(
                child: SwitchListTile(
                  title: const Text('Interested in Competitions'),
                  subtitle: const Text('Join leaderboards and challenges'),
                  value: _interestedInCompetition,
                  onChanged: (value) {
                    setState(() {
                      _interestedInCompetition = value;
                    });
                  },
                  activeColor: FitolaTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              
              // Summary Card
              if (_selectedGoals.isNotEmpty)
                Card(
                  color: FitolaTheme.primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Goals Summary:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._selectedGoals.map((goal) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 20,
                                color: FitolaTheme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(goal),
                            ],
                          ),
                        )),
                        const SizedBox(height: 8),
                        Text(
                          'Duration: $_selectedDuration',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              
              // Complete Button
              ElevatedButton(
                onPressed: _handleComplete,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Complete Setup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
