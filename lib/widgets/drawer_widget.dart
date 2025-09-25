import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../views/profile/user_profile.dart';
import '../views/vehicles/add_vehicle.dart';
import '../views/policies/add_policy.dart';

import '../views/AiChatbot/ai.dart';
import '../views/accidentinsurance/ac.dart';
import '../views/aiclaimprocess/ai.dart';
import '../views/aifeedback/ai.dart';
import '../views/aifinancialadvisory/ai.dart';
import '../views/aipolicy/ai.dart';
import '../views/airiskassisment/ai.dart';
import '../views/aisalesmarketing/ai.dart';
import '../views/analytics/an.dart';
import '../views/appointments/app.dart';
import '../views/benefits/b.dart';
import '../views/billing/b.dart';
import '../views/bundleplans/b.dart';
import '../views/buy/b.dart';
import '../views/claimassistant/cl.dart';
import '../views/comparepremums/p.dart';
import '../views/documentscenter/dc.dart';
import '../views/emergencey/em.dart';
import '../views/home/home.dart';
import '../views/insightfulblogs/ins.dart';
import '../views/insurancepurchase/p.dart';
import '../views/legaladvisory/legal.dart';
import '../views/messages/chat_screen.dart';
import '../views/policies/p.dart';
import '../views/policyportfolio/pl.dart';
import '../views/promotionaloffers/pr.dart';
import '../views/queries/qr.dart';
import '../views/recenttrips/rt.dart';
import '../views/referalrewards/ref.dart';
import '../views/reminders/rem.dart';
import '../views/report/re.dart';
import '../views/reviews/reviews.dart';
import '../views/savedplans/sv.dart';
import '../views/score/sc.dart';
import '../views/settings/settings.dart';
import '../views/topup/t.dart';
import '../views/totalpayment/t.dart';
import '../views/yourstats/st.dart';
import 'detailstext1.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String selectedMenuItem = ''; // Track the selected menu item
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final name = await ProfileService.getUserFullName();
      if (mounted) {
        setState(() {
          userName = name ?? 'User';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = 'User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 5, top: 10),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset('images/c3.png'),
            ),
            title: const Text('Hey!', style: TextStyle()),
            subtitle: Text1(text1: userName ?? 'User'),
          ),
          const SizedBox(height: 10.0),
          buildMenuItem(
            title: "Home",
            icon: Icons.home,
            onTap: () => navigateTo(HomePage()),
          ),
          buildMenuItem(
            title: "Profile",
            icon: Icons.person,
            onTap: () => navigateTo(const UserProfilePage()),
          ),
          buildMenuItem(
            title: "Add Vehicle",
            icon: Icons.directions_car,
            onTap: () => navigateTo(const AddVehiclePage()),
          ),
          buildMenuItem(
            title: "Create Policy",
            icon: Icons.add_circle,
            onTap: () => navigateTo(const AddPolicyPage()),
          ),

          buildMenuItem(
            title: "Policies",
            icon: Icons.policy,
            onTap: () => navigateTo(const Policies()),
          ),
          buildMenuItem(
            title: "PolicyPortfolio",
            icon: Icons.folder_copy,
            onTap: () => navigateTo(const PolicyPortfolioScreen()),
          ),
          buildMenuItem(
            title: "TotalPayment",
            icon: Icons.attach_money,
            onTap: () => navigateTo(const TotalPaymentPage()),
          ),
          buildMenuItem(
            title: "Queries",
            icon: Icons.question_answer,
            onTap: () => navigateTo(const QueriesHomePage()),
          ),
          buildMenuItem(
            title: "Referral",
            icon: Icons.group_add,
            onTap: () => navigateTo(ReferralScreen()),
          ),
          buildMenuItem(
            title: "DrivingScor",
            icon: Icons.speed,
            onTap: () => navigateTo(const DrivingScorePage()),
          ),

          buildMenuItem(
            title: "EmergencyServices",
            icon: Icons.local_hospital,
            onTap: () => navigateTo(EmergencyServicesScreen()),
          ),
          buildMenuItem(
            title: "Insightful",
            icon: Icons.lightbulb_outline,
            onTap: () => navigateTo(InsightfulBlogsScreen()),
          ),
          buildMenuItem(
            title: "Reminders",
            icon: Icons.alarm,
            onTap: () => navigateTo(const RemindersScreen()),
          ),
          buildMenuItem(
            title: "Report",
            icon: Icons.report,
            onTap: () => navigateTo(const ReportScreen()),
          ),
          buildMenuItem(
            title: "SavedPlans",
            icon: Icons.bookmark,
            onTap: () => navigateTo(const SavedPlansScreen()),
          ),
          buildMenuItem(
            title: "YourStats",
            icon: Icons.insights,
            onTap: () => navigateTo(const YourStatsScreen()),
          ),
          buildMenuItem(
            title: "Billing",
            icon: Icons.receipt_long,
            onTap: () => navigateTo(const BillingModuleScreen()),
          ),
          buildMenuItem(
            title: "BuyingInsuranc",
            icon: Icons.shopping_cart,
            onTap: () => navigateTo(const BuyingInsurancePage()),
          ),
          buildMenuItem(
            title: "ComparePremiums",
            icon: Icons.compare_arrows,
            onTap: () => navigateTo(const ComparePremiumsPage()),
          ),
          buildMenuItem(
            title: "LegalAdvisory",
            icon: Icons.gavel,
            onTap: () => navigateTo(LegalAdvisoryScreen()),
          ),

          buildMenuItem(
            title: "Analytics",
            icon: Icons.bar_chart,
            onTap: () => navigateTo(const AnalyticsScreen()),
          ),
          buildMenuItem(
            title: "Appointments",
            icon: Icons.calendar_today,
            onTap: () => navigateTo(const Appointments()),
          ),
          buildMenuItem(
            title: "Benefits",
            icon: Icons.card_membership,
            onTap: () => navigateTo(BenefitsPage()),
          ),
          buildMenuItem(
            title: "ClaimAssistance",
            icon: Icons.support_agent,
            onTap: () => navigateTo(ClaimAssistanceScreen()),
          ),
          buildMenuItem(
            title: "DocumentCenter",
            icon: Icons.folder_shared,
            onTap: () => navigateTo(const DocumentCenterScreen()),
          ),

          buildMenuItem(
            title: "InsurancePurchase",
            icon: Icons.shopping_bag,
            onTap: () => navigateTo(const InsurancePurchaseScreen()),
          ),
          buildMenuItem(
            title: "PromotionalOffers",
            icon: Icons.local_offer,
            onTap: () => navigateTo(PromotionalOffersScreen()),
          ),
          buildMenuItem(
            title: "Analytics",
            icon: Icons.analytics,
            onTap: () => navigateTo(const AnalyticsScreen()),
          ),

          buildMenuItem(
            title: "Topup",
            icon: Icons.account_balance_wallet,
            onTap: () => navigateTo(const TopupPage()),
          ),

          buildMenuItem(
            title: "RecentTrip",
            icon: Icons.directions_car,
            onTap: () => navigateTo(const RecentTripScreen()),
          ),
          buildMenuItem(
            title: "AccidentInsurance",
            icon: Icons.health_and_safety,
            onTap: () => navigateTo(const AccidentInsuranceScreen()),
          ),
          buildMenuItem(
            title: "ClaimAssistance",
            icon: Icons.support,
            onTap: () => navigateTo(ClaimAssistanceScreen()),
          ),
          buildMenuItem(
            title: "BundlePlan",
            icon: Icons.widgets,
            onTap: () => navigateTo(const BundlePlanScreen()),
          ),

          buildMenuItem(
            title: "AICustomer",
            icon: Icons.smart_toy,
            onTap: () => navigateTo(AICustomerSupport()),
          ),
          buildMenuItem(
            title: "AiClaims",
            icon: Icons.fact_check,
            onTap: () => navigateTo(const ClaimsProcessingScreen()),
          ),
          buildMenuItem(
            title: "AIFeedback",
            icon: Icons.feedback,
            onTap: () => navigateTo(const FeedbackAnalysisScreen()),
          ),
          buildMenuItem(
            title: "AIFinancialAdvisory",
            icon: Icons.trending_up,
            onTap: () => navigateTo(const FinancialAdvisoryScreen()),
          ),
          buildMenuItem(
            title: "AIPolicy",
            icon: Icons.article,
            onTap: () => navigateTo(const AIPolicyRecommendationScreen()),
          ),
          buildMenuItem(
            title: "AIRiskAssessment",
            icon: Icons.security,
            onTap: () => navigateTo(const RiskAssessmentScreen()),
          ),
          buildMenuItem(
            title: "AIMarketing",
            icon: Icons.campaign,
            onTap: () => navigateTo(const AIMarketingScreen()),
          ),

          buildMenuItem(
            title: "Chat",
            icon: Icons.chat_bubble_outline,
            onTap: () => navigateTo(const ChatScreen()),
          ),
          buildMenuItem(
            title: "Reviews",
            icon: Icons.rate_review,
            onTap: () => navigateTo(const Reviews()),
          ),
          buildMenuItem(
            title: "Settings",
            icon: Icons.settings,
            onTap: () => navigateTo(const Settings()),
          ),

          const SizedBox(height: 10),
          const Divider(thickness: 1),
          ListTile(
            onTap: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await AuthService.signOut();
                if (mounted) {
                  navigator.pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }
            },
            leading: const Icon(
              Icons.logout,
              color: Colors.redAccent,
              size: 20,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                color: Colors.redAccent,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    bool isSelected = title == selectedMenuItem;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 30, top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: const Border(),
        color: isSelected ? Colors.green : null, // Highlight selected item
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMenuItem = title;
          });
          onTap();
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.navigate_next,
              size: 20,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
