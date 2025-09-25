import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper function to convert opacity to an alpha value
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- MAIN SCREEN WIDGET ---
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  // State for the toggle switches
  bool _biometricEnabled = true;
  bool _applockEnabled = false;
  bool _newAppAlertEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8A72E8), Color(0xFF6A4DDE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text(
                    'Setting',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Scrollable White Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildPremiumCard(),
                          const SizedBox(height: 30),
                          Text(
                            'Security & System',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 15),
                          buildSettingItem(
                            icon: FontAwesomeIcons.lock,
                            color: Colors.red.shade100,
                            iconColor: Colors.red,
                            title: 'Change Password',
                            subtitle: 'Set passcode for lock screen',
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ),
                          buildSettingItem(
                            icon: FontAwesomeIcons.solidEnvelope,
                            color: Colors.blue.shade100,
                            iconColor: Colors.blue,
                            title: 'Update the security email',
                            subtitle: 'Change or update the security email',
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ),
                          buildSettingItem(
                            icon: FontAwesomeIcons.fingerprint,
                            color: Colors.purple.shade100,
                            iconColor: Colors.purple,
                            title: 'Biometric',
                            subtitle: 'Use biometric authentication on the lock screen',
                            trailing: CupertinoSwitch(
                              value: _biometricEnabled,
                              onChanged: (val) => setState(() => _biometricEnabled = val),
                              activeTrackColor: const Color(0xFF6A4DDE),
                            ),
                          ),
                          buildSettingItem(
                            icon: FontAwesomeIcons.shieldHalved,
                            color: Colors.green.shade100,
                            iconColor: Colors.green,
                            title: 'Applock Status',
                            subtitle: 'Turn this off will disable app lock',
                            trailing: CupertinoSwitch(
                              value: _applockEnabled,
                              onChanged: (val) => setState(() => _applockEnabled = val),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'General',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 15),
                          buildSettingItem(
                            icon: FontAwesomeIcons.solidClock,
                            color: Colors.orange.shade100,
                            iconColor: Colors.orange,
                            title: 'Relock time (Default)',
                            subtitle: 'Choose a time to lock again after unlocking',
                            trailing: const FaIcon(FontAwesomeIcons.lock, size: 16, color: Colors.orange),
                          ),
                          buildSettingItem(
                            icon: FontAwesomeIcons.palette,
                            color: Colors.teal.shade100,
                            iconColor: Colors.teal,
                            title: 'Themes',
                            subtitle: 'Customize the look and feel',
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ),
                          buildSettingItem(
                            icon: FontAwesomeIcons.solidBell,
                            color: Colors.pink.shade100,
                            iconColor: Colors.pink,
                            title: 'New app alert',
                            subtitle: 'Ask to lock when a new app is installed',
                            trailing: CupertinoSwitch(
                              value: _newAppAlertEnabled,
                              onChanged: (val) => setState(() => _newAppAlertEnabled = val),
                              activeTrackColor: const Color(0xFF6A4DDE),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI BUILDER METHODS ---
  Widget buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light yellow background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Go Premium',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFA000),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock dozens of awesome features including face down lock, cloud vault and much more...',
                  style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[700], height: 1.4),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF8A72E8), Color(0xFF6A4DDE)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('Learn More', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/lock_icon.png',
              height: 90,
              errorBuilder: (c, e, s) => const FaIcon(FontAwesomeIcons.lock, size: 60, color: Color(0xFFFFA000)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettingItem({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
            child: FaIcon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF333333))),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}