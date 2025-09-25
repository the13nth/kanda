import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ===========================================================================
// Helper Function (As requested)
// ===========================================================================

/// Converts an opacity value (0.0 to 1.0) to an alpha value (0 to 255).
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// ===========================================================================
// App Entry Point: main.dart
// ===========================================================================


// ===========================================================================
// App Colors
// ===========================================================================

class AppColors {
  static const Color primary = Color(0xFF0D47A1);
  static const Color secondary = Color(0xFF29B6F6);
  static const Color accent = Color(0xFFFFC107);
  static const Color textDark = Color(0xFF1E2126);
  static const Color textLight = Color(0xFF6E747A);
  static const Color white = Colors.white;
  static const Color background = Color(0xFFF4F7FC);
}

// ===========================================================================
// Data Models
// ===========================================================================

class InsuranceCategory {
  final String title;
  final String imageUrl;
  final IconData icon;
  final Color color;

  InsuranceCategory({
    required this.title,
    required this.imageUrl,
    required this.icon,
    required this.color,
  });
}

class InsurancePlan {
  final String companyName;
  final String companyLogoUrl;
  final String planName;
  final double monthlyPremium;
  final double coverageAmount;
  final List<String> keyFeatures;
  final List<Review> reviews;

  InsurancePlan({
    required this.companyName,
    required this.companyLogoUrl,
    required this.planName,
    required this.monthlyPremium,
    required this.coverageAmount,
    required this.keyFeatures,
    required this.reviews,
  });
}

class Review {
  final String reviewerName;
  final String reviewerAvatarUrl;
  final double rating;
  final String comment;

  Review({
    required this.reviewerName,
    required this.reviewerAvatarUrl,
    required this.rating,
    required this.comment,
  });
}

// ===========================================================================
// Dummy Data with Unsplash Images
// ===========================================================================

final List<InsuranceCategory> dummyCategories = [
  InsuranceCategory(
    title: 'Health',
    imageUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    icon: FontAwesomeIcons.heartPulse,
    color: Color(0xFFE57373).withAlpha(_alphaFromOpacity(0.2)),
  ),
  InsuranceCategory(
    title: 'Motor',
    imageUrl: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    icon: FontAwesomeIcons.car,
    color: Color(0xFF64B5F6).withAlpha(_alphaFromOpacity(0.2)),
  ),
  InsuranceCategory(
    title: 'Travel',
    imageUrl: 'https://images.unsplash.com/photo-1503220317375-aaad61436b1b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    icon: FontAwesomeIcons.planeDeparture,
    color: Color(0xFF81C784).withAlpha(_alphaFromOpacity(0.2)),
  ),
  InsuranceCategory(
    title: 'Life',
    imageUrl: 'https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    icon: FontAwesomeIcons.umbrella,
    color: Color(0xFFFFD54F).withAlpha(_alphaFromOpacity(0.2)),
  ),
];

final List<InsurancePlan> dummyHealthPlans = [
  InsurancePlan(
    companyName: 'SecureHealth',
    companyLogoUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    planName: 'Comprehensive Care',
    monthlyPremium: 45.50,
    coverageAmount: 500000,
    keyFeatures: ['100% Bill Coverage', '5000+ Hospitals', 'No Room Rent Limit'],
    reviews: [
      Review(
        reviewerName: 'John Doe',
        reviewerAvatarUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        rating: 4.5,
        comment: 'Great plan with excellent hospital coverage.',
      ),
      Review(
        reviewerName: 'Jane Smith',
        reviewerAvatarUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
        rating: 5.0,
        comment: 'Easy claim process. Highly recommended!',
      ),
    ],
  ),
  InsurancePlan(
    companyName: 'LifeGuard',
    companyLogoUrl: 'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    planName: 'Family First',
    monthlyPremium: 65.00,
    coverageAmount: 1000000,
    keyFeatures: ['Covers 4 members', 'Maternity Benefits', 'Free Health Checkups'],
    reviews: [
      Review(
        reviewerName: 'Peter Jones',
        reviewerAvatarUrl: 'https://randomuser.me/api/portraits/men/33.jpg',
        rating: 4.0,
        comment: 'Good family plan, but the premium is a bit high.',
      ),
    ],
  ),
  InsurancePlan(
    companyName: 'MediTrust',
    companyLogoUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
    planName: 'Tax Saver Pro',
    monthlyPremium: 38.99,
    coverageAmount: 300000,
    keyFeatures: ['Tax Benefits', 'Daily Hospital Cash', 'OPD Cover'],
    reviews: [
      Review(
        reviewerName: 'Susan Williams',
        reviewerAvatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        rating: 4.8,
        comment: 'Perfect for saving tax and getting good coverage.',
      ),
    ],
  ),
];

// ===========================================================================
// Screen 1: Home Screen
// ===========================================================================

class InsurancePurchaseScreen extends StatelessWidget {
  const InsurancePurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              Text(
                'Browse Plans',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              _buildCategoryGrid(context),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Health Plans',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ComparisonScreen(plans: dummyHealthPlans)));
                    },
                    child: Text('Compare All'),
                  )
                ],
              ),
              const SizedBox(height: 10),
              _buildPopularPlansList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Alex!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Find the best insurance plan for you.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/85.jpg'),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.9,
      ),
      itemCount: dummyCategories.length,
      itemBuilder: (context, index) {
        final category = dummyCategories[index];
        return CategoryCard(category: category);
      },
    );
  }

  Widget _buildPopularPlansList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dummyHealthPlans.length,
      itemBuilder: (context, index) {
        final plan = dummyHealthPlans[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: PlanCard(
            plan: plan,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlanDetailsScreen(plan: plan)),
              );
            },
          ),
        );
      },
    );
  }
}

