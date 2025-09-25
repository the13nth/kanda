import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper function to convert opacity to an alpha value, as requested.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Models ---

// Enum for referral status
enum ReferralStatus { completed, pending }

// Model for a badge/milestone
class Badge {
  final String name;
  final IconData icon;
  final bool isEarned;

  Badge({required this.name, required this.icon, this.isEarned = false});
}

// Model for a referral history item
class Referral {
  final String name;
  final String imageUrl;
  final ReferralStatus status;
  final String reward;

  Referral({required this.name, required this.imageUrl, required this.status, required this.reward});
}

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Sample Data ---
    final List<Badge> badges = [
      Badge(name: 'Renewal', icon: FontAwesomeIcons.award, isEarned: true),
      Badge(name: 'Referral Pro', icon: FontAwesomeIcons.userGroup, isEarned: true),
      Badge(name: 'Top Earner', icon: FontAwesomeIcons.trophy, isEarned: true),
      Badge(name: 'Early Bird', icon: FontAwesomeIcons.solidClock, isEarned: true),
    ];

    final List<Referral> referrals = [
      Referral(
        name: 'Alex Johnson',
        imageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        status: ReferralStatus.completed,
        reward: '\$50 Cashback',
      ),
      Referral(
        name: 'Maria Garcia',
        imageUrl: 'https://randomuser.me/api/portraits/women/12.jpg',
        status: ReferralStatus.completed,
        reward: '10% Discount',
      ),
      Referral(
        name: 'David Smith',
        imageUrl: 'https://randomuser.me/api/portraits/men/13.jpg',
        status: ReferralStatus.pending,
        reward: '\$50 Cashback',
      ),
      Referral(
        name: 'Jessica Williams',
        imageUrl: 'https://randomuser.me/api/portraits/women/14.jpg',
        status: ReferralStatus.pending,
        reward: '10% Discount',
      ),
      Referral(
        name: 'Chris Brown',
        imageUrl: 'https://randomuser.me/api/portraits/men/15.jpg',
        status: ReferralStatus.completed,
        reward: '500 Points',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Referrals & Rewards'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildReferralCard(context),
            const SizedBox(height: 3),
            buildLoyaltyPointsCard(context),
            const SizedBox(height: 3),
            buildAchievementsSection(context, badges),
            const SizedBox(height: 2),
            buildReferralHistorySection(context, referrals),
          ],
        ),
      ),
    );
  }

  // Card for inviting friends
  Widget buildReferralCard(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FaIcon(FontAwesomeIcons.gift, color: Colors.white, size: 30),
            const SizedBox(height: 16),
            const Text(
              'Invite Friends, Earn Rewards!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 5),
            const Text(
              'Share your code and you\'ll both get a reward when they sign up.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(_alphaFromOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'YOUR-CODE-123',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5),
                  ),
                  Icon(Icons.copy, color: Colors.white, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Colors.black87),
                label: const Text(
                  'Share Your Link',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card for displaying loyalty points
  Widget buildLoyaltyPointsCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber[600], size: 30),
            const SizedBox(width: 16),
            const Expanded(
              child: Text('Loyalty Points', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Text(
              '4,250',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A4DE6)),
            ),
          ],
        ),
      ),
    );
  }

  // Section for gamification badges and milestones
  Widget buildAchievementsSection(BuildContext context, List<Badge> badges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 3.0),
          child: Text('Your Achievements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: badges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return BadgeGridItem(badge: badges[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  // Section for referral history
  Widget buildReferralHistorySection(BuildContext context, List<Referral> referrals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 5.0),
          child: Text('Referral History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: referrals.length,
          itemBuilder: (context, index) {
            return ReferralHistoryItem(referral: referrals[index]);
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
        ),
      ],
    );
  }
}

// Widget for a single badge in the grid
class BadgeGridItem extends StatelessWidget {
  final Badge badge;
  const BadgeGridItem({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final color = badge.isEarned ? Theme.of(context).primaryColor : Colors.grey[400]!;
    final bgColor = badge.isEarned
        ? Theme.of(context).primaryColor.withAlpha(_alphaFromOpacity(0.1))
        : Colors.grey.withAlpha(_alphaFromOpacity(0.1));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: FaIcon(badge.icon, color: color, size: 24),
        ),
        const SizedBox(height: 5),
        Text(
          badge.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badge.isEarned ? Colors.black87 : Colors.grey[600]),
        ),
      ],
    );
  }
}

// Widget for a single item in the referral history list
class ReferralHistoryItem extends StatelessWidget {
  final Referral referral;
  const ReferralHistoryItem({super.key, required this.referral});

  @override
  Widget build(BuildContext context) {
    final statusColor = referral.status == ReferralStatus.completed ? Colors.green : Colors.orange;
    final statusText = referral.status == ReferralStatus.completed ? 'Completed' : 'Pending';

    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        leading: CircleAvatar(radius: 25, backgroundImage: NetworkImage(referral.imageUrl)),
        title: Text(referral.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(referral.reward, style: const TextStyle(color: Colors.black54)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(_alphaFromOpacity(0.15)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
