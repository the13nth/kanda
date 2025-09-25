// main.dart or your preferred file name

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Main App Entry Point ---


// --- Helper Function for Opacity ---
int alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Model for Insurance Plans ---
class InsurancePlan {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final double basePremium;
  bool isSelected; // This will be managed by the state

  InsurancePlan({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.basePremium,
    this.isSelected = false,
  });
}

// SCREEN 1: Plan Selection Screen
class BundlePlanScreen extends StatefulWidget {
  const BundlePlanScreen({super.key});

  @override
  State<BundlePlanScreen> createState() => BundlePlanScreenState();
}

class BundlePlanScreenState extends State<BundlePlanScreen> {
  // Dummy Data for the selectable plans
  final List<InsurancePlan> _plans = [
    InsurancePlan(
        id: 'health',
        name: 'Health Insurance',
        description: 'Comprehensive medical coverage for you and your family.',
        icon: FontAwesomeIcons.heartPulse,
        basePremium: 150.00),
    InsurancePlan(
        id: 'vehicle',
        name: 'Vehicle Insurance',
        description: 'Protection for your car against accidents, theft, and damage.',
        icon: FontAwesomeIcons.car,
        basePremium: 85.50),
    InsurancePlan(
        id: 'life',
        name: 'Life Insurance',
        description: 'Secure your family\'s financial future with a term life plan.',
        icon: FontAwesomeIcons.userShield,
        basePremium: 60.00),
    InsurancePlan(
        id: 'travel',
        name: 'Travel Insurance',
        description: 'Worry-free travels with coverage for trips and luggage.',
        icon: FontAwesomeIcons.planeDeparture,
        basePremium: 45.00),
  ];

  void _togglePlanSelection(int index) {
    setState(() {
      _plans[index].isSelected = !_plans[index].isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<InsurancePlan> selectedPlans = _plans.where((p) => p.isSelected).toList();
    int selectedCount = selectedPlans.length;
    double subtotal = selectedPlans.fold(0, (sum, item) => sum + item.basePremium);
    double discountPercentage = selectedCount >= 2 ? (selectedCount * 5.0) : 0.0; // 5% per plan
    double discountAmount = (subtotal * discountPercentage) / 100;
    double total = subtotal - discountAmount;
    bool canProceed = selectedCount >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Insurance Bundle'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                return _buildPlanCard(_plans[index], index);
              },
            ),
          ),
          _buildSummarySection(canProceed, selectedCount, subtotal, discountPercentage, total, selectedPlans),
        ],
      ),
    );
  }

  Widget _buildPlanCard(InsurancePlan plan, int index) {
    return Card(
      color: Colors.white,
      elevation: plan.isSelected ? 8.0 : 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: plan.isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: 2.0,
        ),
      ),
      shadowColor: Theme.of(context).primaryColor.withAlpha(alphaFromOpacity(0.2)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => _togglePlanSelection(index),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              FaIcon(plan.icon, size: 36, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(plan.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (plan.isSelected)
                Icon(Icons.check_circle, color: Colors.green.shade600, size: 28),
              if (!plan.isSelected)
                Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(bool canProceed, int count, double sub, double discP, double total, List<InsurancePlan> plans) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(alphaFromOpacity(0.05)),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Subtotal ($count plans)', style: const TextStyle(fontSize: 16)),
            Text('\$${sub.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Bundle Discount (${discP.toStringAsFixed(0)}%)', style: TextStyle(fontSize: 16, color: Colors.green.shade700)),
            Text('- \$${(sub - total).toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.green.shade700)),
          ]),
          const Divider(height: 24, thickness: 1),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total Monthly Premium', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canProceed
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BundleReviewScreen(selectedPlans: plans),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                canProceed ? 'Review Bundle' : 'Select at least 2 plans',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}


// SCREEN 2: Bundle Review Screen
class BundleReviewScreen extends StatelessWidget {
  final List<InsurancePlan> selectedPlans;

  const BundleReviewScreen({super.key, required this.selectedPlans});

  @override
  Widget build(BuildContext context) {
    double subtotal = selectedPlans.fold(0, (sum, item) => sum + item.basePremium);
    double discountPercentage = selectedPlans.length * 5.0;
    double discountAmount = (subtotal * discountPercentage) / 100;
    double total = subtotal - discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Your Bundle'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPolicyHolderCard(),
            const SizedBox(height: 24),
            Text('Selected Plans (${selectedPlans.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...selectedPlans.map((plan) => _buildPlanReviewItem(plan)),
            const SizedBox(height: 24),
            _buildPricingSummary(subtotal, discountAmount, total),
            const SizedBox(height: 32),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyHolderCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/40.jpg'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Policy Holder', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                const Text('Maria Williams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlanReviewItem(InsurancePlan plan) {
    return Card(

      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: FaIcon(plan.icon, color: Colors.indigo.shade700),
        title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text('\$${plan.basePremium.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildPricingSummary(double subtotal, double discount, double total) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildPricingRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildPricingRow('Bundle Discount', '- \$${discount.toStringAsFixed(2)}', color: Colors.green.shade700),
            const Divider(height: 24, thickness: 1),
            _buildPricingRow('Total Monthly Premium', '\$${total.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingRow(String label, String value, {Color? color, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Confirm & Proceed to Payment'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proceeding to payment... (Demo)'),
              backgroundColor: Color(0xFF2C3E50),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}