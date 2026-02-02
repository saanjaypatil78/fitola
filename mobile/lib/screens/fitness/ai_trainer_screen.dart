import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/config/theme.dart';

class AITrainerScreen extends StatefulWidget {
  const AITrainerScreen({super.key});

  @override
  State<AITrainerScreen> createState() => _AITrainerScreenState();
}

class _AITrainerScreenState extends State<AITrainerScreen> {
  String _selectedPlanType = 'workout';
  String _selectedGoal = 'weight_loss';
  String _selectedDifficulty = 'beginner';
  bool _isGenerating = false;

  final Map<String, Map<String, dynamic>> _goals = {
    'weight_loss': {
      'name': 'Weight Loss',
      'icon': Icons.trending_down,
      'color': Colors.red,
    },
    'muscle_gain': {
      'name': 'Muscle Gain',
      'icon': Icons.fitness_center,
      'color': Colors.blue,
    },
    'endurance': {
      'name': 'Endurance',
      'icon': Icons.run_circle,
      'color': Colors.green,
    },
    'flexibility': {
      'name': 'Flexibility',
      'icon': Icons.self_improvement,
      'color': Colors.purple,
    },
  };

  Future<void> _generatePlan() async {
    setState(() => _isGenerating = true);
    
    // Simulate AI plan generation
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isGenerating = false);
      
      // Navigate to appropriate plan screen
      if (_selectedPlanType == 'workout') {
        Navigator.pushNamed(context, AppRoutes.workoutPlan);
      } else {
        Navigator.pushNamed(context, AppRoutes.nutritionPlan);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Trainer'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                children: [
                  const Icon(
                    Icons.smart_toy,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AI-Powered Fitness Plans',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let AI create a personalized plan just for you',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Type Selection
                  Text(
                    'Plan Type',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPlanTypeCard(
                          'workout',
                          'Workout Plan',
                          Icons.fitness_center,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPlanTypeCard(
                          'nutrition',
                          'Nutrition Plan',
                          Icons.restaurant,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Goal Selection
                  Text(
                    'Fitness Goal',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      final goalKey = _goals.keys.elementAt(index);
                      final goal = _goals[goalKey]!;
                      final isSelected = _selectedGoal == goalKey;
                      
                      return InkWell(
                        onTap: () => setState(() => _selectedGoal = goalKey),
                        child: Card(
                          elevation: isSelected ? 8 : 2,
                          color: isSelected ? (goal['color'] as Color).withOpacity(0.1) : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? (goal['color'] as Color) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                goal['icon'] as IconData,
                                size: 40,
                                color: isSelected ? (goal['color'] as Color) : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                goal['name'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? (goal['color'] as Color) : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Difficulty Level
                  Text(
                    'Difficulty Level',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: [
                      _buildDifficultyChip('beginner', 'Beginner'),
                      _buildDifficultyChip('intermediate', 'Intermediate'),
                      _buildDifficultyChip('advanced', 'Advanced'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Info Card
                  Card(
                    color: Colors.blue.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AI will analyze your profile and generate a personalized plan tailored to your needs',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Generate Button
                  ElevatedButton(
                    onPressed: _isGenerating ? null : _generatePlan,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _isGenerating
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Generating AI Plan...'),
                              ],
                            )
                          : const Text(
                              'Generate AI Plan',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Access Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.workoutPlan),
                          icon: const Icon(Icons.visibility),
                          label: const Text('View Saved Plans'),
                        ),
                      ),
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

  Widget _buildPlanTypeCard(String type, String title, IconData icon, Color color) {
    final isSelected = _selectedPlanType == type;
    return InkWell(
      onTap: () => setState(() => _selectedPlanType = type),
      child: Card(
        elevation: isSelected ? 8 : 2,
        color: isSelected ? color.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? color : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String value, String label) {
    final isSelected = _selectedDifficulty == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedDifficulty = value);
      },
      selectedColor: FitolaTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
