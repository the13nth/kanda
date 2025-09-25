import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Helper function to convert opacity to an alpha value, as requested.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();



class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First main section for Cumulative and Monthly Income
            buildIncomeSection(),
            const SizedBox(height: 24),
            // Second main section for Visits and Deals
            buildStatsSection(context),
          ],
        ),
      ),
    );
  }

  // Builds the top section with two donut charts
  Widget buildIncomeSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(_alphaFromOpacity(0.1)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          const SectionHeader(title: 'Income'),
          const SizedBox(height: 20),
          IncomeChartCard(
            title: 'Cumulative Income',
            totalAmount: '100.030.450',
            directAmount: '100.000.000',
            directTitle: 'Cumulative Direct Income',
            indirectAmount: '30.450',
            indirectTitle: 'Cumulative Indirect Income',
            directValue: 95, // Percentage value for the chart
            indirectValue: 5,
          ),
          const SizedBox(height: 20),
          IncomeChartCard(
            title: 'Monthly Income',
            totalAmount: '100.030.450',
            directAmount: '100.000.000',
            directTitle: 'Monthly Direct Income',
            indirectAmount: '30.450',
            indirectTitle: 'Monthly Indirect Income',
            directValue: 80, // Different percentages for visual variety
            indirectValue: 20,
          ),
        ],
      ),
    );
  }

  // Builds the bottom section with stats and a bar chart
  Widget buildStatsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(_alphaFromOpacity(0.1)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          const SectionHeader(title: 'Income'),
          const SizedBox(height: 20),
          buildStatsRow(),
          const SizedBox(height: 30),
          buildBarChart(),
        ],
      ),
    );
  }

  Widget buildStatsRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StatItem(value: '4400', label: 'Total Visit'),
        StatItem(value: '1030', label: 'Total Invite Customer'),
        StatItem(value: '251', label: 'Total Deal Customer'),
      ],
    );
  }

  // A simplified bar chart based on the design
  Widget buildBarChart() {
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 4000,
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(color: Colors.grey, fontSize: 12);
                  String text;
                  switch (value.toInt()) {
                    case 0: text = 'Jan'; break;
                    case 1: text = 'Feb'; break;
                    case 2: text = 'Mar'; break;
                    case 3: text = 'Apr'; break;
                    case 4: text = 'May'; break;
                    default: text = ''; break;
                  }
                  return Text(text, style: style);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: [
            makeBarGroup(0, 2500, 1200),
            makeBarGroup(1, 3100, 900),
            makeBarGroup(2, 2800, 1500),
            makeBarGroup(3, 3500, 1100),
            makeBarGroup(4, 2200, 1800),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeBarGroup(int x, double y1, double y2) {
    const barColor1 = Color(0xFF3B82F6);
    const barColor2 = Color(0xFFF97316);
    const width = 12.0;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: barColor1, width: width, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: y2, color: barColor2, width: width, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }
}

// Widget for the main section headers (e.g., "Income", "Trend")
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Icon(Icons.info_outline, color: Colors.grey[400], size: 20),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Trend',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}


// A reusable card for displaying income with a donut chart
class IncomeChartCard extends StatelessWidget {
  final String title;
  final String totalAmount;
  final String directTitle;
  final String directAmount;
  final String indirectTitle;
  final String indirectAmount;
  final double directValue;
  final double indirectValue;

  const IncomeChartCard({
    super.key,
    required this.title,
    required this.totalAmount,
    required this.directTitle,
    required this.directAmount,
    required this.indirectTitle,
    required this.indirectAmount,
    required this.directValue,
    required this.indirectValue,
  });

  @override
  Widget build(BuildContext context) {
    const directColor = Color(0xFF3B82F6);
    const indirectColor = Color(0xFFF97316);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600])),
            Text(totalAmount, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      '$directTitle\n$directAmount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, height: 1.5),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                              value: directValue, color: directColor, radius: 15, showTitle: false),
                          PieChartSectionData(
                              value: indirectValue, color: indirectColor, radius: 15, showTitle: false),
                        ],
                        centerSpaceRadius: 25,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$indirectTitle\n$indirectAmount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, height: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LegendItem(color: directColor, text: directTitle),
                    const SizedBox(width: 24),
                    LegendItem(color: indirectColor, text: indirectTitle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget for the legend items below the chart
class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}

// Widget for the stat items (Total Visit, etc.)
class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}