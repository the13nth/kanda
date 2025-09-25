import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Data Model for a Benefit Item ---
// This class holds the data for each benefit card, making the list easy to manage.
class Benefit {
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const Benefit({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });
}

// --- The Main Screen Widget ---
class BenefitsPage extends StatelessWidget {
  const BenefitsPage({super.key});

  // --- Dummy Data Source ---
  // A list of benefits to display on the screen.
  final List<Benefit> benefitsList = const [
    Benefit(
      title: '24/7 Roadside Assistance',
      description: 'Get help anytime, anywhere for breakdowns, flat tires, and more.',
      icon: FontAwesomeIcons.carBurst,
      iconBackgroundColor: Color(0xFFFFF3E2),
      iconColor: Color(0xFFF7B15C),
    ),
    Benefit(
      title: 'Health & Wellness Program',
      description: 'Access to exclusive wellness content and health tracking tools.',
      icon: FontAwesomeIcons.heartPulse,
      iconBackgroundColor: Color(0xFFFEE8E8),
      iconColor: Color(0xFFF36A6A),
    ),
    Benefit(
      title: 'Free Annual Check-up',
      description: 'One complimentary health screening per year at our network hospitals.',
      icon: FontAwesomeIcons.stethoscope,
      iconBackgroundColor: Color(0xFFE2F6FE),
      iconColor: Color(0xFF4AC4F3),
    ),
    Benefit(
      title: 'No-Claim Bonus Protection',
      description: 'Your bonus is protected even if you make one claim during the policy year.',
      icon: FontAwesomeIcons.shieldHalved,
      iconBackgroundColor: Color(0xFFE8E6FC),
      iconColor: Color(0xFF6A5AE0),
    ),
    Benefit(
      title: 'Exclusive Gym Discounts',
      description: 'Up to 30% off on memberships at our partner fitness centers.',
      icon: FontAwesomeIcons.dumbbell,
      iconBackgroundColor: Color(0xFFE2F8F0),
      iconColor: Color(0xFF34D399),
    ),Benefit(
      title: '24/7 Roadside Assistance',
      description: 'Get help anytime, anywhere for breakdowns, flat tires, and more.',
      icon: FontAwesomeIcons.carBurst,
      iconBackgroundColor: Color(0xFFFFF3E2),
      iconColor: Color(0xFFF7B15C),
    ),
    Benefit(
      title: 'Health & Wellness Program',
      description: 'Access to exclusive wellness content and health tracking tools.',
      icon: FontAwesomeIcons.heartPulse,
      iconBackgroundColor: Color(0xFFFEE8E8),
      iconColor: Color(0xFFF36A6A),
    ),
    Benefit(
      title: 'Free Annual Check-up',
      description: 'One complimentary health screening per year at our network hospitals.',
      icon: FontAwesomeIcons.stethoscope,
      iconBackgroundColor: Color(0xFFE2F6FE),
      iconColor: Color(0xFF4AC4F3),
    ),
    Benefit(
      title: 'No-Claim Bonus Protection',
      description: 'Your bonus is protected even if you make one claim during the policy year.',
      icon: FontAwesomeIcons.shieldHalved,
      iconBackgroundColor: Color(0xFFE8E6FC),
      iconColor: Color(0xFF6A5AE0),
    ),
    Benefit(
      title: 'Exclusive Gym Discounts',
      description: 'Up to 30% off on memberships at our partner fitness centers.',
      icon: FontAwesomeIcons.dumbbell,
      iconBackgroundColor: Color(0xFFE2F8F0),
      iconColor: Color(0xFF34D399),
    ),
    Benefit(
      title: 'International Travel Coverage',
      description: 'Stay protected with emergency medical coverage when you travel abroad.',
      icon: FontAwesomeIcons.planeDeparture,
      iconBackgroundColor: Color(0xFFFCE4EC),
      iconColor: Color(0xFFE91E63),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'My Benefits',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: benefitsList.length,
        itemBuilder: (context, index) {
          final benefit = benefitsList[index];
          return Padding(
            // Add spacing between cards
            padding: const EdgeInsets.only(bottom: 10.0),
            child: BenefitCard(benefit: benefit),
          );
        },
      ),
    );
  }
}

// --- Reusable Widget for a single Benefit Card ---
class BenefitCard extends StatelessWidget {
  final Benefit benefit;

  const BenefitCard({
    super.key,
    required this.benefit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: benefit.iconBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: FaIcon(benefit.icon, color: benefit.iconColor, size: 24),
        ),
        title: Text(
          benefit.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            benefit.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Action to perform when a benefit card is tapped.
          // For example, navigate to a detail screen for that benefit.
        },
      ),
    );
  }
}