// ===========================================================================
// Screen 2: Plan Details Screen
// ===========================================================================

class PlanDetailsScreen extends StatelessWidget {
  final InsurancePlan plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlanHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('Key Features'),
            _buildKeyFeatures(),
            const SizedBox(height: 24),
            _buildSectionTitle('Customer Reviews'),
            _buildReviewsList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildQuoteButton(context),
    );
  }

  Widget _buildPlanHeader() {
    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(plan.companyLogoUrl, width: 40, height: 40),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.companyName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    Text(
                      plan.planName,
                      style: TextStyle(fontSize: 14, color: AppColors.textLight),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderInfo('Premium', '\$${plan.monthlyPremium.toStringAsFixed(2)}/mo'),
                _buildHeaderInfo('Coverage', '\$${(plan.coverageAmount / 1000).toStringAsFixed(0)}K'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: AppColors.textLight, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
    );
  }

  Widget _buildKeyFeatures() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: plan.keyFeatures.map((feature) => Chip(
        avatar: Icon(FontAwesomeIcons.circleCheck, color: AppColors.secondary, size: 16),
        label: Text(feature),
        backgroundColor: AppColors.secondary.withAlpha(_alphaFromOpacity(0.1)),
        labelStyle: TextStyle(color: AppColors.secondary.withBlue(100), fontWeight: FontWeight.w500),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      )).toList(),
    );
  }

  Widget _buildReviewsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: plan.reviews.length,
      separatorBuilder: (context, index) => Divider(height: 24),
      itemBuilder: (context, index) {
        final review = plan.reviews[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(review.reviewerAvatarUrl),
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(review.reviewerName, style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.solidStar, color: AppColors.accent, size: 14),
                          const SizedBox(width: 4),
                          Text(review.rating.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(review.comment, style: TextStyle(color: AppColors.textLight)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuoteButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: AppColors.white,
      child: ElevatedButton.icon(
        icon: Icon(FontAwesomeIcons.fileInvoiceDollar, color: AppColors.white),
        label: Text('Get Instant Quote', style: TextStyle(fontSize: 18, color: AppColors.white)),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your quote request has been submitted!'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Screen 3: Comparison Screen
// ===========================================================================

class ComparisonScreen extends StatelessWidget {
  final List<InsurancePlan> plans;

  const ComparisonScreen({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    final allFeatures = plans.expand((p) => p.keyFeatures).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Plans'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            headingRowHeight: 120, // <-- ADD THIS LINE
            columnSpacing: 50.0,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(12)
            ),
            columns: [
              DataColumn(label: Text('Feature', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              ...plans.map((plan) => DataColumn(label: _buildPlanHeaderCell(plan))),
            ],
            rows: [
              _buildDataRow('Premium', plans.map((p) => '\$${p.monthlyPremium.toStringAsFixed(2)}/mo').toList()),
              _buildDataRow('Coverage', plans.map((p) => '\$${(p.coverageAmount/1000).toStringAsFixed(0)}K').toList()),
              ...allFeatures.map((feature) {
                return _buildFeatureRow(feature, plans);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanHeaderCell(InsurancePlan plan) {
    return Column(
      children: [
        Image.network(plan.companyLogoUrl, width: 30, height: 30),
        SizedBox(height: 4),
        Text(plan.planName, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: EdgeInsets.symmetric(horizontal: 20)
          ),
          child: Text('Select', style: TextStyle(color: AppColors.white)),
        )
      ],
    );
  }

  DataRow _buildDataRow(String title, List<String> values) {
    return DataRow(
      cells: [
        DataCell(Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textLight))),
        ...values.map((value) => DataCell(Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)))),
      ],
    );
  }

  DataRow _buildFeatureRow(String feature, List<InsurancePlan> plans) {
    return DataRow(
        cells: [
          DataCell(Text(feature, style: TextStyle(color: AppColors.textLight))),
          ...plans.map((plan) {
            final hasFeature = plan.keyFeatures.contains(feature);
            return DataCell(
                Center(
                  child: hasFeature
                      ? Icon(FontAwesomeIcons.solidCircleCheck, color: Colors.green, size: 20)
                      : Icon(FontAwesomeIcons.solidCircleXmark, color: Colors.red.shade300, size: 20),
                )
            );
          }),
        ]
    );
  }
}

// ===========================================================================
// Reusable Widgets
// ===========================================================================

class CategoryCard extends StatelessWidget {
  final InsuranceCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ComparisonScreen(plans: dummyHealthPlans)));
      },
      child: Card(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: category.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(category.icon, color: category.color.withRed(100).withBlue(100), size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'View Plans',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final InsurancePlan plan;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(plan.companyLogoUrl, width: 35, height: 35),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      plan.planName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textLight, size: 18),
                ],
              ),
              Divider(height: 24, thickness: 1, color: Colors.grey.withAlpha(_alphaFromOpacity(0.1))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('Premium', '\$${plan.monthlyPremium.toStringAsFixed(2)}/mo', CrossAxisAlignment.start),
                  _buildInfoColumn('Coverage', '\$${(plan.coverageAmount / 1000).toStringAsFixed(0)}K', CrossAxisAlignment.end),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: AppColors.textLight),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}