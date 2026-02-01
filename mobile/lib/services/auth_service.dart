import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitola/models/user_model.dart';
import 'package:fitola/services/api_client.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  final _storage = const FlutterSecureStorage();
  final _apiClient = ApiClient();
  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  User? get currentUser => Supabase.instance.client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges =>
      Supabase.instance.client.auth.onAuthStateChange;
  
  Future<UserModel?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _saveAuthToken(response.session!.accessToken);
        _apiClient.setAuthToken(response.session!.accessToken);
        return await _fetchUserProfile(response.user!.id);
      }
      
      return null;
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }
  
  Future<UserModel?> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      if (response.user != null) {
        await _saveAuthToken(response.session!.accessToken);
        _apiClient.setAuthToken(response.session!.accessToken);
        
        // Create user profile in backend
        await _apiClient.post('/auth/register', {
          'id': response.user!.id,
          'email': email,
          'name': name,
        });
        
        return await _fetchUserProfile(response.user!.id);
      }
      
      return null;
    } catch (e) {
      throw AuthException('Registration failed: $e');
    }
  }
  
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      
      final googleAuth = await googleUser.authentication;
      
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );
      
      if (response.user != null) {
        await _saveAuthToken(response.session!.accessToken);
        _apiClient.setAuthToken(response.session!.accessToken);
        return await _fetchUserProfile(response.user!.id);
      }
      
      return null;
    } catch (e) {
      throw AuthException('Google sign in failed: $e');
    }
  }
  
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await Supabase.instance.client.auth.signOut();
      await _storage.delete(key: 'auth_token');
      _apiClient.clearAuthToken();
    } catch (e) {
      throw AuthException('Sign out failed: $e');
    }
  }
  
  Future<bool> checkAutoLogin() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        _apiClient.setAuthToken(token);
        final user = currentUser;
        return user != null;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<UserModel> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) {
        throw AuthException('No user logged in');
      }
      
      final response = await _apiClient.put('/user/profile', data);
      return UserModel.fromJson(response);
    } catch (e) {
      throw AuthException('Profile update failed: $e');
    }
  }
  
  Future<UserModel> _fetchUserProfile(String userId) async {
    try {
      final response = await _apiClient.get('/user/profile/$userId');
      return UserModel.fromJson(response);
    } catch (e) {
      throw AuthException('Failed to fetch user profile: $e');
    }
  }
  
  Future<void> _saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  
  @override
  String toString() => message;
}
