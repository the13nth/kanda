// main.dart or your preferred file name

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- Main App Entry Point ---
void main() {
  runApp(const InsuranceApp());
}

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance App UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
        textTheme: GoogleFonts.manropeTextTheme(Theme.of(context).textTheme),
      ),
      home: MainHomePage(),
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Dashboard'),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.campaign),
          label: const Text('View Offers'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF303F9F),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PromotionalOffersScreen()),
            );
          },
        ),
      ),
    );
  }
}

// --- Helper Function for Opacity ---
int alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Model for an Offer ---
class Offer {
  final String id;
  final String title;
  final String subtitle;
  final String promoCode;
  final DateTime expiryDate;
  final String imageUrl;
  final IconData icon;
  final Color color;
  final List<String> terms;

  Offer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.promoCode,
    required this.expiryDate,
    required this.imageUrl,
    required this.icon,
    required this.color,
    required this.terms,
  });
}

// SCREEN 1: List of Promotional Offers
class PromotionalOffersScreen extends StatelessWidget {
  PromotionalOffersScreen({super.key});

  final List<Offer> offers = [
    Offer(
      id: 'festive23',
      title: 'Festive Bonanza',
      subtitle: 'Flat 20% off on all Health Insurance plans.',
      promoCode: 'FESTIVE20',
      expiryDate: DateTime(2023, 12, 31),
      imageUrl: 'https://picsum.photos/seed/festival/800/600',
      icon: FontAwesomeIcons.gifts,
      color: Colors.orange.shade700,
      terms: ['Offer valid for new customers only.', 'Cannot be combined with other offers.', 'Minimum premium of \$100 applies.'],
    ),
    Offer(
      id: 'combo01',
      title: 'Family Combo Deal',
      subtitle: 'Bundle Health + Life insurance and save 15%.',
      promoCode: 'FAMILY15',
      expiryDate: DateTime(2024, 1, 31),
      imageUrl: 'https://picsum.photos/seed/family/800/600',
      icon: FontAwesomeIcons.users,
      color: Colors.blue.shade700,
      terms: ['Applicable on bundling at least 2 plans.', 'Discount applied on the total premium.', 'Offer valid on annual payment mode.'],
    ),
    Offer(
      id: 'car23',
      title: 'Monsoon Car Care',
      subtitle: 'Get a free roadside assistance package.',
      promoCode: 'MONSOON',
      expiryDate: DateTime(2023, 11, 30),
      imageUrl: 'https://picsum.photos/seed/rain/800/600',
      icon: FontAwesomeIcons.car,
      color: Colors.teal.shade700,
      terms: ['Valid on comprehensive vehicle insurance policies.', 'Roadside assistance package worth \$50.', 'Offer is non-transferable.'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions & Offers'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return _buildOfferCard(context, offers[index]);
        },
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, Offer offer) {
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      shadowColor: offer.color.withAlpha(alphaFromOpacity(0.3)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OfferDetailScreen(offer: offer)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  offer.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    offer.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer.subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.ticket, size: 16, color: offer.color),
                      const SizedBox(width: 3),
                      Text('Use Code: ${offer.promoCode}', style: TextStyle(fontWeight: FontWeight.bold, color: offer.color)),
                      const Spacer(),
                      FaIcon(FontAwesomeIcons.solidClock, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 3),
                      Text('Expires: ${DateFormat.yMMMd().format(offer.expiryDate)}', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SCREEN 2: Offer Detail Screen
class OfferDetailScreen extends StatelessWidget {
  final Offer offer;

  const OfferDetailScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            stretch: true,
            backgroundColor: offer.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              background: Image.network(
                offer.imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.5),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer.subtitle, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 24),
                  _buildPromoCodeSection(context),
                  const SizedBox(height: 24),
                  Text('Terms & Conditions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...offer.terms.map((term) => _buildTermRow(term)),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildAvailButton(context),
    );
  }

  Widget _buildPromoCodeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Promo Code',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DottedBorder(
              color: offer.color,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              dashPattern: const [8, 4],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      offer.promoCode,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: offer.color,
                        letterSpacing: 1.5,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: offer.promoCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Promo code copied!')),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.copy, size: 20),
                          SizedBox(width: 4),
                          Text('COPY'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermRow(String term) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: FaIcon(FontAwesomeIcons.circleDot, size: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(term, style: const TextStyle(fontSize: 16, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildAvailButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('AVAIL OFFER NOW'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Applying offer: ${offer.promoCode}... (Demo)')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: offer.color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}