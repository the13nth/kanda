import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

// Helper function to convert opacity to an alpha value, as requested.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

void main() {
  runApp(const InsuranceApp());
}

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6A5AE0), // A modern purple
        scaffoldBackgroundColor: const Color(0xFFF8F8FA),
        fontFamily: 'Poppins', // A modern font, assuming it's added
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F8FA),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      home: const PolicyPortfolioScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data model for a policy plan
class PolicyPlan {
  final IconData icon;
  final String name;
  final int activeCount;

  PolicyPlan({
    required this.icon,
    required this.name,
    required this.activeCount,
  });
}

class PolicyPortfolioScreen extends StatelessWidget {
  const PolicyPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of policy plans data
    final List<PolicyPlan> policyPlans = [
      PolicyPlan(
          icon: FontAwesomeIcons.heartPulse,
          name: 'Health Protection Plans',
          activeCount: 1),
      PolicyPlan(
          icon: FontAwesomeIcons.lock, name: 'Savings Plans', activeCount: 3),
      PolicyPlan(
          icon: FontAwesomeIcons.umbrella,
          name: 'Life Protection Plans',
          activeCount: 1),
      PolicyPlan(
          icon: FontAwesomeIcons.wallet,
          name: 'Retirement Income Plans',
          activeCount: 2),
      PolicyPlan(
          icon: FontAwesomeIcons.lightbulb,
          name: 'Wealth (ULIP) Plans',
          activeCount: 0),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.apps_rounded),
          onPressed: () {},
        ),
        title: const Text('Policy Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTotalRewardsCard(context),
              const SizedBox(height: 24),
              ...policyPlans.map((plan) => buildPolicyPlanCard(plan, context)),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the top "Total Rewards" card with the custom graphic.
  Widget buildTotalRewardsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF8A77F5),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A77F5).withAlpha(_alphaFromOpacity(0.3)),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background graphic painted using a CustomPainter
          Positioned.fill(
            top: 60, // Position the graphic below the main text
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: CustomPaint(
                painter: RewardsBackgroundPainter(),
              ),
            ),
          ),

          // Main content on the card
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Rewards',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '\$6410',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100), // Space for the graphic
            ],
          ),

          // Overlayed text and circles positioned on the graphic
          const Positioned(
            bottom: 40,
            child: Text(
              'Return on\nPolicies',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 20,
            child: buildPolicyAbbreviationCircle('SP'),
          ),
          Positioned(
            top: 110,
            right: 50,
            child: buildPolicyAbbreviationCircle('LP'),
          ),
          Positioned(
            top: 155,
            right: 15,
            child: buildPolicyAbbreviationCircle('HP'),
          ),
        ],
      ),
    );
  }

  /// Helper for the small white circles (SP, LP, HP).
  Widget buildPolicyAbbreviationCircle(String text) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF8A77F5),
          ),
        ),
      ),
    );
  }

  /// Builds the individual policy plan list items using white cards.
  Widget buildPolicyPlanCard(PolicyPlan plan, BuildContext context) {
    final bool hasActivePlan = plan.activeCount > 0;

    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withAlpha(_alphaFromOpacity(0.1)),
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(_alphaFromOpacity(0.1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FaIcon(
                plan.icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${plan.activeCount} Active',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: hasActivePlan ? Colors.grey[200] : Theme.of(context).primaryColor,
                foregroundColor: hasActivePlan ? Colors.black87 : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                elevation: 0,
              ),
              child: Text(hasActivePlan ? 'See Details' : 'See Recommended'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the background graphic in the rewards card.
/// This draws the concentric arcs and the faint sun rays.
class RewardsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 1.5);

    // Define paints for each colored arc
    final paints = [
      Paint()..color = const Color(0xFF7A65E6),
      Paint()..color = const Color(0xFF9F8CF0),
      Paint()..color = const Color(0xFFC9A8E8),
      Paint()..color = const Color(0xFFEBCDA8),
      Paint()..color = const Color(0xFFFFE07A),
    ];
    final radii = [1.5, 1.3, 1.1, 0.9, 0.7];

    // Draw concentric arcs from largest to smallest
    for (int i = 0; i < paints.length; i++) {
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: size.height * radii[i]),
          math.pi, math.pi, true, paints[i]);
    }

    // Draw sun rays
    final rayPaint = Paint()
      ..color = Colors.white.withAlpha(_alphaFromOpacity(0.1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const rayCount = 12;
    const angle = math.pi / rayCount;

    for (int i = 0; i < rayCount + 1; i++) {
      final x = center.dx + size.height * 1.6 * math.cos(math.pi + i * angle);
      final y = center.dy + size.height * 1.6 * math.sin(math.pi + i * angle);
      canvas.drawLine(center, Offset(x, y), rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}