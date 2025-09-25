import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../models/claim.dart';
import 'supabase_config.dart';

class ClaimService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // Get user's claims
  static Future<List<Claim>> getUserClaims() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Claim.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error getting user claims: $e');
      rethrow;
    }
  }

  // Add a new claim
  static Future<Claim> addClaim(Claim claim) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .insert(claim.toJson())
          .select()
          .single();

      return Claim.fromJson(response);
    } catch (e) {
      developer.log('Error adding claim: $e');
      rethrow;
    }
  }

  // Update a claim
  static Future<Claim> updateClaim(Claim claim) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .update(claim.toJson())
          .eq('id', claim.id)
          .eq('user_id', user.id)
          .select()
          .single();

      return Claim.fromJson(response);
    } catch (e) {
      developer.log('Error updating claim: $e');
      rethrow;
    }
  }

  // Get claim by ID
  static Future<Claim?> getClaimById(String claimId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .select()
          .eq('id', claimId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) return null;
      return Claim.fromJson(response);
    } catch (e) {
      developer.log('Error getting claim by ID: $e');
      rethrow;
    }
  }

  // Delete a claim
  static Future<void> deleteClaim(String claimId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _client
          .from('claims')
          .delete()
          .eq('id', claimId)
          .eq('user_id', user.id);
    } catch (e) {
      developer.log('Error deleting claim: $e');
      rethrow;
    }
  }
}
