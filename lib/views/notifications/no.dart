import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

// Helper function to convert opacity (0.0-1.0) to an alpha value (0-255)
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- DATA MODEL ---
class InsurancePolicy {
  final String policyName;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final double coverageAmount;
  final double premiumAmount;
  final String status;
  final double percentage; // from 0.0 to 1.0 for the mini progress dot

  InsurancePolicy({
    required this.policyName,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.coverageAmount,
    required this.premiumAmount,
    required this.status,
    required this.percentage,
  });
}

// --- MAIN SCREEN WIDGET ---
class Notificationsssss extends StatefulWidget {
  const Notificationsssss({super.key});

  @override
  State<Notificationsssss> createState() => NotificationsssssState();
}

class NotificationsssssState extends State<Notificationsssss> {
  // --- MOCK DATA ---
  final List<InsurancePolicy> _policies = [
    InsurancePolicy(
      policyName: "Health Insurance",
      icon: FontAwesomeIcons.heartPulse,
      iconBgColor: const Color(0xFFE8F5E9),
      iconColor: const Color(0xFF4CAF50),
      coverageAmount: 500000,
      premiumAmount: 4500,
      status: "Active",
      percentage: 1.0,
    ),
    InsurancePolicy(
      policyName: "Auto Insurance",
      icon: FontAwesomeIcons.car,
      iconBgColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF2196F3),
      coverageAmount: 300000,
      premiumAmount: 3200,
      status: "Active",
      percentage: 0.8,
    ),
    InsurancePolicy(
      policyName: "Home Insurance",
      icon: FontAwesomeIcons.house,
      iconBgColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF9800),
      coverageAmount: 750000,
      premiumAmount: 5200,
      status: "Active",
      percentage: 0.65,
    ),
    InsurancePolicy(
      policyName: "Life Insurance",
      icon: FontAwesomeIcons.person,
      iconBgColor: const Color(0xFFF3E5F5),
      iconColor: const Color(0xFF9C27B0),
      coverageAmount: 1000000,
      premiumAmount: 2800,
      status: "Active",
      percentage: 0.9,
    ),
    InsurancePolicy(
      policyName: "Travel Insurance",
      icon: FontAwesomeIcons.plane,
      iconBgColor: const Color(0xFFE0F7FA),
      iconColor: const Color(0xFF00BCD4),
      coverageAmount: 200000,
      premiumAmount: 1200,
      status: "Expired",
      percentage: 0.0,
    ),
  ];

  // --- BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Stack(
        children: [
          // Optional: A subtle background for visual flair
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 250,
              child: Image.asset(
                'assets/insurance_background.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.blue.withValues(alpha: 0.05)),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(),
                  const SizedBox(height: 30),
                  buildMainStats(),
                  const SizedBox(height: 30),
                  SizedBox(height: 200, child: buildBarChart()),
                  const SizedBox(height: 30),
                  buildPolicyListCard(),
                  const SizedBox(height: 30),
                  buildQuickActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI BUILDER METHODS ---
  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.blue),
          label: Text("Back", style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue)),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
        Text(
          'My Insurance',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1D2A3A)),
        ),
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/41.jpg'),
        ),
      ],
    );
  }

  Widget buildMainStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TOTAL COVERAGE",
              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(color: const Color(0xFF1D2A3A)),
                children: [
                  const TextSpan(
                    text: "\$2,750,000",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(4, -14),
                      child: const CircleAvatar(radius: 4, backgroundColor: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.shield, color: Colors.grey, size: 12),
                const SizedBox(width: 6),
                Text("5 active policies", style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "ADD POLICY",
            style: GoogleFonts.poppins(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildBarChart() {
    const Color barColor = Color(0xFF2196F3);
    return BarChart(
      BarChartData(
        maxY: 12000,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.15), strokeWidth: 1, dashArray: [4, 4]),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (v, m) {
                if (v == 0) return const SizedBox();
                return Text("\$${(v / 1000).toStringAsFixed(0)}K ", style: GoogleFonts.lato(color: Colors.grey, fontSize: 10));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, m) {
                const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                return Text(
                  months[v.toInt()],
                  style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 8000,
              color: Colors.teal.withValues(alpha: 0.8),
              strokeWidth: 1,
              dashArray: [4, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5),
                style: GoogleFonts.lato(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold),
                labelResolver: (line) => 'avg',
              ),
            ),
          ],
        ),
        barGroups: [
          makeBarData(0, 4500, barColor),
          makeBarData(1, 3200, barColor),
          makeBarData(2, 5200, barColor),
          makeBarData(3, 2800, barColor),
          makeBarData(4, 1200, barColor),
          makeBarData(5, 0, barColor),
          makeBarData(6, 0, barColor),
        ],
      ),
    );
  }

  BarChartGroupData makeBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget buildPolicyListCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(_alphaFromOpacity(0.05)), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ListView.separated(
            itemCount: _policies.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              return buildPolicyRow(_policies[index]);
            },
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          TextButton.icon(
            onPressed: () {},
            icon: Text(
              "SEE ALL POLICIES",
              style: GoogleFonts.poppins(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 12),
            ),
            label: const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 20),
          ),
        ],
      ),
    );
  }

  Widget buildPolicyRow(InsurancePolicy policy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: policy.iconBgColor, borderRadius: BorderRadius.circular(10)),
            child: FaIcon(policy.icon, color: policy.iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(policy.policyName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  "Coverage: \$${policy.coverageAmount.toStringAsFixed(0)}",
                  style: GoogleFonts.lato(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${policy.premiumAmount.toStringAsFixed(0)}/mo",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: policy.status == "Active" ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  policy.status,
                  style: GoogleFonts.lato(
                    color: policy.status == "Active" ? Colors.green : Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(Icons.receipt, "Claims"),
            _buildActionButton(Icons.support_agent, "Support"),
            _buildActionButton(Icons.document_scanner, "Documents"),
            _buildActionButton(Icons.payment, "Payments"),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(_alphaFromOpacity(0.05)), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}