import 'model_utils.dart';

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
      createdAt: parseDateTimeRequired(json['created_at']),
      startDate: json['start_date'] != null ? parseDateTime(json['start_date']) : null,
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
  
  FitnessPlan copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    PlanType? type,
    DifficultyLevel? difficulty,
    int? durationDays,
    List<WorkoutDay>? workoutDays,
    String? aiGenerated,
    DateTime? createdAt,
    DateTime? startDate,
    int? currentDay,
  }) {
    return FitnessPlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      durationDays: durationDays ?? this.durationDays,
      workoutDays: workoutDays ?? this.workoutDays,
      aiGenerated: aiGenerated ?? this.aiGenerated,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      currentDay: currentDay ?? this.currentDay,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is FitnessPlan &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.type == type &&
        other.difficulty == difficulty &&
        other.durationDays == durationDays &&
        listEquals(other.workoutDays, workoutDays) &&
        other.aiGenerated == aiGenerated &&
        other.createdAt == createdAt &&
        other.startDate == startDate &&
        other.currentDay == currentDay;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      title,
      description,
      type,
      difficulty,
      durationDays,
      Object.hashAll(workoutDays),
      aiGenerated,
      createdAt,
      startDate,
      currentDay,
    );
  }
  
  @override
  String toString() {
    return 'FitnessPlan(id: $id, title: $title, type: $type, difficulty: $difficulty)';
  }
  
  // Validation helpers
  bool get isActive {
    return startDate != null && currentDay != null && currentDay! < durationDays;
  }
  
  bool get isCompleted {
    return currentDay != null && currentDay! >= durationDays;
  }
  
  int get remainingDays {
    if (currentDay == null) return durationDays;
    return (durationDays - currentDay!).clamp(0, durationDays);
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
  
  WorkoutDay copyWith({
    int? dayNumber,
    String? title,
    List<Exercise>? exercises,
    int? estimatedDuration,
    bool? isRestDay,
  }) {
    return WorkoutDay(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      exercises: exercises ?? this.exercises,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isRestDay: isRestDay ?? this.isRestDay,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is WorkoutDay &&
        other.dayNumber == dayNumber &&
        other.title == title &&
        listEquals(other.exercises, exercises) &&
        other.estimatedDuration == estimatedDuration &&
        other.isRestDay == isRestDay;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      dayNumber,
      title,
      Object.hashAll(exercises),
      estimatedDuration,
      isRestDay,
    );
  }
  
  @override
  String toString() {
    return 'WorkoutDay(day: $dayNumber, title: $title, exercises: ${exercises.length})';
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
  
  Exercise copyWith({
    String? name,
    String? description,
    int? sets,
    int? reps,
    int? duration,
    String? videoUrl,
  }) {
    return Exercise(
      name: name ?? this.name,
      description: description ?? this.description,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Exercise &&
        other.name == name &&
        other.description == description &&
        other.sets == sets &&
        other.reps == reps &&
        other.duration == duration &&
        other.videoUrl == videoUrl;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      name,
      description,
      sets,
      reps,
      duration,
      videoUrl,
    );
  }
  
  @override
  String toString() {
    return 'Exercise(name: $name, sets: $sets, reps: $reps)';
  }
  
  // Validation helpers
  bool get isValid {
    return name.isNotEmpty && sets > 0 && (reps > 0 || (duration != null && duration! > 0));
  }
  
  int get totalReps {
    return sets * reps;
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
