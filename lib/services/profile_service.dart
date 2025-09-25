import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../models/user_profile.dart';
import 'supabase_config.dart';

class ProfileService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // Get current user profile
  static Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      developer.log('Error getting user profile: $e');
      return null;
    }
  }

  // Create or update user profile
  static Future<UserProfile?> upsertUserProfile(UserProfile profile) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('user_profiles')
          .upsert(profile.toJson())
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      developer.log('Error upserting user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  static Future<UserProfile?> updateUserProfile(UserProfile profile) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('user_profiles')
          .update(profile.toJson())
          .eq('id', user.id)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      developer.log('Error updating user profile: $e');
      rethrow;
    }
  }

  // Create user profile (for new users)
  static Future<UserProfile?> createUserProfile({
    required String userId,
    required String fullName,
    String? phone,
    DateTime? dateOfBirth,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? profileImageUrl,
  }) async {
    try {
      final profile = UserProfile(
        id: userId,
        fullName: fullName,
        phone: phone,
        dateOfBirth: dateOfBirth,
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        profileImageUrl: profileImageUrl,
      );

      final response = await _client
          .from('user_profiles')
          .insert(profile.toJson())
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      developer.log('Error creating user profile: $e');
      rethrow;
    }
  }

  // Get user's full name
  static Future<String?> getUserFullName() async {
    try {
      final profile = await getCurrentUserProfile();
      return profile?.fullName;
    } catch (e) {
      developer.log('Error getting user full name: $e');
      return null;
    }
  }

  // Check if user profile exists
  static Future<bool> doesUserProfileExist() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return false;

      final response = await _client
          .from('user_profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      developer.log('Error checking user profile existence: $e');
      return false;
    }
  }
}
