import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper function to convert opacity (0.0-1.0) to an alpha value (0-255).
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Model for a Transaction ---
class Transaction {
  final String title;
  final double amount;
  final double trendPercentage;
  final bool isPositive;

  const Transaction({
    required this.title,
    required this.amount,
    required this.trendPercentage,
    required this.isPositive,
  });
}

// --- The Main Screen Widget ---
class TotalPaymentPage extends StatelessWidget {
  const TotalPaymentPage({super.key});

  // --- Dummy Data Source ---
  final List<Transaction> transactions = const [
    Transaction(title: 'Protecting Home', amount: 650.24, trendPercentage: 2.4, isPositive: true),
    Transaction(title: 'Car Insurance', amount: 250.12, trendPercentage: 2.4, isPositive: false),
    Transaction(title: 'Healthcare', amount: 350.31, trendPercentage: 3.4, isPositive: true),
    Transaction(title: 'Life Insurance', amount: 150.00, trendPercentage: 1.2, isPositive: true),
    Transaction(title: 'Travel Insurance', amount: 45.50, trendPercentage: 5.1, isPositive: false),
    Transaction(title: 'Gadget Protection', amount: 25.00, trendPercentage: 0.5, isPositive: true),
  ];

  @override
  Widget build(BuildContext context) {
    const darkColor = Color(0xFF1E1E2D);
    const bodySheetTopPosition = 340.0;

    return Scaffold(
      backgroundColor: darkColor,
      body: SafeArea(
        bottom: false, // Avoid safe area padding at the bottom for the sheet
        child: Stack(
          children: [
            // Header Section
            const PaymentHeader(),

            // Body Sheet (Transactions List)
            Positioned(
              top: bodySheetTopPosition,
              left: 0,
              right: 0,
              bottom: 0,
              child: TransactionSheet(transactions: transactions),
            ),

            // Overlapping Agent Card
            Positioned(
              top: bodySheetTopPosition - 70, // Position it to overlap both sections
              left: 20,
              right: 20,
              child: AgentCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentHeader extends StatelessWidget {
  const PaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom App Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, color: Colors.white, size: 28),
              const Text(
                'TOTAL PAYMENT',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(_alphaFromOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(FontAwesomeIcons.bell, color: Colors.white, size: 22),
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Total Bill
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '\$ 1250.67',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 28),
            ],
          ),
          const Text('Your monthly bill', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 30),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withAlpha(_alphaFromOpacity(0.3))),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('View bill', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E1E2D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AgentCard extends StatelessWidget {
  const AgentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF75555),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Travis Hunt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('My Agent', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withAlpha(_alphaFromOpacity(0.2))),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(FontAwesomeIcons.solidComment, color: Colors.white, size: 20),
              Icon(FontAwesomeIcons.phone, color: Colors.white, size: 20),
              Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(_alphaFromOpacity(0.4)),
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
    );
  }
}

class TransactionSheet extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionSheet({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.more_horiz, color: Colors.grey[400]),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 80, left: 20, right: 20), // Top padding for the AgentCard
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionTile(transaction: transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                '\$ ${transaction.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'last month',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 20,
                        child: CustomPaint(
                          painter: SparklinePainter(
                            isPositive: transaction.isPositive,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${transaction.isPositive ? '+' : '-'}${transaction.trendPercentage}%',
                        style: TextStyle(
                          color: transaction.isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final bool isPositive;
  SparklinePainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isPositive) {
      path.moveTo(0, size.height * 0.8);
      path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.5);
      path.quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height * 0.2);
    } else {
      path.moveTo(0, size.height * 0.2);
      path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.5);
      path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height * 0.8);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}