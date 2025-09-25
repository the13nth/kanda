import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

// As requested, a helper function to convert opacity (0.0-1.0) to an alpha value (0-255).
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

class DrivingScorePage extends StatelessWidget {
  const DrivingScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8FC), // Light grey background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScoreHeader(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Driving metrics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            DrivingMetricsList(),
          ],
        ),
      ),
    );
  }
}

class ScoreHeader extends StatelessWidget {
  const ScoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const double score = 7;
    const double maxScore = 10;
    final double percentage = score / maxScore;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF3D438A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Your average driving score',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250,
            height: 125,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The custom painter for the gauge
                SizedBox.expand(
                  child: CustomPaint(
                    painter: ScoreGaugePainter(
                      percentage: percentage,
                      progressColor: const Color(0xFF34D399), // Green
                    ),
                  ),
                ),
                // The text inside the gauge
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Good', style: TextStyle(color: Colors.white70, fontSize: 18)),
                    SizedBox(height: 5),
                    Text(
                      '7',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Min and Max score labels
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Text('0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: Text('10', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.chartLine, color: Color(0xFF34D399), size: 16),
              SizedBox(width: 8),
              Text(
                '2 points better than last week',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ScoreGaugePainter extends CustomPainter {
  final double percentage;
  final Color progressColor;

  ScoreGaugePainter({required this.percentage, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2);
    const startAngle = -math.pi;
    const sweepAngle = math.pi;
    const strokeWidth = 18.0;

    // Background Arc
    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle * percentage, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrivingMetricsList extends StatelessWidget {
  const DrivingMetricsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          DrivingMetricCard(
            icon: FontAwesomeIcons.gaugeHigh,
            iconBgColor: Color(0xFFE8E6FC),
            iconColor: Color(0xFF6A5AE0),
            title: 'Speed',
            rating: 'Excellent',
            ratingColor: Color(0xFF34D399),
            score: '10/10',
            change: '+2',
            changeColor: Color(0xFF34D399),
            description: "How fast you drive, and whether you're staying within the speed limit",
            isPositiveChange: true,
          ),
          SizedBox(height: 15),
          DrivingMetricCard(
            icon: FontAwesomeIcons.exclamation,
            iconBgColor: Color(0xFFE8E6FC),
            iconColor: Color(0xFF6A5AE0),
            title: 'Braking',
            rating: 'Good',
            ratingColor: Color(0xFFFBBF24),
            score: '8/10',
            description: "How quickly you stop, and if you give yourself to slow down safely",
          ),
          SizedBox(height: 15),
          DrivingMetricCard(
            icon: FontAwesomeIcons.codeBranch,
            iconBgColor: Color(0xFFE8E6FC),
            iconColor: Color(0xFF6A5AE0),
            title: 'Cornering',
            rating: 'Fair',
            ratingColor: Color(0xFFF87171),
            score: '2/10',
            change: '-4',
            changeColor: Color(0xFFF87171),
            description: "How smoothly you turn, and whether you give other drivers enough indication",
            isPositiveChange: false,
          ), DrivingMetricCard(
            icon: FontAwesomeIcons.gaugeHigh,
            iconBgColor: Color(0xFFE8E6FC),
            iconColor: Color(0xFF6A5AE0),
            title: 'Speed',
            rating: 'Excellent',
            ratingColor: Color(0xFF34D399),
            score: '10/10',
            change: '+2',
            changeColor: Color(0xFF34D399),
            description: "How fast you drive, and whether you're staying within the speed limit",
            isPositiveChange: true,
          ),
          SizedBox(height: 15),
          DrivingMetricCard(
            icon: FontAwesomeIcons.exclamation,
            iconBgColor: Color(0xFFE8E6FC),
            iconColor: Color(0xFF6A5AE0),
            title: 'Braking',
            rating: 'Good',
            ratingColor: Color(0xFFFBBF24),
            score: '8/10',
            description: "How quickly you stop, and if you give yourself to slow down safely",
          ),
          SizedBox(height: 15),
          DrivingMetricCard(
            icon: FontAwesomeIcons.codeBranch,
            iconBgColor: Color(0xFFE8E6FC),
            iconColor: Color(0xFF6A5AE0),
            title: 'Cornering',
            rating: 'Fair',
            ratingColor: Color(0xFFF87171),
            score: '2/10',
            change: '-4',
            changeColor: Color(0xFFF87171),
            description: "How smoothly you turn, and whether you give other drivers enough indication",
            isPositiveChange: false,
          ),
        ],
      ),
    );
  }
}


class DrivingMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String rating;
  final Color ratingColor;
  final String score;
  final String? change;
  final Color? changeColor;
  final bool? isPositiveChange;
  final String description;

  const DrivingMetricCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.rating,
    required this.ratingColor,
    required this.score,
    this.change,
    this.changeColor,
    this.isPositiveChange,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.04)),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rating,
                      style: TextStyle(
                          color: ratingColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    score,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (change != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        FaIcon(
                          isPositiveChange == true
                              ? FontAwesomeIcons.arrowTrendUp
                              : FontAwesomeIcons.arrowTrendDown,
                          color: changeColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          change!,
                          style: TextStyle(
                              color: changeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}