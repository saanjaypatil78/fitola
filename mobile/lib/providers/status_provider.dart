import 'package:flutter/foundation.dart';
import 'package:fitola/models/fitbuddy.dart';

class StatusProvider with ChangeNotifier {
  UserStatus _currentStatus = UserStatus.available;
  DateTime? _ghostModeStartTime;
  bool _allowVoiceCalls = true;
  bool _allowVideoCalls = true;
  
  UserStatus get currentStatus => _currentStatus;
  DateTime? get ghostModeStartTime => _ghostModeStartTime;
  bool get allowVoiceCalls => _allowVoiceCalls;
  bool get allowVideoCalls => _allowVideoCalls;
  bool get isInGhostMode => _currentStatus == UserStatus.ghost;
  bool get isBusy => _currentStatus == UserStatus.busy;
  bool get isAvailable => _currentStatus == UserStatus.available;
  
  Duration? get ghostModeDuration {
    if (_ghostModeStartTime == null) return null;
    return DateTime.now().difference(_ghostModeStartTime!);
  }
  
  void setStatus(UserStatus status) {
    _currentStatus = status;
    
    if (status == UserStatus.ghost) {
      _ghostModeStartTime = DateTime.now();
    } else {
      _ghostModeStartTime = null;
    }
    
    notifyListeners();
  }
  
  void activateGhostMode() {
    setStatus(UserStatus.ghost);
  }
  
  void deactivateGhostMode() {
    setStatus(UserStatus.available);
  }
  
  void setBusy() {
    setStatus(UserStatus.busy);
  }
  
  void setAvailable() {
    setStatus(UserStatus.available);
  }
  
  void toggleVoiceCalls(bool allowed) {
    _allowVoiceCalls = allowed;
    notifyListeners();
  }
  
  void toggleVideoCalls(bool allowed) {
    _allowVideoCalls = allowed;
    notifyListeners();
  }
  
  void handleCallStart() {
    // Auto-switch to busy when call starts
    if (_currentStatus != UserStatus.ghost) {
      _currentStatus = UserStatus.busy;
      notifyListeners();
    }
  }
  
  void handleCallEnd() {
    // Revert to available when call ends
    if (_currentStatus == UserStatus.busy) {
      _currentStatus = UserStatus.available;
      notifyListeners();
    }
  }
  
  bool shouldShowGhostModeReminder() {
    if (_ghostModeStartTime == null) return false;
    
    final duration = ghostModeDuration;
    if (duration == null) return false;
    
    // Show reminder after 1 hour
    return duration.inMinutes >= 60;
  }
}
