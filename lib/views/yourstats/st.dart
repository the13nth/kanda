import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper function to convert opacity to an alpha value for colors.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

class YourStatsScreen extends StatelessWidget {
  const YourStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color _ = Color(0xFFF44336);
    const Color _ = Color(0xFF757575);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenHeader(),
                const SizedBox(height: 40),
                StatsCircularProgress(),
                const SizedBox(height: 40),
                const BudgetInfo(),
                const SizedBox(height: 30),
                const StatsLineChart(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Header Widget ---
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: const Icon(Icons.chevron_left, color: Color(0xFF1A1A1A)),
          ),
          Text(
            'YOUR STATS',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: const Color(0xFF1A1A1A),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 40), // For alignment
        ],
      ),
    );
  }
}

// --- Circular Progress Section ---
class StatsCircularProgress extends StatelessWidget {
  const StatsCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    // Progress value between 0.0 and 1.0
    const double progress = 0.75; // 75%
    const Color primaryRed = Color(0xFFF44336);

    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The custom painter for the circle
            SizedBox.expand(
              child: CustomPaint(
                painter: StatsCircularProgressPainter(
                  progress: progress,
                  color: primaryRed,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
            // The checkmark button positioned on the arc
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: primaryRed.withAlpha(_alphaFromOpacity(0.3)), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
            ),
            // The content inside the circle
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$ 8700.0',
                  style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                ),
                Text('Yearly average', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF1A1A1A), shape: BoxShape.circle),
                  child: const FaIcon(FontAwesomeIcons.dollarSign, color: Colors.white, size: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatsCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  StatsCircularProgressPainter({required this.progress, required this.color, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 18.0;

    // Background circle paint
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Foreground (progress) arc paint
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw the background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the progress arc
    const startAngle = -math.pi / 2; // Start from the top
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Budget Info Section ---
class BudgetInfo extends StatelessWidget {
  const BudgetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(color: Color(0xFFF44336), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$13450.30',
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                  ),
                  Text('Yearly budget', style: GoogleFonts.poppins(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            "You've spent about 64% of your annual budget so far.",
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }
}

// --- Line Chart Section ---
class StatsLineChart extends StatelessWidget {
  const StatsLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data points for the chart
    final List<double> dataPoints = [30, 45, 40, 55, 70, 60, 80, 75];
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Year', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              // The chart painter
              SizedBox.expand(
                child: CustomPaint(painter: StatsLineChartPainter(dataPoints: dataPoints)),
              ),
              // Highlighted point for May (index 4)
              Positioned(
                left: (MediaQuery.of(context).size.width - 48) * (4 / (dataPoints.length - 1)) - 25,
                bottom: (dataPoints[4] / 100) * 150, // Normalize height
                child: ChartTooltip(value: '+ 3.5%'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Month labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: months.map((month) => Text(month, style: GoogleFonts.poppins(color: Colors.grey[600]))).toList(),
        ),
      ],
    );
  }
}

class StatsLineChartPainter extends CustomPainter {
  final List<double> dataPoints;

  StatsLineChartPainter({required this.dataPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFF44336)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    final stepX = size.width / (dataPoints.length - 1);

    // Function to get a point's coordinates
    Offset getPoint(int index) {
      return Offset(stepX * index, size.height - (dataPoints[index] / 100 * size.height * 0.8) - (size.height * 0.2));
    }

    path.moveTo(getPoint(0).dx, getPoint(0).dy);

    for (int i = 0; i < dataPoints.length - 1; i++) {
      final p1 = getPoint(i);
      final p2 = getPoint(i + 1);
      final controlPoint1 = Offset(p1.dx + stepX * 0.5, p1.dy);
      final controlPoint2 = Offset(p2.dx - stepX * 0.5, p2.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    // Draw the gradient fill
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final gradient = LinearGradient(
      colors: [const Color(0xFFF44336).withValues(alpha: 0.3), const Color(0xFFF44336).withValues(alpha: 0.0)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final fillPaint = Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Draw the line on top of the fill
    canvas.drawPath(path, linePaint);

    // Draw the highlighted point
    final highlightedIndex = 4; // May
    final highlightedPoint = getPoint(highlightedIndex);

    // Draw vertical line
    final lineToBottomPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(highlightedPoint.dx, highlightedPoint.dy),
      Offset(highlightedPoint.dx, size.height),
      lineToBottomPaint,
    );

    // Draw outer circle
    final outerCirclePaint = Paint()..color = const Color(0xFFF44336).withValues(alpha: 0.3);
    canvas.drawCircle(highlightedPoint, 10, outerCirclePaint);

    // Draw inner circle
    final innerCirclePaint = Paint()..color = const Color(0xFFF44336);
    canvas.drawCircle(highlightedPoint, 6, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChartTooltip extends StatelessWidget {
  final String value;
  const ChartTooltip({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8)),
          child: Text(
            value,
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
        ClipPath(
          clipper: TriangleClipper(),
          child: Container(color: const Color(0xFF1A1A1A), height: 8, width: 16),
        ),
        const SizedBox(height: 20), // space for circle
      ],
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
