import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../models/claim.dart';
import 'supabase_config.dart';

class ClaimService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // Get all claims for the current user
  static Future<List<Claim>> getUserClaims() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return response
          .map<Claim>((json) => Claim.fromJson(json))
          .toList();
    } catch (e) {
      developer.log('Error getting user claims: $e');
      rethrow;
    }
  }

  // Get a specific claim by ID
  static Future<Claim?> getClaimById(String claimId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .select()
          .eq('id', claimId)
          .eq('user_id', user.id)
          .single();

      return Claim.fromJson(response);
    } catch (e) {
      developer.log('Error getting claim by ID: $e');
      return null;
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

  // Update claim status
  static Future<Claim> updateClaimStatus(String claimId, String status) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', claimId)
          .eq('user_id', user.id)
          .select()
          .single();

      return Claim.fromJson(response);
    } catch (e) {
      developer.log('Error updating claim status: $e');
      rethrow;
    }
  }

  // Update claim with AI analysis
  static Future<Claim> updateClaimWithAnalysis(
    String claimId,
    String analysisResult,
    int riskScore,
  ) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .update({
            'adjuster_notes': analysisResult,
            'updated_at': DateTime.now().toIso8601String(),
            // Add risk_score field if it exists in your schema
            // 'risk_score': riskScore,
          })
          .eq('id', claimId)
          .eq('user_id', user.id)
          .select()
          .single();

      return Claim.fromJson(response);
    } catch (e) {
      developer.log('Error updating claim with analysis: $e');
      rethrow;
    }
  }

  // Get claims by status
  static Future<List<Claim>> getClaimsByStatus(String status) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .select()
          .eq('user_id', user.id)
          .eq('status', status)
          .order('created_at', ascending: false);

      return response
          .map<Claim>((json) => Claim.fromJson(json))
          .toList();
    } catch (e) {
      developer.log('Error getting claims by status: $e');
      rethrow;
    }
  }

  // Get claims statistics
  static Future<Map<String, dynamic>> getClaimsStatistics() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('claims')
          .select()
          .eq('user_id', user.id);

      final claims = (response as List)
          .map((json) => Claim.fromJson(json as Map<String, dynamic>))
          .toList();

      final totalClaims = claims.length;
      final submittedClaims = claims.where((c) => c.status == 'submitted').length;
      final approvedClaims = claims.where((c) => c.status == 'approved').length;
      final pendingClaims = claims.where((c) => c.status == 'processing').length;
      final totalAmount = claims
          .where((c) => c.claimAmount != null)
          .fold(0.0, (sum, claim) => sum + claim.claimAmount!);

      return {
        'total_claims': totalClaims,
        'submitted_claims': submittedClaims,
        'approved_claims': approvedClaims,
        'pending_claims': pendingClaims,
        'total_amount': totalAmount,
      };
    } catch (e) {
      developer.log('Error getting claims statistics: $e');
      rethrow;
    }
  }
}