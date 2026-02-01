class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? ageGroup;
  final double? weight;
  final double? height;
  final String? city;
  final String? bodyType;
  final List<String>? goals;
  final bool? interestedInCompetition;
  final String? gender;
  final List<String>? allergies;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.ageGroup,
    this.weight,
    this.height,
    this.city,
    this.bodyType,
    this.goals,
    this.interestedInCompetition,
    this.gender,
    this.allergies,
    this.createdAt,
    this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String?,
      ageGroup: json['age_group'] as String?,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      city: json['city'] as String?,
      bodyType: json['body_type'] as String?,
      goals: json['goals'] != null ? List<String>.from(json['goals']) : null,
      interestedInCompetition: json['interested_in_competition'] as bool?,
      gender: json['gender'] as String?,
      allergies: json['allergies'] != null ? List<String>.from(json['allergies']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'age_group': ageGroup,
      'weight': weight,
      'height': height,
      'city': city,
      'body_type': bodyType,
      'goals': goals,
      'interested_in_competition': interestedInCompetition,
      'gender': gender,
      'allergies': allergies,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? ageGroup,
    double? weight,
    double? height,
    String? city,
    String? bodyType,
    List<String>? goals,
    bool? interestedInCompetition,
    String? gender,
    List<String>? allergies,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      ageGroup: ageGroup ?? this.ageGroup,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      city: city ?? this.city,
      bodyType: bodyType ?? this.bodyType,
      goals: goals ?? this.goals,
      interestedInCompetition: interestedInCompetition ?? this.interestedInCompetition,
      gender: gender ?? this.gender,
      allergies: allergies ?? this.allergies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  double? get bmi {
    if (weight == null || height == null || height == 0) return null;
    return weight! / ((height! / 100) * (height! / 100));
  }
  
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25.0) return 'Normal';
    if (bmiValue < 30.0) return 'Overweight';
    return 'Obese';
  }
}
