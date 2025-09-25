import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper function to convert opacity to an alpha value, as requested.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();



// Data model for a personalized tip
class PersonalizedTip {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  PersonalizedTip({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for personalized tips
    final List<PersonalizedTip> tips = [
      PersonalizedTip(
        icon: FontAwesomeIcons.shieldHeart,
        iconColor: Colors.blue,
        title: 'Upgrade Your Health Plan',
        subtitle: 'You can get 20% more coverage for a small premium increase.',
      ),
      PersonalizedTip(
        icon: FontAwesomeIcons.car,
        iconColor: Colors.orange,
        title: 'Bundle Your Auto Insurance',
        subtitle: 'Save up to 15% by bundling auto with your home policy.',
      ),
      PersonalizedTip(
        icon: FontAwesomeIcons.solidLightbulb,
        iconColor: Colors.purple,
        title: 'Review Your Life Insurance',
        subtitle: 'Your needs may have changed. Let\'s check your coverage.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Insights'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSpendingTrendsCard(context),
            const SizedBox(height: 24),
            buildClaimHistoryCard(context),
            const SizedBox(height: 24),
            buildPersonalizedTipsSection(context, tips),
          ],
        ),
      ),
    );
  }

  // Card for Spending Trends on Premiums
  Widget buildSpendingTrendsCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Your monthly premium payments',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: LineChart(
                mainData(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card for Claim History & Success Rate
  Widget buildClaimHistoryCard(BuildContext context) {
    const double successRate = 92.5; // Example success rate

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Claim History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Your recent claim success rate',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Theme.of(context).primaryColor,
                          value: successRate,
                          title: '',
                          radius: 20,
                        ),
                        PieChartSectionData(
                          color: Colors.grey.withAlpha(_alphaFromOpacity(0.2)),
                          value: 100 - successRate,
                          title: '',
                          radius: 20,
                        ),
                      ],
                      centerSpaceRadius: 30,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${successRate.toStringAsFixed(1)}% Success',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Total Claims: 8\nApproved: 7\nPending: 1',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Section for Personalized Tips
  Widget buildPersonalizedTipsSection(BuildContext context, List<PersonalizedTip> tips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'Personalized Tips',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.separated(
          itemCount: tips.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final tip = tips[index];
            return TipCard(tip: tip);
          },
        ),
      ],
    );
  }

  // Configuration for the Line Chart
  LineChartData mainData(BuildContext context) {
    final List<Color> gradientColors = [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColor.withAlpha(_alphaFromOpacity(0.1)),
    ];

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5), FlSpot(4, 4.2), FlSpot(5, 5.5),
          ],
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors, begin: Alignment.centerLeft, end: Alignment.centerRight),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                colors: gradientColors.map((color) => color.withValues(alpha: 0.3)).toList(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            ),
          ),
        ),
      ],
    );
  }

  // Helper for bottom axis titles on the line chart
  static Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
    Widget text;
    switch (value.toInt()) {
      case 0: text = const Text('Jan', style: style); break;
      case 1: text = const Text('Feb', style: style); break;
      case 2: text = const Text('Mar', style: style); break;
      case 3: text = const Text('Apr', style: style); break;
      case 4: text = const Text('May', style: style); break;
      case 5: text = const Text('Jun', style: style); break;
      default: text = const Text('', style: style); break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}


// A reusable card widget for displaying a single personalized tip
class TipCard extends StatelessWidget {
  final PersonalizedTip tip;

  const TipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: tip.iconColor.withAlpha(_alphaFromOpacity(0.1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(tip.icon, color: tip.iconColor, size: 22),
        ),
        title: Text(
          tip.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          tip.subtitle,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Action for when a tip is tapped
        },
      ),
    );
  }
}