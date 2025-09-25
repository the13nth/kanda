import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';
import '../../widgets/drawer_widget.dart';
import '../../services/profile_service.dart';
import '../../services/vehicle_service.dart';
import '../../services/policy_service.dart';
import '../../models/vehicle.dart';
import '../../models/policy.dart';
import '../notifications/no.dart';

// As requested, a helper function to convert opacity (0.0-1.0) to an alpha value (0-255).
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  List<Vehicle> _vehicles = [];
  List<Policy> _policies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final name = await ProfileService.getUserFullName();
      final vehicles = await VehicleService.getUserVehicles();
      final policies = await PolicyService.getUserPolicies();

      if (mounted) {
        setState(() {
          userName = name;
          _vehicles = vehicles;
          _policies = policies;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = 'User';
          _vehicles = [];
          _policies = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors for easy reuse and modification
    const primaryColor = Color(0xFF6A5AE0);
    const _ = Color(0xFF5A5A5A);
    const _ = Color(0xFFB0B0B0);
    const backgroundColor = Color(0xFFF7F7F7);

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(FontAwesomeIcons.bars),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello ${userName ?? 'User'}!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Complete your profile easily',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Notificationsssss()),
              );
            },
            child: Stack(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.bell,
                    color: Colors.black54,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                // --- Search Bar ---
                CarInsuranceCard(
                  primaryColor: primaryColor,
                  vehicles: _vehicles,
                  policies: _policies,
                  isLoading: _isLoading,
                  userName: userName,
                ),
                const SizedBox(height: 8),
                // --- Kanda Assist Services Section ---
                SectionTitle(title: 'Kanda Assist Services', onSeeAll: () {}),
                const SizedBox(height: 2),
                HealthWellnessCategories(),
                const SizedBox(height: 4),
                // --- Quick Actions Section ---
                SectionTitle(title: 'Quick Actions', onSeeAll: () {}),
                const SizedBox(height: 1),
                QuickActionsList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            children: [
              // Circular Progress Indicator for the profile completion
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: 0.6, // 60%
                  strokeWidth: 4,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6A5AE0),
                  ),
                ),
              ),
              // User's profile picture
              const Center(
                child: CircleAvatar(
                  radius: 21,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/11.jpg',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello Thomson!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Complete your profile easily',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        // Notification Icon with a dot
        Stack(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(FontAwesomeIcons.bell, color: Colors.black54),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CarInsuranceCard extends StatelessWidget {
  final Color primaryColor;
  final List<Vehicle> vehicles;
  final List<Policy> policies;
  final bool isLoading;
  final String? userName;

  const CarInsuranceCard({
    super.key,
    required this.primaryColor,
    required this.vehicles,
    required this.policies,
    required this.isLoading,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    // Get the first vehicle and its active policy
    final Vehicle? primaryVehicle = vehicles.isNotEmpty ? vehicles.first : null;
    final Policy? activePolicy = policies.isNotEmpty
        ? policies.firstWhere(
            (policy) =>
                policy.status == 'active' &&
                (primaryVehicle == null ||
                    policy.vehicleId == primaryVehicle.id),
            orElse: () => policies.first,
          )
        : null;

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (vehicles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(FontAwesomeIcons.car, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            const Text(
              'No vehicles found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Add a vehicle to get started',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-vehicle');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Add Vehicle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  FontAwesomeIcons.car,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Car Insurance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    activePolicy?.policyType
                            .replaceAll('_', ' ')
                            .toUpperCase() ??
                        'No Policy',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.arrowRight,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
          // Keep the existing car image as default
          Image.network(
            'https://www.hyundai.com/content/dam/hyundai/in/en/data/find-a-car/i20/Highlights/pc/i20_Modelpc.png',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                FontAwesomeIcons.car,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn(title: 'Policy holder', value: userName ?? 'User'),
              InfoColumn(
                title: primaryVehicle != null
                    ? '${primaryVehicle.year} ${primaryVehicle.make} ${primaryVehicle.model}'
                    : 'No Vehicle',
                value: primaryVehicle?.licensePlate ?? 'N/A',
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InfoColumn(
                title: 'Policy validity',
                value: activePolicy != null
                    ? '${activePolicy.endDate.day}/${activePolicy.endDate.month}/${activePolicy.endDate.year}'
                    : 'No active policy',
              ),
              ElevatedButton(
                onPressed: activePolicy != null
                    ? () {}
                    : () {
                        Navigator.pushNamed(context, '/add-policy');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  activePolicy != null ? 'Renew Now' : 'Get Policy',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final CrossAxisAlignment crossAxisAlignment;

  const InfoColumn({
    super.key,
    required this.title,
    required this.value,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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

class HealthWellnessCategories extends StatelessWidget {
  const HealthWellnessCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryCard(
          label: 'Car Insurance',
          icon: FontAwesomeIcons.car,
          color: Color(0xFFE8E6FC),
          iconColor: Color(0xFF6A5AE0),
        ),
        CategoryCard(
          label: 'Roadside Assistance',
          icon: FontAwesomeIcons.screwdriverWrench,
          color: Color(0xFFFFF3E2),
          iconColor: Color(0xFFF7B15C),
        ),
        CategoryCard(
          label: 'Marketplace',
          icon: FontAwesomeIcons.store,
          color: Color(0xFFE2F6FE),
          iconColor: Color(0xFF4AC4F3),
        ),
        CategoryCard(
          label: 'Tips',
          icon: FontAwesomeIcons.lightbulb,
          color: Color(0xFFFEE8E8),
          iconColor: Color(0xFFF36A6A),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const CategoryCard({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: FaIcon(icon, size: 20, color: iconColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionsList extends StatelessWidget {
  const QuickActionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuickActionItem(
          title: 'Register a Claim',
          subtitle: 'Track & submit insurance claims',
          amount: '+\$234.00',
          icon: FontAwesomeIcons.fileInvoice,
          iconBgColor: Color(0xFFFFF3E2),
          iconColor: Color(0xFFF7B15C),
          onTap: () {
            Navigator.pushNamed(context, '/claim-form');
          },
        ),
        SizedBox(height: 2),
        QuickActionItem(
          title: 'Find Local Services',
          subtitle: 'Nearby hospitals and garages',
          amount: '+\$134.00',
          icon: FontAwesomeIcons.locationDot,
          iconBgColor: Color(0xFFE8E6FC),
          iconColor: Color(0xFF6A5AE0),
        ),
        SizedBox(height: 2),
        QuickActionItem(
          title: 'Renew Insurance',
          subtitle: 'Policy renewal reminders',
          amount: '\$0.00',
          icon: FontAwesomeIcons.clockRotateLeft,
          iconBgColor: Color(0xFFE2F7F3),
          iconColor: Color(0xFF00BFA6),
        ),
        SizedBox(height: 2),
        QuickActionItem(
          title: 'Go to Marketplace',
          subtitle: 'Browse services and products',
          amount: '',
          icon: FontAwesomeIcons.store,
          iconBgColor: Color(0xFFE2F6FE),
          iconColor: Color(0xFF4AC4F3),
          onTap: () {
            Navigator.pushNamed(context, '/marketplace');
          },
        ),
        SizedBox(height: 2),
        QuickActionItem(
          title: 'Contact Support',
          subtitle: '24/7 help & claim queries',
          amount: '',
          icon: FontAwesomeIcons.headset,
          iconBgColor: Color(0xFFFFEBF0),
          iconColor: Color(0xFFE5396B),
        ),
      ],
    );
  }
}

class QuickActionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickActionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withAlpha(_alphaFromOpacity(0.04)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FaIcon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF6A5AE0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
