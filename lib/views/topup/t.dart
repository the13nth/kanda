import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui'; // Required for ImageFilter.blur

// Helper function to convert opacity (0.0-1.0) to an alpha value (0-255).
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Model for Topup Options ---
class TopupOption {
  final String aedAmount;
  final String credits;
  final String? bonusCredits; // Nullable for options without a bonus

  const TopupOption({
    required this.aedAmount,
    required this.credits,
    this.bonusCredits,
  });
}

// --- The Main Topup Screen (Stateful) ---
class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  State<TopupPage> createState() => TopupPageState();
}

class TopupPageState extends State<TopupPage> {
  // --- Dummy Data ---
  final List<TopupOption> topupOptions = const [
    TopupOption(aedAmount: '20 AED', credits: '20 Credits'),
    TopupOption(aedAmount: '50 AED', credits: '50 Credits', bonusCredits: '+ 4 Credits'),
    TopupOption(aedAmount: '100 AED', credits: '100 Credits', bonusCredits: '+ 10 Credits'),
    TopupOption(aedAmount: '150 AED', credits: '100 Credits', bonusCredits: '+ 15 Credits'),
  ];

  int? selectedIndex; // Use nullable int to handle no selection

  // --- Method to show the Success Dialog ---
  void showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox(); // This is not used because we use the builder below.
      },
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOut.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: const PaymentSuccessDialog(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkColor = Color(0xFF1E1E2D);

    // This container gives the whole screen a phone-like frame for the mockup
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Topup', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.more_horiz, color: Colors.black54),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const CreditsCard(),
            const SizedBox(height: 30),
            const Text('Top Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: topupOptions.length + 1, // +1 for the "Other Amount"
                itemBuilder: (context, index) {
                  if (index < topupOptions.length) {
                    final option = topupOptions[index];
                    return TopupOptionTile(
                      option: option,
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  } else {
                    // The "Other Amount" tile
                    return const OtherAmountTile();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: showSuccessDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Add Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Widgets ---

class CreditsCard extends StatelessWidget {
  const CreditsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(_alphaFromOpacity(0.1)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const FaIcon(FontAwesomeIcons.trophy, color: Color(0xFFFFD700), size: 30),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current', style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text('400 Credits', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF75555),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class TopupOptionTile extends StatelessWidget {
  final TopupOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const TopupOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? const Color(0xFFF75555) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(option.aedAmount, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (option.bonusCredits != null)
                    Text(
                      option.bonusCredits!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  Text(
                    option.credits,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFF75555) : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtherAmountTile extends StatelessWidget {
  const OtherAmountTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'Other Amount',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black54),
      ),
    );
  }
}

// --- Payment Success Dialog ---
class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const darkColor = Color(0xFF1E1E2D);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.sackDollar, color: Color(0xFFFFD700), size: 60),
              const SizedBox(height: 24),
              const Text(
                'Payment\nSuccessful',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
              ),
              const SizedBox(height: 12),
              Text(
                'Your Payment has done Successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Go to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}