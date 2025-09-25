import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// For the FAB positioning

// Helper function to convert opacity (0.0-1.0) to an alpha value (0-255).
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

class BuyingInsurancePage extends StatelessWidget {
  const BuyingInsurancePage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6A5AE0);
    const backgroundColor = Color(0xFFF7F8FC);
    const cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // Common app bar style
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: cardColor,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'Buying Insurance',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: cardColor,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(FontAwesomeIcons.bell, color: Colors.black54, size: 22),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    margin: const EdgeInsets.only(top: 2, right: 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Using a Stack to place the Floating Action Button precisely
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // The complex stacked profile and ID card section
                  ProfileIdCardStack(primaryColor: primaryColor),
                  const SizedBox(height: 30),
                  SectionTitle(title: 'Buy Insurance', onSeeAll: () {}),
                  const SizedBox(height: 20),
                  const BuyInsuranceOptions(),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ),
          // Positioned Floating Action Button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: primaryColor,
                child: const Icon(Icons.add, size: 30),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileIdCardStack extends StatelessWidget {
  final Color primaryColor;
  const ProfileIdCardStack({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    // Stack is used to create the overlapping effect
    return SizedBox(
      height: 440, // Adjust height to contain all elements
      child: Stack(
        clipBehavior: Clip.none, // Allow widgets to overflow
        children: [
          // Bottom Card (ID Card)
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: IdCard(primaryColor: primaryColor),
          ),
          // Top Card (Profile Info)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileCard(),
          ),
          // Profile Image that overflows the top card
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?fit=crop&w=800&q=80',
                  ),
                ),
              ),
            ),
          ),
          // Stacked Avatars at the intersection
          Positioned(
            top: 175,
            left: 20,
            child: ProfileAvatars(),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.08)),
            blurRadius: 20,
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alex\nMandes',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2)),
                const SizedBox(height: 8),
                Text('24 Feb 2001', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OverlappingCircles(),
                const SizedBox(height: 10),
                Text('11.12.22 (3 yr)', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OverlappingCircles extends StatelessWidget {
  const OverlappingCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1.5),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAvatars extends StatelessWidget {
  const ProfileAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          const CircleAvatar(backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg')),
          const SizedBox(width: 8),
          const CircleAvatar(backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg')),
          const SizedBox(width: 8),
          const CircleAvatar(backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/68.jpg')),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.add, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

class IdCard extends StatelessWidget {
  final Color primaryColor;
  const IdCard({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40), // Space for avatars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IdCardIconButton(icon: FontAwesomeIcons.check),
                  SizedBox(width: 10),
                  IdCardIconButton(icon: FontAwesomeIcons.arrowUpFromBracket),
                  SizedBox(width: 10),
                  IdCardIconButton(icon: FontAwesomeIcons.ellipsis),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Personality Data', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text('ID Card', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(label: 'ID Number', value: '326547624'),
                    SizedBox(height: 15),
                    InfoRow(label: 'Policy Number', value: 'CA326547624'),
                    SizedBox(height: 15),
                    InfoRow(label: 'Residence', value: 'California, USA'),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 160,
                width: 160,
                child:  ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://img.freepik.com/premium-vector/quar-code-line-icon-scan-me-product-link-application-pattern-recognition-chip-information-marking-multicolored-icon-white-background_661108-11235.jpg?semt=ais_hybrid&w=740',
                    fit: BoxFit.cover,
                  ),
                ),

              )

            ],
          ),
        ],
      ),
    );
  }
}

class IdCardIconButton extends StatelessWidget {
  final IconData icon;
  const IdCardIconButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white.withAlpha(_alphaFromOpacity(0.2)),
      child: FaIcon(icon, color: Colors.white, size: 16),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const SectionTitle({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onSeeAll, child: const Text('View All', style: TextStyle(color: Color(0xFF6A5AE0)))),
      ],
    );
  }
}

class BuyInsuranceOptions extends StatelessWidget {
  const BuyInsuranceOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: InsuranceOptionCard(
            title: 'Health Insurance',
            subtitle: '\$45/m',
            icon: FontAwesomeIcons.heartPulse,
            bgColor: Color(0xFF1E1E2D),
            iconColor: Colors.white,
            textColor: Colors.white,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: InsuranceOptionCard(
            title: 'Bike Insurance',
            subtitle: '\$15/m',
            icon: FontAwesomeIcons.motorcycle,
            bgColor: Colors.white,
            iconColor: Colors.black,
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }
}

class InsuranceOptionCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color bgColor, iconColor, textColor;

  const InsuranceOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.05)),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FaIcon(icon, color: iconColor, size: 24),
              CircleAvatar(
                radius: 12,
                backgroundColor: textColor.withAlpha(_alphaFromOpacity(0.2)),
                child: Icon(FontAwesomeIcons.arrowRight, size: 10, color: textColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}