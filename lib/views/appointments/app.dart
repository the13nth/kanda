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
      title: 'Insurance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A4E69)),
        useMaterial3: true,
      ),
      home: const Appointments(),
    );
  }
}

// --- DATA MODELS ---
// Model for Insurance Plans
class InsurancePlan {
  final String companyName;
  final String planName;
  final String logoUrl;
  final String premium;
  final String coverage;
  final String cashlessHospitals;

  InsurancePlan({
    required this.companyName,
    required this.planName,
    required this.logoUrl,
    required this.premium,
    required this.coverage,
    required this.cashlessHospitals,
  });
}

// Model for Insurance Advisors
class InsuranceAdvisor {
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;

  InsuranceAdvisor({
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
  });
}

// --- HELPER FUNCTION ---
/// Converts a double opacity (0.0 - 1.0) to an int alpha value (0 - 255).
int alphaFromOpacity(double opacity) {
  final clampedOpacity = opacity.clamp(0.0, 1.0);
  return (clampedOpacity * 255).round();
}

// --- ENUM FOR VIEW MANAGEMENT ---
// This enum helps manage which "screen" is currently visible.
enum AppView { mainMenu, comparison, booking, quote }

// --- SINGLE CLASS FOR ALL SCREENS ---
class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => AppointmentsState();
}

class AppointmentsState extends State<Appointments> {
  // --- STATE MANAGEMENT ---
  // Controls which view is currently displayed
  AppView _currentView = AppView.mainMenu;

  // State specific to the Quote screen
  String? _selectedInsuranceType = 'Health Insurance';
  final _ageController = TextEditingController();
  double _coverageAmount = 500000;
  String? _estimatedPremium;

  final List<String> _insuranceTypes = [
    'Health Insurance',
    'Car Insurance',
    'Life Insurance',
    'Home Insurance',
  ];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  // --- NAVIGATION LOGIC ---
  /// Updates the state to show a different view
  void _navigateTo(AppView view) {
    // Reset quote form when leaving the quote screen
    if (_currentView == AppView.quote) {
      _resetQuoteForm();
    }
    setState(() {
      _currentView = view;
    });
  }

  /// Builds the appropriate UI based on the current view state
  Widget _buildCurrentView() {
    switch (_currentView) {
      case AppView.comparison:
        return _buildComparisonView();
      case AppView.booking:
        return _buildBookingView();
      case AppView.quote:
        return _buildQuoteView();
      case AppView.mainMenu:
        return _buildMainMenuView();
    }
  }

