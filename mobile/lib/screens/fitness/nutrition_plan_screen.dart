import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

class NutritionPlanScreen extends StatefulWidget {
  const NutritionPlanScreen({super.key});

  @override
  State<NutritionPlanScreen> createState() => _NutritionPlanScreenState();
}

class _NutritionPlanScreenState extends State<NutritionPlanScreen> {
  bool _isLoading = false;
  String _selectedDay = 'Today';

  final List<String> _days = ['Today', 'Tomorrow', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7'];

  // Mock nutrition data
  final Map<String, Map<String, dynamic>> _nutritionData = {
    'Today': {
      'totalCalories': 2450,
      'targetCalories': 2500,
      'protein': 150,
      'carbs': 280,
      'fats': 70,
      'meals': [
        {
          'name': 'Breakfast',
          'time': '7:30 AM',
          'icon': Icons.wb_sunny,
          'color': Colors.orange,
          'items': [
            {'name': 'Oatmeal with berries', 'calories': 350, 'protein': 12, 'carbs': 58, 'fats': 8},
            {'name': 'Greek yogurt', 'calories': 150, 'protein': 15, 'carbs': 12, 'fats': 4},
            {'name': 'Orange juice', 'calories': 110, 'protein': 2, 'carbs': 26, 'fats': 0},
          ],
        },
        {
          'name': 'Mid-Morning Snack',
          'time': '10:30 AM',
          'icon': Icons.coffee,
          'color': Colors.brown,
          'items': [
            {'name': 'Protein shake', 'calories': 200, 'protein': 25, 'carbs': 15, 'fats': 5},
            {'name': 'Banana', 'calories': 105, 'protein': 1, 'carbs': 27, 'fats': 0},
          ],
        },
        {
          'name': 'Lunch',
          'time': '12:30 PM',
          'icon': Icons.restaurant,
          'color': Colors.green,
          'items': [
            {'name': 'Grilled chicken breast', 'calories': 280, 'protein': 45, 'carbs': 0, 'fats': 9},
            {'name': 'Brown rice', 'calories': 215, 'protein': 5, 'carbs': 45, 'fats': 2},
            {'name': 'Steamed vegetables', 'calories': 80, 'protein': 4, 'carbs': 15, 'fats': 1},
          ],
        },
        {
          'name': 'Afternoon Snack',
          'time': '4:00 PM',
          'icon': Icons.fastfood,
          'color': Colors.amber,
          'items': [
            {'name': 'Apple with almond butter', 'calories': 200, 'protein': 4, 'carbs': 28, 'fats': 8},
            {'name': 'Mixed nuts', 'calories': 170, 'protein': 5, 'carbs': 8, 'fats': 15},
          ],
        },
        {
          'name': 'Dinner',
          'time': '7:30 PM',
          'icon': Icons.dinner_dining,
          'color': Colors.blue,
          'items': [
            {'name': 'Salmon fillet', 'calories': 360, 'protein': 40, 'carbs': 0, 'fats': 20},
            {'name': 'Quinoa', 'calories': 220, 'protein': 8, 'carbs': 39, 'fats': 4},
            {'name': 'Green salad', 'calories': 50, 'protein': 2, 'carbs': 10, 'fats': 1},
          ],
        },
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _loadNutritionPlan();
  }

  Future<void> _loadNutritionPlan() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final data = _nutritionData[_selectedDay];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Plan'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add custom meal coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Day Selector
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _days.length,
                    itemBuilder: (context, index) {
                      final day = _days[index];
                      final isSelected = _selectedDay == day;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedDay = day);
                          },
                          selectedColor: FitolaTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Nutrition Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Daily Calories',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            '${data?['totalCalories']} / ${data?['targetCalories']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (data?['totalCalories'] ?? 0) / (data?['targetCalories'] ?? 1),
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMacroColumn('Protein', '${data?['protein']}g', Colors.blue[200]!),
                          _buildMacroColumn('Carbs', '${data?['carbs']}g', Colors.orange[200]!),
                          _buildMacroColumn('Fats', '${data?['fats']}g', Colors.pink[200]!),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Meals List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data?['meals'].length ?? 0,
                    itemBuilder: (context, index) {
                      final meal = (data!['meals'] as List)[index];
                      return _buildMealCard(meal);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMacroColumn(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    final items = meal['items'] as List<Map<String, dynamic>>;
    final totalCalories = items.fold<int>(0, (sum, item) => sum + (item['calories'] as int));
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (meal['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            meal['icon'] as IconData,
            color: meal['color'] as Color,
          ),
        ),
        title: Text(
          meal['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal['time'] as String,
              style: const TextStyle(color: FitolaTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalCalories calories',
              style: const TextStyle(
                color: FitolaTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...items.map((item) => _buildFoodItem(item)),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutrientInfo(
                      'Protein',
                      '${items.fold<int>(0, (sum, item) => sum + (item['protein'] as int))}g',
                      Colors.blue,
                    ),
                    _buildNutrientInfo(
                      'Carbs',
                      '${items.fold<int>(0, (sum, item) => sum + (item['carbs'] as int))}g',
                      Colors.orange,
                    ),
                    _buildNutrientInfo(
                      'Fats',
                      '${items.fold<int>(0, (sum, item) => sum + (item['fats'] as int))}g',
                      Colors.pink,
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

  Widget _buildFoodItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8, color: FitolaTheme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item['name'] as String),
                ),
              ],
            ),
          ),
          Text(
            '${item['calories']} cal',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: FitolaTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
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
