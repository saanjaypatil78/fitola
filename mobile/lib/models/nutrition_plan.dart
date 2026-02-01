class NutritionPlan {
  final String id;
  final String userId;
  final String title;
  final String description;
  final int dailyCalories;
  final Map<String, double> macros; // protein, carbs, fats (in grams)
  final List<Meal> meals;
  final List<String>? dietaryRestrictions;
  final String? aiGenerated;
  final DateTime createdAt;
  final int durationDays;
  
  NutritionPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dailyCalories,
    required this.macros,
    required this.meals,
    this.dietaryRestrictions,
    this.aiGenerated,
    required this.createdAt,
    this.durationDays = 7,
  });
  
  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    return NutritionPlan(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dailyCalories: json['daily_calories'] as int,
      macros: Map<String, double>.from(json['macros']),
      meals: (json['meals'] as List).map((e) => Meal.fromJson(e)).toList(),
      dietaryRestrictions: json['dietary_restrictions'] != null
          ? List<String>.from(json['dietary_restrictions'])
          : null,
      aiGenerated: json['ai_generated'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      durationDays: json['duration_days'] as int? ?? 7,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'daily_calories': dailyCalories,
      'macros': macros,
      'meals': meals.map((e) => e.toJson()).toList(),
      'dietary_restrictions': dietaryRestrictions,
      'ai_generated': aiGenerated,
      'created_at': createdAt.toIso8601String(),
      'duration_days': durationDays,
    };
  }
}

class Meal {
  final String name;
  final MealType type;
  final List<FoodItem> foods;
  final int calories;
  final Map<String, double> macros; // protein, carbs, fats
  final String? instructions;
  final String? imageUrl;
  
  Meal({
    required this.name,
    required this.type,
    required this.foods,
    required this.calories,
    required this.macros,
    this.instructions,
    this.imageUrl,
  });
  
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'] as String,
      type: MealType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MealType.breakfast,
      ),
      foods: (json['foods'] as List).map((e) => FoodItem.fromJson(e)).toList(),
      calories: json['calories'] as int,
      macros: Map<String, double>.from(json['macros']),
      instructions: json['instructions'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toString().split('.').last,
      'foods': foods.map((e) => e.toJson()).toList(),
      'calories': calories,
      'macros': macros,
      'instructions': instructions,
      'image_url': imageUrl,
    };
  }
}

class FoodItem {
  final String name;
  final double quantity;
  final String unit;
  final int calories;
  
  FoodItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
  });
  
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      calories: json['calories'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
    };
  }
}

enum MealType {
  breakfast,
  morningSnack,
  lunch,
  afternoonSnack,
  dinner,
  eveningSnack,
}
