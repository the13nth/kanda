// main.dart or your preferred file name

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Main App Entry Point ---

// --- Helper Function for Opacity ---
int alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Model for an Insurance Plan ---
class InsurancePlan {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final IconData icon;
  final Color color;
  final double monthlyPremium;
  final String shortDescription;
  final List<String> keyFeatures;

  InsurancePlan({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.icon,
    required this.color,
    required this.monthlyPremium,
    required this.shortDescription,
    required this.keyFeatures,
  });
}

// SCREEN 1: List of Saved Plans
class SavedPlansScreen extends StatefulWidget {
  const SavedPlansScreen({super.key});

  @override
  State<SavedPlansScreen> createState() => SavedPlansScreenState();
}

class SavedPlansScreenState extends State<SavedPlansScreen> {
  // Dummy Data - In a real app, this would come from a database or state management
  late List<InsurancePlan> savedPlans;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  void _loadPlans() {
    savedPlans = [
      InsurancePlan(
        id: 'health_01',
        name: 'Family Health Guard',
        category: 'Health',
        // Using picsum.photos for random images as a substitute for randomuser
        imageUrl: 'https://picsum.photos/seed/health/800/600',
        icon: FontAwesomeIcons.heartPulse,
        color: Colors.red,
        monthlyPremium: 220.50,
        shortDescription: 'Complete health coverage for the entire family.',
        keyFeatures: ['Up to \$500,000 coverage', '24/7 doctor teleconsultation', 'Covers pre-existing diseases', 'Cashless hospitalization'],
      ),
      InsurancePlan(
        id: 'vehicle_01',
        name: 'Secure Drive Plus',
        category: 'Vehicle',
        imageUrl: 'https://picsum.photos/seed/car/800/600',
        icon: FontAwesomeIcons.carBurst,
        color: Colors.blue,
        monthlyPremium: 95.00,
        shortDescription: 'Comprehensive protection for your vehicle.',
        keyFeatures: ['Zero depreciation cover', '24/7 roadside assistance', 'Engine and gearbox protection', 'Theft and damage cover'],
      ),
      InsurancePlan(
        id: 'life_01',
        name: 'Future Secure Plan',
        category: 'Life',
        imageUrl: 'https://picsum.photos/seed/life/800/600',
        icon: FontAwesomeIcons.umbrella,
        color: Colors.purple,
        monthlyPremium: 150.00,
        shortDescription: 'Ensure your loved ones are financially secure.',
        keyFeatures: ['Life cover up to \$1 Million', 'Tax benefits under Section 80C', 'Accidental death benefit included', 'Flexible payout options'],
      ),
    ];
  }

  void _removePlan(String planId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Plan'),
          content: const Text('Are you sure you want to remove this plan from your favorites?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remove'),
              onPressed: () {
                setState(() {
                  savedPlans.removeWhere((plan) => plan.id == planId);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Plans / Favorites'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: savedPlans.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: savedPlans.length,
        itemBuilder: (context, index) {
          return _buildPlanCard(savedPlans[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.solidHeart, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          const Text(
            'No Saved Plans Yet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            'Your favorite plans will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(InsurancePlan plan) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.antiAlias, // Important for the image border radius
      shadowColor: Colors.black.withAlpha(alphaFromOpacity(0.1)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanDetailScreen(plan: plan),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  plan.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 150, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported)),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(alphaFromOpacity(0.7))],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 5.0, color: Colors.black54)],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: plan.color.withAlpha(alphaFromOpacity(0.15)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(plan.icon, color: plan.color, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          plan.category,
                          style: TextStyle(color: plan.color, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(plan.shortDescription, style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
                      children: [
                        TextSpan(
                          text: '\$${plan.monthlyPremium.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const TextSpan(text: ' / month', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.trashCan, color: Colors.grey.shade600, size: 20),
                    onPressed: () => _removePlan(plan.id),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SCREEN 2: Detail view of a saved plan
class PlanDetailScreen extends StatelessWidget {
  final InsurancePlan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            stretch: true,
            backgroundColor: plan.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 3.0, color: Colors.black45)])),
              background: Image.network(
                plan.imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.4),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withAlpha(alphaFromOpacity(0.2)),
                  child: FaIcon(plan.icon, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Key Features', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...plan.keyFeatures.map((feature) => _buildFeatureRow(feature, context)),
                  const SizedBox(height: 24),
                  _buildPricingCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPurchaseButton(context),
    );
  }

  Widget _buildFeatureRow(String feature, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.solidCircleCheck, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(child: Text(feature, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildPricingCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: plan.color.withAlpha(alphaFromOpacity(0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Monthly Premium', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text(
              '\$${plan.monthlyPremium.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: plan.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text('Proceed to Purchase'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navigating to purchase flow... (Demo)'),
              backgroundColor: Color(0xFF004D40),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}