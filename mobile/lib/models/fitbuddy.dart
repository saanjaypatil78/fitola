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
}

enum UserStatus {
  ghost,     // Hidden from map
  available, // Visible and accepting requests
  busy,      // Visible but not accepting requests
}
