import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/vehicle.dart';
import '../../models/policy.dart';
import '../../services/vehicle_service.dart';
import '../../services/policy_service.dart';
import '../../widgets/custombtn.dart';
import '../../widgets/detailstext1.dart';

class EnhancedAIPolicyPage extends StatefulWidget {
  const EnhancedAIPolicyPage({super.key});

  @override
  State<EnhancedAIPolicyPage> createState() => _EnhancedAIPolicyPageState();
}

class _EnhancedAIPolicyPageState extends State<EnhancedAIPolicyPage> {
  List<Vehicle> _vehicles = [];
  List<Policy> _policies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final vehicles = await VehicleService.getUserVehicles();
      final policies = await PolicyService.getUserPolicies();

      setState(() {
        _vehicles = vehicles;
        _policies = policies;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getRecommendedPolicies() {
    List<Map<String, dynamic>> recommendations = [];

    // Generate recommendations based on user's vehicles and existing policies
    for (var vehicle in _vehicles) {
      // Check if vehicle already has a policy
      bool hasPolicy = _policies.any(
        (policy) => policy.vehicleId == vehicle.id && policy.status == 'active',
      );

      if (!hasPolicy) {
        // Generate AI recommendations based on vehicle data
        String riskLevel = _calculateRiskLevel(vehicle);
        double basePremium = _calculateBasePremium(vehicle);
        String discountReason = _getDiscountReason(vehicle);
        double discount = _getDiscountAmount(vehicle);

        recommendations.add({
          'title': 'Smart Coverage Plus',
          'description':
              'AI-recommended comprehensive coverage based on your ${vehicle.year} ${vehicle.make} ${vehicle.model}',
          'icon': Icons.directions_car,
          'iconColor': Colors.blue,
          'riskLevel': riskLevel,
          'discount': discount,
          'discountReason': discountReason,
          'monthlyPrice': basePremium * (1 - discount),
          'vehicleId': vehicle.id,
          'policyType': 'comprehensive',
        });

        recommendations.add({
          'title': 'Eco-Friendly Coverage',
          'description':
              'Specialized coverage for ${vehicle.engineType} engine with environmental benefits',
          'icon': Icons.eco,
          'iconColor': Colors.green,
          'riskLevel': 'low',
          'discount': 0.1,
          'discountReason': 'Eco-friendly vehicle discount',
          'monthlyPrice': basePremium * 0.9,
          'vehicleId': vehicle.id,
          'policyType': 'comprehensive',
        });
      }
    }

    // Add general recommendations if no vehicles
    if (_vehicles.isEmpty) {
      recommendations.addAll([
        {
          'title': 'Smart Coverage Plus',
          'description':
              'AI-recommended comprehensive coverage based on your safe driving patterns',
          'icon': Icons.directions_car,
          'iconColor': Colors.blue,
          'riskLevel': 'low',
          'discount': 0.15,
          'discountReason': '15% telematics discount',
          'monthlyPrice': 89.0,
          'vehicleId': null,
          'policyType': 'comprehensive',
        },
        {
          'title': 'Health Guardian Pro',
          'description':
              'Personalized health insurance with wellness rewards for active users',
          'icon': Icons.favorite,
          'iconColor': Colors.pink,
          'riskLevel': 'moderate',
          'discount': 0.10,
          'discountReason': '10% wearable bonus',
          'monthlyPrice': 120.0,
          'vehicleId': null,
          'policyType': 'health',
        },
        {
          'title': 'Urban Home Shield',
          'description':
              'Dynamic pricing optimized for apartment dwellers in urban areas',
          'icon': Icons.home,
          'iconColor': Colors.green,
          'riskLevel': 'low',
          'discount': 0.05,
          'discountReason': '5% claim-free discount',
          'monthlyPrice': 75.0,
          'vehicleId': null,
          'policyType': 'home',
        },
      ]);
    }

    return recommendations;
  }

  String _calculateRiskLevel(Vehicle vehicle) {
    int currentYear = DateTime.now().year;
    int vehicleAge = currentYear - vehicle.year;

    if (vehicleAge < 3) return 'low';
    if (vehicleAge < 8) return 'moderate';
    return 'high';
  }

  double _calculateBasePremium(Vehicle vehicle) {
    int currentYear = DateTime.now().year;
    int vehicleAge = currentYear - vehicle.year;

    double basePremium = 100.0;

    // Age factor
    if (vehicleAge < 3) {
      basePremium *= 1.2;
    } else if (vehicleAge < 8) {
      basePremium *= 1.0;
    } else {
      basePremium *= 0.8;
    }

    // Usage factor
    switch (vehicle.usage) {
      case 'personal':
        basePremium *= 1.0;
        break;
      case 'commercial':
        basePremium *= 1.5;
        break;
      case 'ride_share':
        basePremium *= 1.8;
        break;
    }

    return basePremium;
  }

  String _getDiscountReason(Vehicle vehicle) {
    if (vehicle.usage == 'personal') return 'Safe driver discount';
    if (vehicle.year > DateTime.now().year - 3) return 'New vehicle discount';
    return 'Loyalty discount';
  }

  double _getDiscountAmount(Vehicle vehicle) {
    if (vehicle.usage == 'personal') return 0.15;
    if (vehicle.year > DateTime.now().year - 3) return 0.10;
    return 0.05;
  }

  void _selectPolicy(Map<String, dynamic> policy) {
    showDialog(
      context: context,
      builder: (context) => PolicyDetailsDialog(policy: policy),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('AI Policy Recommendations'),
        backgroundColor: AppColors.bgColor,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_vehicles.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.info,
                              color: Colors.blue,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Add a vehicle to get personalized policy recommendations!',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/add-vehicle');
                              },
                              child: const Text('Add Vehicle'),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Found ${_vehicles.length} vehicle(s) - Generating personalized recommendations',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    const Text1(text1: 'Recommended Policies', size: 20),
                    const SizedBox(height: 15),

                    ..._getRecommendedPolicies().map(
                      (policy) => _buildPolicyCard(policy),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPolicyCard(Map<String, dynamic> policy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (policy['iconColor'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  policy['icon'] as IconData,
                  color: policy['iconColor'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policy['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      policy['description'] as String,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Risk Level',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    policy['riskLevel'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getRiskColor(policy['riskLevel'] as String),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Discount',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${((policy['discount'] as double) * 100).toInt()}% ${policy['discountReason'] as String}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Monthly Price',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '\$${(policy['monthlyPrice'] as double).toStringAsFixed(0)}/month',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(text: 'Select Plan', onTap: () => _selectPolicy(policy)),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class PolicyDetailsDialog extends StatefulWidget {
  final Map<String, dynamic> policy;

  const PolicyDetailsDialog({super.key, required this.policy});

  @override
  State<PolicyDetailsDialog> createState() => _PolicyDetailsDialogState();
}

class _PolicyDetailsDialogState extends State<PolicyDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _additionalInfoController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _createPolicy() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    try {
      // Here you would create the policy using PolicyService
      // For now, we'll just show a success message
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (mounted) {
        Navigator.pop(context); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Policy application submitted successfully!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating policy: $e')));
      }
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete Policy Application',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Policy: ${widget.policy['title']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Monthly Premium: \$${(widget.policy['monthlyPrice'] as double).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.buttonColor,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Additional Information (Optional):'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _additionalInfoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Any additional information or special requirements...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isCreating
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: _isCreating ? 'Creating...' : 'Apply for Policy',
                    onTap: _isCreating ? null : _createPolicy,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
