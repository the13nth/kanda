// main.dart or your preferred file name

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Main App Entry Point ---


// --- Helper Function for Opacity ---
int alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Model for an Emergency Contact ---
class EmergencyContact {
  final String title;
  final String description;
  final String phoneNumber;
  final IconData icon;
  final Color color;

  EmergencyContact({
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.icon,
    required this.color,
  });
}

// --- The Emergency Services Screen ---
class EmergencyServicesScreen extends StatelessWidget {
  EmergencyServicesScreen({super.key});

  // Dummy Data
  final List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      title: 'Roadside Assistance',
      description: 'For breakdowns, flat tires, or towing.',
      phoneNumber: '1800-209-5846',
      icon: FontAwesomeIcons.carBurst,
      color: const Color(0xFF007BFF),
    ),
    EmergencyContact(
      title: 'File Emergency Claim',
      description: 'Initiate a claim immediately after an incident.',
      phoneNumber: '1800-266-3242',
      icon: FontAwesomeIcons.fileMedical,
      color: const Color(0xFF28A745),
    ),
    EmergencyContact(
      title: 'Ambulance Service',
      description: 'Request immediate medical transportation.',
      phoneNumber: '102',
      icon: FontAwesomeIcons.truckMedical,
      color: const Color(0xFFDC3545),
    ),
    EmergencyContact(
      title: 'Customer Support',
      description: 'For other queries and support.',
      phoneNumber: '1800-419-5555',
      icon: FontAwesomeIcons.headset,
      color: const Color(0xFF6C757D),
    ),
  ];

  // In a real app, this function would launch the dialer
  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Show an error if the call can't be made

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Assistance'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainHelplineCard(context),
            const SizedBox(height: 24),
            Text(
              'Other Services',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...emergencyContacts.map((contact) {
              return _buildEmergencyContactCard(contact, context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHelplineCard(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.red.withAlpha(alphaFromOpacity(0.3)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.red.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(FontAwesomeIcons.triangleExclamation, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  '24/7 General Helpline',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'For any immediate emergency, call our main helpline.',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.call, color: Colors.red),
                label: const Text(
                  'CALL 1800-123-4567',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                onPressed: () => _makePhoneCall('18001234567', context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard(EmergencyContact contact, BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 13.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black.withAlpha(alphaFromOpacity(0.05)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: contact.color.withAlpha(alphaFromOpacity(0.15)),
              child: FaIcon(contact.icon, size: 24, color: contact.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.call_outlined, size: 28),
              color: contact.color,
              onPressed: () => _makePhoneCall(contact.phoneNumber, context),
              tooltip: 'Call ${contact.phoneNumber}',
            ),
          ],
        ),
      ),
    );
  }
}