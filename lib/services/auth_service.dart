import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // Get current user
  static User? get currentUser => _client.auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Validate email format before sending to Supabase
      if (!_isValidEmail(email)) {
        throw Exception('Please enter a valid email address');
      }
      
      // Validate password strength
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters long');
      }
      
      final response = await _client.auth.signUp(
        email: email.trim().toLowerCase(),
        password: password,
        data: data,
      );
      return response;
    } catch (e) {
      // Provide more user-friendly error messages
      if (e.toString().contains('email_address_invalid')) {
        throw Exception('Please enter a valid email address');
      } else if (e.toString().contains('User already registered')) {
        throw Exception('An account with this email already exists');
      } else if (e.toString().contains('Password should be at least')) {
        throw Exception('Password must be at least 6 characters long');
      } else {
        rethrow;
      }
    }
  }
  
  // Helper method to validate email format
  static bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  static Future<UserResponse> updateProfile({
    required String userId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(data: data),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;
}
