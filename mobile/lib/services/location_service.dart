import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';
import 'package:fitola/services/api_client.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  
  final _apiClient = ApiClient();
  Position? _currentPosition;
  
  Future<bool> checkPermissions() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }
  
  Future<bool> requestPermissions() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }
  
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        final granted = await requestPermissions();
        if (!granted) return null;
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      _currentPosition = position;
      return position;
    } catch (e) {
      throw LocationException('Failed to get current position: $e');
    }
  }
  
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }
  
  double calculateDistance(LatLng from, LatLng to) {
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, from, to);
  }
  
  Future<void> updateUserLocation(String userId, LatLng location) async {
    try {
      await _apiClient.post('/location/update', {
        'user_id': userId,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw LocationException('Failed to update location: $e');
    }
  }
  
  Future<void> shareLocation(
    String userId,
    String targetUserId,
    Duration duration,
  ) async {
    try {
      await _apiClient.post('/location/share', {
        'user_id': userId,
        'target_user_id': targetUserId,
        'duration_seconds': duration.inSeconds,
      });
    } catch (e) {
      throw LocationException('Failed to share location: $e');
    }
  }
  
  Future<void> stopLocationSharing(String userId, String targetUserId) async {
    try {
      await _apiClient.delete('/location/share/$userId/$targetUserId');
    } catch (e) {
      throw LocationException('Failed to stop location sharing: $e');
    }
  }
  
  Future<LatLng?> getAddressCoordinates(String address) async {
    try {
      final response = await _apiClient.get('/location/geocode?address=$address');
      return LatLng(
        response['latitude'] as double,
        response['longitude'] as double,
      );
    } catch (e) {
      throw LocationException('Failed to geocode address: $e');
    }
  }
  
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  
  @override
  String toString() => message;
}
