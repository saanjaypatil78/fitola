import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/config/theme.dart';

class BodyTypeScreen extends StatefulWidget {
  const BodyTypeScreen({super.key});

  @override
  State<BodyTypeScreen> createState() => _BodyTypeScreenState();
}

class _BodyTypeScreenState extends State<BodyTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedBodyType;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<Map<String, String>> _bodyTypes = [
    {'name': 'Ectomorph', 'description': 'Lean and long, difficulty building muscle'},
    {'name': 'Mesomorph', 'description': 'Muscular and well-built, great at building muscle'},
    {'name': 'Endomorph', 'description': 'Bigger, higher body fat, gains muscle & fat easily'},
  ];

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  double? get _bmi {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    if (height == null || weight == null || height == 0) return null;
    return weight / ((height / 100) * (height / 100));
  }

  String? get _bmiCategory {
    final bmi = _bmi;
    if (bmi == null) return null;
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  void _showBodyTypeInfo(String bodyType, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bodyType),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
        return;
      }
      if (_selectedBodyType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your body type')),
        );
        return;
      }
      
      Navigator.of(context).pushNamed(AppRoutes.goals);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Information'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Your Body Metrics',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Help us create your personalized plan',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FitolaTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Gender Selection
                const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: _genders.map((gender) {
                    final isSelected = _selectedGender == gender;
                    return ChoiceChip(
                      label: Text(gender),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGender = selected ? gender : null;
                        });
                      },
                      selectedColor: FitolaTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                
                // Height and Weight
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Height (cm)',
                          prefixIcon: Icon(Icons.height),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          final height = double.tryParse(value);
                          if (height == null || height <= 0 || height > 300) {
                            return 'Invalid height';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          prefixIcon: Icon(Icons.monitor_weight),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null || weight <= 0 || weight > 500) {
                            return 'Invalid weight';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // BMI Display
                if (_bmi != null)
                  Card(
                    color: FitolaTheme.primaryColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Your BMI: ${_bmi!.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: FitolaTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Category: $_bmiCategory',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                
                // Body Type Selection
                const Text('Body Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._bodyTypes.map((type) {
                  final isSelected = _selectedBodyType == type['name'];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected ? FitolaTheme.primaryColor.withOpacity(0.1) : null,
                    child: ListTile(
                      title: Text(
                        type['name']!,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? FitolaTheme.primaryColor : null,
                        ),
                      ),
                      subtitle: Text(type['description']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () => _showBodyTypeInfo(type['name']!, type['description']!),
                      ),
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedBodyType = type['name'];
                        });
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 32),
                
                // Continue Button
                ElevatedButton(
                  onPressed: _handleContinue,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
