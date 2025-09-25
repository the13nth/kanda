import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../models/policy.dart';
import 'supabase_config.dart';

class PolicyService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // Get all policies for current user
  static Future<List<Policy>> getUserPolicies() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('policies')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Policy.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error getting user policies: $e');
      return [];
    }
  }

  // Add a new policy
  static Future<Policy?> addPolicy(Policy policy) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('policies')
          .insert(policy.toJson())
          .select()
          .single();

      return Policy.fromJson(response);
    } catch (e) {
      developer.log('Error adding policy: $e');
      rethrow;
    }
  }

  // Update a policy
  static Future<Policy?> updatePolicy(Policy policy) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('policies')
          .update(policy.toJson())
          .eq('id', policy.id)
          .eq('user_id', user.id)
          .select()
          .single();

      return Policy.fromJson(response);
    } catch (e) {
      developer.log('Error updating policy: $e');
      rethrow;
    }
  }

  // Delete a policy
  static Future<void> deletePolicy(String policyId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _client
          .from('policies')
          .delete()
          .eq('id', policyId)
          .eq('user_id', user.id);
    } catch (e) {
      developer.log('Error deleting policy: $e');
      rethrow;
    }
  }

  // Get policy by ID
  static Future<Policy?> getPolicyById(String policyId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('policies')
          .select()
          .eq('id', policyId)
          .eq('user_id', user.id)
          .single();

      return Policy.fromJson(response);
    } catch (e) {
      developer.log('Error getting policy by ID: $e');
      return null;
    }
  }

  // Get active policies
  static Future<List<Policy>> getActivePolicies() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('policies')
          .select()
          .eq('user_id', user.id)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      return (response as List).map((json) => Policy.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error getting active policies: $e');
      return [];
    }
  }
}
