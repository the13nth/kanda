import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// --- MAIN APP ENTRY POINT ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance App - Legal Advisory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B3E5B)),
        useMaterial3: true,
      ),
      // The starting point for this module
      home: const LegalAdvisoryScreen(),
    );
  }
}

// --- HELPER FUNCTION FOR OPACITY ---
int alphaFromOpacity(double opacity) {
  final clampedOpacity = opacity.clamp(0.0, 1.0);
  return (clampedOpacity * 255).round();
}

// --- DATA MODEL for Legal Advisors ---
class LegalAdvisor {
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;

  LegalAdvisor({required this.name, required this.specialization, required this.imageUrl, required this.rating});
}

// --- SCREEN 1: LEGAL ADVISORY MAIN SCREEN ---

class LegalAdvisoryScreen extends StatelessWidget {
  const LegalAdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LegalAdvisor> dummyAdvisors = [
      LegalAdvisor(
        name: 'Michael Chen',
        specialization: 'Claim Dispute Law',
        imageUrl: 'https://randomuser.me/api/portraits/men/55.jpg',
        rating: 4.9,
      ),
      LegalAdvisor(
        name: 'Sophia Rodriguez',
        specialization: 'Insurance Contract Law',
        imageUrl: 'https://randomuser.me/api/portraits/women/58.jpg',
        rating: 4.8,
      ),
      LegalAdvisor(
        name: 'David Carter',
        specialization: 'Accident & Liability',
        imageUrl: 'https://randomuser.me/api/portraits/men/61.jpg',
        rating: 4.7,
      ),
      LegalAdvisor(
        name: 'Michael Chen',
        specialization: 'Claim Dispute Law',
        imageUrl: 'https://randomuser.me/api/portraits/men/55.jpg',
        rating: 4.9,
      ),
      LegalAdvisor(
        name: 'Sophia Rodriguez',
        specialization: 'Insurance Contract Law',
        imageUrl: 'https://randomuser.me/api/portraits/women/58.jpg',
        rating: 4.8,
      ),
      LegalAdvisor(
        name: 'David Carter',
        specialization: 'Accident & Liability',
        imageUrl: 'https://randomuser.me/api/portraits/men/61.jpg',
        rating: 4.7,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal & Dispute Support'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Legal Ally", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              "Get expert help for your insurance-related legal needs.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            // Feature Card for Filing a Dispute
            _buildServiceCard(
              context: context,
              icon: FontAwesomeIcons.fileSignature,
              title: "File a Claim Dispute",
              subtitle: "Get professional help with unresolved claims.",
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ClaimDisputeScreen()));
              },
            ),

            const SizedBox(height: 13),
            const Text("Meet Our Legal Experts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // List of Legal Advisors
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyAdvisors.length,
              itemBuilder: (context, index) {
                final advisor = dummyAdvisors[index];
                return _buildAdvisorCard(context, advisor);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shadowColor: color.withAlpha(alphaFromOpacity(0.2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withAlpha(alphaFromOpacity(0.15)),
                child: FaIcon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvisorCard(BuildContext context, LegalAdvisor advisor) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2.0,
      shadowColor: Colors.black.withAlpha(alphaFromOpacity(0.05)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(advisor.imageUrl)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(advisor.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(advisor.specialization, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[600], size: 18),
                      const SizedBox(width: 4),
                      Text(advisor.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.solidMessage, size: 20),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 2: CLAIM DISPUTE FORM SCREEN ---

class ClaimDisputeScreen extends StatefulWidget {
  const ClaimDisputeScreen({super.key});

  @override
  State<ClaimDisputeScreen> createState() => ClaimDisputeScreenState();
}

class ClaimDisputeScreenState extends State<ClaimDisputeScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitDispute() {
    if (_formKey.currentState!.validate()) {
      // Logic to process data would go here

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SubmissionSuccessScreen(
            title: 'Dispute Filed Successfully!',
            message: 'Our legal team will review your case and contact you within 2 business days.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File a Claim Dispute'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Provide details about your claim dispute. Our team is here to help.",
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: _inputDecoration('Policy Number'),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter your policy number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(decoration: _inputDecoration('Claim ID (if available)')),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                decoration: _inputDecoration('Describe Your Dispute').copyWith(alignLabelWithHint: true),
                validator: (value) => (value == null || value.isEmpty) ? 'Please describe your dispute' : null,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.paperclip, size: 16),
                label: const Text('Attach Supporting Documents'),
                onPressed: () {
                  // File picker logic would go here
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitDispute,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Submit for Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

// --- SCREEN 3: SUBMISSION SUCCESS SCREEN ---

class SubmissionSuccessScreen extends StatelessWidget {
  final String title;
  final String message;

  const SubmissionSuccessScreen({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.withAlpha(alphaFromOpacity(0.15)),
                child: const FaIcon(FontAwesomeIcons.solidCircleCheck, color: Colors.green, size: 50),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Pop back to the main legal advisory screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