  // --- MAIN BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    // The Scaffold body changes based on the _currentView state
    return Scaffold(body: _buildCurrentView());
  }

  // --- VIEW BUILDERS (Each builder represents a screen) ---

  // 1. Main Menu View
  Widget _buildMainMenuView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insurance Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Find the best insurance plan for you.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            _buildFeatureCard(
              icon: FontAwesomeIcons.shieldHalved,
              title: "Insurance Purchase & Comparison",
              subtitle: "Compare and buy plans from top insurers.",
              color: Colors.blueAccent,
              onTap: () => _navigateTo(AppView.comparison),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: FontAwesomeIcons.calendarCheck,
              title: "Appointments & Consultation",
              subtitle: "Book a consultation with our expert advisors.",
              color: Colors.green,
              onTap: () => _navigateTo(AppView.booking),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: FontAwesomeIcons.fileInvoiceDollar,
              title: "Instant Quote Generation",
              subtitle: "Get a quick quote for your insurance needs.",
              color: Colors.orange,
              onTap: () => _navigateTo(AppView.quote),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Insurance Purchase & Comparison View
  Widget _buildComparisonView() {
    final List<InsurancePlan> dummyPlans = [
      InsurancePlan(
        companyName: 'SecureLife',
        planName: 'Health Guardian Plus',
        logoUrl: 'https://picsum.photos/seed/logo1/100/100',
        premium: '₹1,250/month',
        coverage: '₹10 Lakhs',
        cashlessHospitals: '7500+',
      ),
      InsurancePlan(
        companyName: 'Future General',
        planName: 'Total Protect',
        logoUrl: 'https://picsum.photos/seed/logo2/100/100',
        premium: '₹980/month',
        coverage: '₹5 Lakhs',
        cashlessHospitals: '5000+',
      ),
      InsurancePlan(
        companyName: 'Max Bupa',
        planName: 'Family First Gold',
        logoUrl: 'https://picsum.photos/seed/logo3/100/100',
        premium: '₹1,800/month',
        coverage: '₹20 Lakhs',
        cashlessHospitals: '9000+',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _navigateTo(AppView.mainMenu),
        ),
        title: const Text('Compare Insurance Plans'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyPlans.length,
        itemBuilder: (context, index) {
          final plan = dummyPlans[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 5,
            shadowColor: Colors.black.withAlpha(alphaFromOpacity(0.08)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          plan.logoUrl,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          plan.planName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildComparisonFeatureRow(
                    FontAwesomeIcons.umbrella,
                    'Coverage',
                    plan.coverage,
                  ),
                  const SizedBox(height: 10),
                  _buildComparisonFeatureRow(
                    FontAwesomeIcons.hospital,
                    'Cashless Hospitals',
                    plan.cashlessHospitals,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Premium',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            plan.premium,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          /* Buy Now Logic */
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Buy Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 3. Appointments & Consultation Booking View
  Widget _buildBookingView() {
    final List<InsuranceAdvisor> dummyAdvisors = [
      InsuranceAdvisor(
        name: 'Johnathan Doe',
        specialization: 'Health Insurance Specialist',
        imageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        rating: 4.8,
      ),
      InsuranceAdvisor(
        name: 'Jane Smith',
        specialization: 'Auto & Property Insurance',
        imageUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
        rating: 4.9,
      ),
      InsuranceAdvisor(
        name: 'Robert Brown',
        specialization: 'Life & Investment Plans',
        imageUrl: 'https://randomuser.me/api/portraits/men/33.jpg',
        rating: 4.7,
      ),
      InsuranceAdvisor(
        name: 'Emily White',
        specialization: 'Family Insurance Advisor',
        imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        rating: 5.0,
      ),
      InsuranceAdvisor(
        name: 'Johnathan Doe',
        specialization: 'Health Insurance Specialist',
        imageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        rating: 4.8,
      ),
      InsuranceAdvisor(
        name: 'Jane Smith',
        specialization: 'Auto & Property Insurance',
        imageUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
        rating: 4.9,
      ),
      InsuranceAdvisor(
        name: 'Robert Brown',
        specialization: 'Life & Investment Plans',
        imageUrl: 'https://randomuser.me/api/portraits/men/33.jpg',
        rating: 4.7,
      ),
      InsuranceAdvisor(
        name: 'Emily White',
        specialization: 'Family Insurance Advisor',
        imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        rating: 5.0,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _navigateTo(AppView.mainMenu),
        ),
        title: const Text('Book a Consultation'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(13),
        itemCount: dummyAdvisors.length,
        itemBuilder: (context, index) {
          final advisor = dummyAdvisors[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 9),
            elevation: 4.0,
            shadowColor: Colors.black.withAlpha(alphaFromOpacity(0.1)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(advisor.imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advisor.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          advisor.specialization,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[600],
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              advisor.rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      /* Booking Logic */
                    },
                    icon: const FaIcon(FontAwesomeIcons.solidCalendarPlus),
                    color: Theme.of(context).primaryColor,
                    iconSize: 28,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 4. Instant Quote Generation View
  Widget _buildQuoteView() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _navigateTo(AppView.mainMenu),
        ),
        title: const Text('Get an Instant Quote'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedInsuranceType,
              decoration: InputDecoration(
                labelText: 'Type of Insurance',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _insuranceTypes
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) =>
                  setState(() => _selectedInsuranceType = newValue),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Your Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desired Coverage: ₹${_coverageAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Slider(
                  value: _coverageAmount,
                  min: 100000,
                  max: 5000000,
                  divisions: 49,
                  label: '₹${_coverageAmount.round()}',
                  onChanged: (double value) =>
                      setState(() => _coverageAmount = value),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _getQuote,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Get My Quote', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
            if (_estimatedPremium != null) _buildQuoteResult(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  void _getQuote() {
    if (_ageController.text.isEmpty) return;
    final age = int.tryParse(_ageController.text) ?? 0;
    double premium = (_coverageAmount / 1000) + (age * 10);
    if (_selectedInsuranceType == 'Car Insurance') {
      premium *= 1.5;
    } else if (_selectedInsuranceType == 'Life Insurance') {
      premium *= 2.0;
    }
    setState(() {
      _estimatedPremium = '₹${premium.toStringAsFixed(0)} / year';
    });
    FocusScope.of(context).unfocus();
  }

  void _resetQuoteForm() {
    setState(() {
      _ageController.clear();
      _estimatedPremium = null;
      _coverageAmount = 500000;
      _selectedInsuranceType = 'Health Insurance';
    });
  }

  Widget _buildQuoteResult() {
    return Card(
      color: Colors.deepPurple.withAlpha(alphaFromOpacity(0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Estimated Premium',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _estimatedPremium!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This is an estimate. Actual premium may vary.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepPurple.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withValues(alpha: 0.1),
                child: FaIcon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonFeatureRow(IconData icon, String title, String value) {
    return Row(
      children: [
        FaIcon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text('$title: ', style: TextStyle(color: Colors.grey[700])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
