import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper function to convert opacity (0.0-1.0) to an alpha value (0-255).
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

class Policies extends StatelessWidget {
  const Policies({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a modern color palette
    const primaryColor = Color(0xFF6A5AE0);
    const accentColorOrange = Color(0xFFF39C12);
    const accentColorPink = Color(0xFFE91E63);
    const backgroundColor = Color(0xFFF7F8FC);
    const cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: cardColor,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Navigate back
              },
            ),
          ),
        ),
        title: const Text(
          'Instant Services',
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
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.only(top: 2, right: 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Well & Yield Rewards',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const LiveWellSection(primaryColor: primaryColor, cardColor: cardColor),
              const SizedBox(height: 6),
              SectionTitle(title: 'Quick Actions', onSeeAll: () {}),
              const SizedBox(height: 3),
              const QuickActionCard(
                icon: FontAwesomeIcons.fileMedical,
                iconBgColor: Color(0xFFFFF3E2),
                iconColor: accentColorOrange,
                category: 'Health',
                title: 'Edit Your Policy Details',
                subtitle1: 'Your policy purchased on 27 Feb, 2025 will ',
                subtitle2: 'Expires in 15 Days',
                subtitle2Color: accentColorOrange,
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 8),
              const QuickActionCard(
                icon: FontAwesomeIcons.fileInvoice,
                iconBgColor: Color(0xFFFCE4EC),
                iconColor: accentColorPink,
                category: 'PUC Validity',
                title: 'Register a Claim Details',
                subtitle1: 'Your policy purchased on 27 Feb, 2025 will ',
                subtitle2: 'Expires in 29 Days',
                subtitle2Color: accentColorPink,
                primaryColor: primaryColor,
              ),const SizedBox(height: 8),
              const QuickActionCard(
                icon: FontAwesomeIcons.fileMedical,
                iconBgColor: Color(0xFFFFF3E2),
                iconColor: accentColorOrange,
                category: 'Health',
                title: 'Edit Your Policy Details',
                subtitle1: 'Your policy purchased on 27 Feb, 2025 will ',
                subtitle2: 'Expires in 15 Days',
                subtitle2Color: accentColorOrange,
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 8),
              const QuickActionCard(
                icon: FontAwesomeIcons.fileInvoice,
                iconBgColor: Color(0xFFFCE4EC),
                iconColor: accentColorPink,
                category: 'PUC Validity',
                title: 'Register a Claim Details',
                subtitle1: 'Your policy purchased on 27 Feb, 2025 will ',
                subtitle2: 'Expires in 29 Days',
                subtitle2Color: accentColorPink,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveWellSection extends StatelessWidget {
  const LiveWellSection({
    super.key,
    required this.primaryColor,
    required this.cardColor,
  });

  final Color primaryColor;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 2,
          child: OurAgentsCard(),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: ChatExpertCard(primaryColor: primaryColor),
        ),
      ],
    );
  }
}

class OurAgentsCard extends StatelessWidget {
  const OurAgentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.05)),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFF39C12), size: 24),
              SizedBox(width: 8),
              Text('Our Agents',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Meet your exclusive insurance advisor and get advice',
            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          const StackedAvatars(),
        ],
      ),
    );
  }
}

class StackedAvatars extends StatelessWidget {
  const StackedAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    const double overlap = 25.0;
    final items = [
      'https://randomuser.me/api/portraits/men/32.jpg',
      'https://randomuser.me/api/portraits/women/44.jpg',
      'https://randomuser.me/api/portraits/women/68.jpg',
      'https://randomuser.me/api/portraits/men/39.jpg',
      'https://randomuser.me/api/portraits/women/49.jpg',
      'https://randomuser.me/api/portraits/women/69.jpg',
    ];

    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          ...List.generate(items.length, (index) {
            return Positioned(
              left: index * overlap,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(items[index]),
                ),
              ),
            );
          }),
          Positioned(
            left: items.length * overlap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black87,
              child: const Text(
                '+20',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatExpertCard extends StatelessWidget {
  const ChatExpertCard({super.key, required this.primaryColor});

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 162,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.05)),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: primaryColor,
            child: const Icon(FontAwesomeIcons.solidCommentDots,
                color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          const Text(
            'Chat with expert',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Spacer(),
          Center(
            child: Text(
              'Message Now',
              style: TextStyle(
                  color: primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 9),
        ],
      ),
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
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text(
            'View All',
            style: TextStyle(color: Color(0xFF6A5AE0)),
          ),
        ),
      ],
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String category;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final Color subtitle2Color;
  final Color primaryColor;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.category,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle2Color,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.05)),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FaIcon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
              children: <TextSpan>[
                TextSpan(text: subtitle1),
                TextSpan(
                    text: subtitle2,
                    style: TextStyle(
                        color: subtitle2Color, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RenewNowButton(primaryColor: primaryColor),
        ],
      ),
    );
  }
}

class RenewNowButton extends StatelessWidget {
  const RenewNowButton({super.key, required this.primaryColor});

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.all(0),
        elevation: 5,
        shadowColor: primaryColor.withValues(alpha: 0.5),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: primaryColor,
              child: const Icon(FontAwesomeIcons.rotate, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              'Renew Now',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Spacer(),
            const Icon(FontAwesomeIcons.chevronRight, size: 14),
          ],
        ),
      ),
    );
  }
}