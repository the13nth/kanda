import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../models/vehicle.dart';
import 'supabase_config.dart';

class VehicleService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // Get all vehicles for current user
  static Future<List<Vehicle>> getUserVehicles() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('vehicles')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Vehicle.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error getting user vehicles: $e');
      return [];
    }
  }

  // Add a new vehicle
  static Future<Vehicle?> addVehicle(Vehicle vehicle) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('vehicles')
          .insert(vehicle.toJson())
          .select()
          .single();

      return Vehicle.fromJson(response);
    } catch (e) {
      developer.log('Error adding vehicle: $e');
      rethrow;
    }
  }

  // Update a vehicle
  static Future<Vehicle?> updateVehicle(Vehicle vehicle) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('vehicles')
          .update(vehicle.toJson())
          .eq('id', vehicle.id)
          .eq('user_id', user.id)
          .select()
          .single();

      return Vehicle.fromJson(response);
    } catch (e) {
      developer.log('Error updating vehicle: $e');
      rethrow;
    }
  }

  // Delete a vehicle
  static Future<void> deleteVehicle(String vehicleId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _client
          .from('vehicles')
          .delete()
          .eq('id', vehicleId)
          .eq('user_id', user.id);
    } catch (e) {
      developer.log('Error deleting vehicle: $e');
      rethrow;
    }
  }

  // Get vehicle by ID
  static Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _client
          .from('vehicles')
          .select()
          .eq('id', vehicleId)
          .eq('user_id', user.id)
          .single();

      return Vehicle.fromJson(response);
    } catch (e) {
      developer.log('Error getting vehicle by ID: $e');
      return null;
    }
  }
}
