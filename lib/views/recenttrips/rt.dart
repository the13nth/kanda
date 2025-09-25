import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Helper function to convert opacity to an alpha value for colors.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

class RecentTripScreen extends StatelessWidget {
  const RecentTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Map Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // IMPORTANT: Replace with your actual asset image path
                image: NetworkImage('https://staticmapmaker.com/img/google-placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Top Bar Elements (Back Button & Title)
          Positioned(
            top: 50.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle back navigation
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A4A7A).withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    'Recent trip',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(width: 44), // To balance the row
              ],
            ),
          ),

          // 3. Bottom Details Panel
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(_alphaFromOpacity(0.15)),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: const TripDetailsPanel(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TripDetailsPanel extends StatelessWidget {
  const TripDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Color(0xFF1E1E1E);
    const Color secondaryTextColor = Color(0xFF757575);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Draggable handle
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Trip Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '23 mins ',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        TextSpan(
                          text: '16 km',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Today, 03:40 p.m.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '7',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),

          // Location Details
          const LocationTimeline(),
        ],
      ),
    );
  }
}

class LocationTimeline extends StatelessWidget {
  const LocationTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icons and dotted line column
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LocationIndicator(),
              Expanded(
                child: DottedLine(),
              ),
              const LocationIndicator(isDestination: true),
            ],
          ),
          const SizedBox(width: 20),
          // Text details column
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adams Square Mini-Park',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
                Text(
                  '2915 Gilroy Street, Los Angeles',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LocationIndicator extends StatelessWidget {
  final bool isDestination;
  const LocationIndicator({super.key, this.isDestination = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDestination ? const Color(0xFF4A4A7A) : Colors.white,
        border: Border.all(
          color: const Color(0xFF4A4A7A),
          width: 2.5,
        ),
      ),
      child: isDestination
          ? null
          : Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4A4A7A),
          ),
        ),
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  const DottedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          return Container(
            height: 4,
            width: 2.5,
            color: Colors.grey.shade400,
          );
        }),
      ),
    );
  }
}