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
      createdAt: _parseDateTime(json['created_at'])!,
      durationDays: json['duration_days'] as int? ?? 7,
    );
  }
  
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now(); // Fallback to now for required fields
    }
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
  
  NutritionPlan copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    int? dailyCalories,
    Map<String, double>? macros,
    List<Meal>? meals,
    List<String>? dietaryRestrictions,
    String? aiGenerated,
    DateTime? createdAt,
    int? durationDays,
  }) {
    return NutritionPlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      macros: macros ?? this.macros,
      meals: meals ?? this.meals,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      aiGenerated: aiGenerated ?? this.aiGenerated,
      createdAt: createdAt ?? this.createdAt,
      durationDays: durationDays ?? this.durationDays,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NutritionPlan &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.dailyCalories == dailyCalories &&
        _mapEquals(other.macros, macros) &&
        _listEquals(other.meals, meals) &&
        _listEquals(other.dietaryRestrictions, dietaryRestrictions) &&
        other.aiGenerated == aiGenerated &&
        other.createdAt == createdAt &&
        other.durationDays == durationDays;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      title,
      description,
      dailyCalories,
      Object.hashAll(macros.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(meals),
      Object.hashAll(dietaryRestrictions ?? []),
      aiGenerated,
      createdAt,
      durationDays,
    );
  }
  
  @override
  String toString() {
    return 'NutritionPlan(id: $id, title: $title, dailyCalories: $dailyCalories)';
  }
  
  // Validation helpers
  bool get hasValidMacros {
    return macros.containsKey('protein') &&
        macros.containsKey('carbs') &&
        macros.containsKey('fats');
  }
  
  double get totalMacros {
    return (macros['protein'] ?? 0) + (macros['carbs'] ?? 0) + (macros['fats'] ?? 0);
  }
  
  int get calculatedCalories {
    // Protein: 4 cal/g, Carbs: 4 cal/g, Fats: 9 cal/g
    final protein = (macros['protein'] ?? 0) * 4;
    final carbs = (macros['carbs'] ?? 0) * 4;
    final fats = (macros['fats'] ?? 0) * 9;
    return (protein + carbs + fats).round();
  }
  
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
  
  bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
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
  
  Meal copyWith({
    String? name,
    MealType? type,
    List<FoodItem>? foods,
    int? calories,
    Map<String, double>? macros,
    String? instructions,
    String? imageUrl,
  }) {
    return Meal(
      name: name ?? this.name,
      type: type ?? this.type,
      foods: foods ?? this.foods,
      calories: calories ?? this.calories,
      macros: macros ?? this.macros,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Meal &&
        other.name == name &&
        other.type == type &&
        _listEquals(other.foods, foods) &&
        other.calories == calories &&
        _mapEquals(other.macros, macros) &&
        other.instructions == instructions &&
        other.imageUrl == imageUrl;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      name,
      type,
      Object.hashAll(foods),
      calories,
      Object.hashAll(macros.entries.map((e) => Object.hash(e.key, e.value))),
      instructions,
      imageUrl,
    );
  }
  
  @override
  String toString() {
    return 'Meal(name: $name, type: $type, calories: $calories)';
  }
  
  // Validation helpers
  int get calculatedCalories {
    return foods.fold(0, (sum, food) => sum + food.calories);
  }
  
  bool get hasValidCalories {
    return (calculatedCalories - calories).abs() <= 10; // Allow 10 cal margin
  }
  
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
  
  bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
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
  
  FoodItem copyWith({
    String? name,
    double? quantity,
    String? unit,
    int? calories,
  }) {
    return FoodItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is FoodItem &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.calories == calories;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      name,
      quantity,
      unit,
      calories,
    );
  }
  
  @override
  String toString() {
    return 'FoodItem(name: $name, quantity: $quantity $unit, calories: $calories)';
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
