import 'package:flutter/foundation.dart';
import 'package:fitola/models/user_model.dart';
import 'package:fitola/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final user = await _authService.signInWithEmailPassword(email, password);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      
      return user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final user = await _authService.signUpWithEmailPassword(email, password, name);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      
      return user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final user = await _authService.signInWithGoogle();
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      
      return user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _authService.signOut();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> checkAutoLogin() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final isLoggedIn = await _authService.checkAutoLogin();
      if (isLoggedIn && _authService.currentUser != null) {
        // Fetch user profile
        _currentUser = await _authService.updateUserProfile({});
      }
      
      _isLoading = false;
      notifyListeners();
      
      return isLoggedIn;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final updatedUser = await _authService.updateUserProfile(data);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
