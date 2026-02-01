class FitnessPlan {
  final String id;
  final String userId;
  final String title;
  final String description;
  final PlanType type;
  final DifficultyLevel difficulty;
  final int durationDays;
  final List<WorkoutDay> workoutDays;
  final String? aiGenerated;
  final DateTime createdAt;
  final DateTime? startDate;
  final int? currentDay;
  
  FitnessPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    this.difficulty = DifficultyLevel.beginner,
    required this.durationDays,
    required this.workoutDays,
    this.aiGenerated,
    required this.createdAt,
    this.startDate,
    this.currentDay,
  });
  
  factory FitnessPlan.fromJson(Map<String, dynamic> json) {
    return FitnessPlan(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: PlanType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => PlanType.weightLoss,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['difficulty'],
        orElse: () => DifficultyLevel.beginner,
      ),
      durationDays: json['duration_days'] as int,
      workoutDays: (json['workout_days'] as List)
          .map((e) => WorkoutDay.fromJson(e))
          .toList(),
      aiGenerated: json['ai_generated'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      currentDay: json['current_day'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'duration_days': durationDays,
      'workout_days': workoutDays.map((e) => e.toJson()).toList(),
      'ai_generated': aiGenerated,
      'created_at': createdAt.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'current_day': currentDay,
    };
  }
  
  double get progressPercentage {
    if (currentDay == null || durationDays == 0) return 0.0;
    return (currentDay! / durationDays * 100).clamp(0.0, 100.0);
  }
}

class WorkoutDay {
  final int dayNumber;
  final String title;
  final List<Exercise> exercises;
  final int estimatedDuration; // in minutes
  final bool isRestDay;
  
  WorkoutDay({
    required this.dayNumber,
    required this.title,
    required this.exercises,
    required this.estimatedDuration,
    this.isRestDay = false,
  });
  
  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      dayNumber: json['day_number'] as int,
      title: json['title'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
      estimatedDuration: json['estimated_duration'] as int,
      isRestDay: json['is_rest_day'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'day_number': dayNumber,
      'title': title,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'estimated_duration': estimatedDuration,
      'is_rest_day': isRestDay,
    };
  }
}

class Exercise {
  final String name;
  final String? description;
  final int sets;
  final int reps;
  final int? duration; // in seconds
  final String? videoUrl;
  
  Exercise({
    required this.name,
    this.description,
    required this.sets,
    required this.reps,
    this.duration,
    this.videoUrl,
  });
  
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      description: json['description'] as String?,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      duration: json['duration'] as int?,
      videoUrl: json['video_url'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'video_url': videoUrl,
    };
  }
}

enum PlanType {
  weightLoss,
  muscleGain,
  maintenance,
  flexibility,
  stamina,
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}
