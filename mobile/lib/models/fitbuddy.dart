import 'package:latlong2/latlong.dart';

class FitBuddy {
  final String id;
  final String name;
  final String? photoUrl;
  final String? gender;
  final LatLng location;
  final double distance; // in kilometers
  final UserStatus status;
  final String? bio;
  final List<String>? interests;
  final bool allowVoiceCalls;
  final bool allowVideoCalls;
  final DateTime? lastActive;
  
  FitBuddy({
    required this.id,
    required this.name,
    this.photoUrl,
    this.gender,
    required this.location,
    required this.distance,
    this.status = UserStatus.available,
    this.bio,
    this.interests,
    this.allowVoiceCalls = true,
    this.allowVideoCalls = true,
    this.lastActive,
  });
  
  factory FitBuddy.fromJson(Map<String, dynamic> json) {
    return FitBuddy(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      gender: json['gender'] as String?,
      location: LatLng(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      distance: (json['distance'] as num).toDouble(),
      status: UserStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => UserStatus.available,
      ),
      bio: json['bio'] as String?,
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
      allowVoiceCalls: json['allow_voice_calls'] as bool? ?? true,
      allowVideoCalls: json['allow_video_calls'] as bool? ?? true,
      lastActive: json['last_active'] != null ? DateTime.parse(json['last_active']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo_url': photoUrl,
      'gender': gender,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'distance': distance,
      'status': status.toString().split('.').last,
      'bio': bio,
      'interests': interests,
      'allow_voice_calls': allowVoiceCalls,
      'allow_video_calls': allowVideoCalls,
      'last_active': lastActive?.toIso8601String(),
    };
  }
  
  bool get isOnline {
    if (lastActive == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastActive!);
    return difference.inMinutes < 5;
  }
  
  FitBuddy copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? gender,
    LatLng? location,
    double? distance,
    UserStatus? status,
    String? bio,
    List<String>? interests,
    bool? allowVoiceCalls,
    bool? allowVideoCalls,
    DateTime? lastActive,
  }) {
    return FitBuddy(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      allowVoiceCalls: allowVoiceCalls ?? this.allowVoiceCalls,
      allowVideoCalls: allowVideoCalls ?? this.allowVideoCalls,
      lastActive: lastActive ?? this.lastActive,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is FitBuddy &&
        other.id == id &&
        other.name == name &&
        other.photoUrl == photoUrl &&
        other.gender == gender &&
        other.location.latitude == location.latitude &&
        other.location.longitude == location.longitude &&
        other.distance == distance &&
        other.status == status &&
        other.bio == bio &&
        _listEquals(other.interests, interests) &&
        other.allowVoiceCalls == allowVoiceCalls &&
        other.allowVideoCalls == allowVideoCalls &&
        other.lastActive == lastActive;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      photoUrl,
      gender,
      location.latitude,
      location.longitude,
      distance,
      status,
      bio,
      Object.hashAll(interests ?? []),
      allowVoiceCalls,
      allowVideoCalls,
      lastActive,
    );
  }
  
  @override
  String toString() {
    return 'FitBuddy(id: $id, name: $name, distance: ${distance}km, status: $status)';
  }
  
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

enum UserStatus {
  ghost,     // Hidden from map
  available, // Visible and accepting requests
  busy,      // Visible but not accepting requests
}
