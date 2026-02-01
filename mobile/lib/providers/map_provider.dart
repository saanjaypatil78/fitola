import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:fitola/models/fitbuddy.dart';
import 'package:fitola/services/api_client.dart';
import 'package:fitola/services/location_service.dart';

class MapProvider with ChangeNotifier {
  final _apiClient = ApiClient();
  final _locationService = LocationService();
  
  List<FitBuddy> _nearbyFitBuddies = [];
  LatLng? _currentLocation;
  int _selectedRadius = 5; // kilometers
  bool _isLoading = false;
  String? _error;
  Map<String, LatLng> _liveLocations = {}; // userId -> location
  
  List<FitBuddy> get nearbyFitBuddies => _nearbyFitBuddies;
  LatLng? get currentLocation => _currentLocation;
  int get selectedRadius => _selectedRadius;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, LatLng> get liveLocations => _liveLocations;
  
  Future<void> initialize() async {
    await updateCurrentLocation();
  }
  
  Future<void> updateCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        _currentLocation = LatLng(position.latitude, position.longitude);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> loadNearbyFitBuddies({UserStatus? statusFilter}) async {
    if (_currentLocation == null) {
      await updateCurrentLocation();
    }
    
    if (_currentLocation == null) {
      _error = 'Unable to get current location';
      notifyListeners();
      return;
    }
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final response = await _apiClient.get(
        '/map/nearby?'
        'latitude=${_currentLocation!.latitude}&'
        'longitude=${_currentLocation!.longitude}&'
        'radius=$_selectedRadius'
        '${statusFilter != null ? '&status=${statusFilter.toString().split('.').last}' : ''}',
      );
      
      _nearbyFitBuddies = (response['users'] as List)
          .map((json) => FitBuddy.fromJson(json))
          .toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void setRadius(int radius) {
    _selectedRadius = radius;
    notifyListeners();
    loadNearbyFitBuddies();
  }
  
  void startLiveLocationSharing(String userId, LatLng location) {
    _liveLocations[userId] = location;
    notifyListeners();
  }
  
  void updateLiveLocation(String userId, LatLng location) {
    _liveLocations[userId] = location;
    notifyListeners();
  }
  
  void stopLiveLocationSharing(String userId) {
    _liveLocations.remove(userId);
    notifyListeners();
  }
  
  bool isUserSharingLocation(String userId) {
    return _liveLocations.containsKey(userId);
  }
  
  Future<void> shareLocationWithUser(
    String userId,
    String targetUserId,
    Duration duration,
  ) async {
    try {
      await _locationService.shareLocation(userId, targetUserId, duration);
      
      // Start position stream
      _locationService.getPositionStream().listen((position) {
        final location = LatLng(position.latitude, position.longitude);
        updateLiveLocation(userId, location);
      });
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> stopSharingLocation(String userId, String targetUserId) async {
    try {
      await _locationService.stopLocationSharing(userId, targetUserId);
      stopLiveLocationSharing(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
