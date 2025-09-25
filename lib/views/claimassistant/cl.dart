import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Helper function to convert opacity to an alpha value for colors.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Models (for structured data) ---
class Policy {
  final String name;
  final String date;
  Policy({required this.name, required this.date});
}

// --- Main Screen Widget ---
class ClaimAssistanceScreen extends StatelessWidget {
  ClaimAssistanceScreen({super.key});

  // Mock data for policies
  final List<Policy> policies = [
    Policy(name: 'Similique sunt in culpa insurance', date: '14 March 2021'),
    Policy(name: 'Deserunt mollitia animi insurance', date: '18 March 2021'),
    Policy(name: 'Corporis suscipit laboriosam plan', date: '25 April 2021'),
    Policy(name: 'Voluptatem quia voluptas coverage', date: '02 June 2021'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F5FF), // Light blue background
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Claim Assistance',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Let\'s figure out how we can still help you.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.blueGrey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(_alphaFromOpacity(0.05)),
                      blurRadius: 20,
                      spreadRadius: -10,
                      offset: const Offset(0, -10),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PlanToggleButtons(),
                        const SizedBox(height: 24),
                        SectionTitle(title: 'All Policy Details'),
                        PolicyDetailsList(policies: policies),
                        const SizedBox(height: 24),
                        const ActionLinks(),
                        const SizedBox(height: 30),
                        SectionTitle(title: 'Reviews'),
                        const ReviewsCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Sectional and Reusable Widgets ---

class PlanToggleButtons extends StatefulWidget {
  const PlanToggleButtons({super.key});

  @override
  State<PlanToggleButtons> createState() => PlanToggleButtonsState();
}

class PlanToggleButtonsState extends State<PlanToggleButtons> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF007BFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: ToggleButton(
              text: 'Your plans',
              isSelected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
          ),
          Expanded(
            child: ToggleButton(
              text: 'Track Claims',
              isSelected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF007BFF) : Colors.white,
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2C3E50),
        ),
      ),
    );
  }
}

class PolicyDetailsList extends StatelessWidget {
  final List<Policy> policies;
  const PolicyDetailsList({super.key, required this.policies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: policies.map((policy) {
        return Column(
          children: [
            PolicyListItem(policy: policy),
            if (policies.last != policy)
              Divider(color: Colors.grey[200], height: 1),
          ],
        );
      }).toList(),
    );
  }
}

class PolicyListItem extends StatelessWidget {
  final Policy policy;
  const PolicyListItem({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF34495E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policy.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2C3E50),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  policy.date,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FaIcon(
            FontAwesomeIcons.download,
            size: 20,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}

class ActionLinks extends StatelessWidget {
  const ActionLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionLinkCard(
          icon: FontAwesomeIcons.solidUser,
          text: 'Contact an insurer',
          iconColor: const Color(0xFF8E44AD),
          backgroundColor: const Color(0xFFF3E5F5),
        ),
        const SizedBox(height: 12),
        ActionLinkCard(
          icon: FontAwesomeIcons.fileInvoice,
          text: 'Know how to file a claim',
          iconColor: const Color(0xFF27AE60),
          backgroundColor: const Color(0xFFE8F5E9),
        ),
      ],
    );
  }
}

class ActionLinkCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color backgroundColor;

  const ActionLinkCard({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: const Color(0xFF2C3E50),
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[500]),
        ],
      ),
    );
  }
}

class ReviewsCard extends StatelessWidget {
  const ReviewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: ReviewDetail(
                  icon: FontAwesomeIcons.google,
                  iconColor: Colors.red,
                  rating: '4.7 / 5',
                  starCount: 4.7,
                  reviewCount: '15,000+ Reviews',
                ),
              ),
              SizedBox(
                height: 60,
                child: VerticalDivider(
                  color: Color(0xFFE0E0E0),
                  thickness: 1,
                ),
              ),
              Expanded(
                child: ReviewDetail(
                  icon: FontAwesomeIcons.facebookF,
                  iconColor: Colors.blue,
                  rating: '4.9 / 5',
                  starCount: 4.9,
                  reviewCount: '16,300+ Reviews',
                ),
              ),
            ],
          ),
          Divider(height: 30, color: Colors.grey[200]),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.award, color: Colors.blue[700], size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Awarded Asia\'s General Insurance Company 2020, 2021.',
                  style: GoogleFonts.poppins(
                    color: Colors.blueGrey[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ReviewDetail extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String rating;
  final double starCount;
  final String reviewCount;

  const ReviewDetail({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.rating,
    required this.starCount,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: iconColor, size: 22),
            const SizedBox(width: 12),
            Text(
              rating,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StarRating(rating: starCount),
        const SizedBox(height: 8),
        Text(
          reviewCount,
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final Color color;

  const StarRating({
    super.key,
    this.rating = 0.0,
    this.starCount = 5,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        Icon icon;
        if (index >= rating) {
          icon = Icon(Icons.star_border, color: color, size: 18);
        } else if (index > rating - 1 && index < rating) {
          icon = Icon(Icons.star_half, color: color, size: 18);
        } else {
          icon = Icon(Icons.star, color: color, size: 18);
        }
        return icon;
      }),
    );
  }
}