import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper function to convert opacity (0.0 - 1.0) to an alpha value (0-255)
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

class AccidentInsuranceScreen extends StatelessWidget {
  const AccidentInsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Modern Color Palette
    const Color primaryColor = Color(0xFF4A69FF); // A vibrant blue
    const Color accentColor = Color(0xFFF9690E); // A warm orange
    const Color backgroundColor = Colors.white;
    const Color textColor = Color(0xFF2C3E50);
    const Color subTextColor = Color(0xFF7F8C8D);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: textColor),
        title: const Text(
          'Accident Insurance',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.share_outlined, color: textColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBanner(context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductDetails(accentColor, textColor, subTextColor),
                  const SizedBox(height: 32),
                  _buildHotProductSection(context, primaryColor, subTextColor),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(primaryColor),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildTopBanner(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // Background Gradient
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE3F2FD).withAlpha(_alphaFromOpacity(0.5)),
                  const Color(0xFFE3F2FD).withAlpha(_alphaFromOpacity(0.1)),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Doctor Image
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.network(
              'https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80', // Doctor with transparent background effect
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error),
            ),
          ),
          // Info Card
          Positioned(
            top: 30,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(_alphaFromOpacity(0.8)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(_alphaFromOpacity(0.05)),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Asuransi\nKecelaka',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4A69FF),
                    ),
                  ),
                  const Text(
                    '30%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A69FF),
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                    child: Divider(
                      thickness: 1,
                      height: 20,
                    ),
                  ),
                  const Text(
                    'Up to 8 million',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Total reimbursement\nwithin 20 years',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          // Logos
          Positioned(
            top: 10,
            left: 20,
            child: Row(
              children: [
                Image.network('https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=1374&q=80', height: 20, fit: BoxFit.cover), // Insurance company logo
                const SizedBox(width: 8),
                Image.network('https://images.unsplash.com/photo-1603302576837-37561b2e2302?ixlib=rb-1.2.1&auto=format&fit=crop&w=1368&q=80', height: 20, fit: BoxFit.cover), // Partner logo
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductDetails(
      Color accentColor, Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asuransi Kecelakaan Diri Ineestasi Kiecill',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 24),
        _buildInfoRow(
          title: 'Income',
          details: ' promotion fee in the first year + ',
          highlight1: '60%',
          highlight2: '5% renewal',
          subDetails: ' in the next year',
          accentColor: accentColor,
          textColor: subTextColor,
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          title: 'Activity',
          details: ' commission for the first year',
          highlight1: '5%',
          accentColor: accentColor,
          textColor: subTextColor,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String details,
    required String highlight1,
    String? highlight2,
    String? subDetails,
    required Color accentColor,
    required Color textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: textColor, fontSize: 14),
                  children: [
                    TextSpan(
                        text: highlight1,
                        style: TextStyle(color: accentColor)),
                    TextSpan(text: details),
                    if (highlight2 != null)
                      TextSpan(
                          text: highlight2,
                          style: TextStyle(color: accentColor)),
                    if (subDetails != null) TextSpan(text: subDetails),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    );
  }

  Widget _buildHotProductSection(
      BuildContext context, Color primaryColor, Color subTextColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Produk Panas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Lihat Semua >',
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shadowColor: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
          clipBehavior: Clip.antiAlias,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              _buildFamilyBanner(primaryColor),
              _buildCustomizedBanner(),
              _buildFeaturesList(context, primaryColor, subTextColor),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFamilyBanner(Color primaryColor) {
    return Stack(
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1544027993-37dbfe43562a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', // Family insurance concept
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 150,
          width: double.infinity,
          color: primaryColor.withAlpha(_alphaFromOpacity(0.2)),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ASURANSI\nKECELAKAAN\nDIRI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(_alphaFromOpacity(0.4)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Up to 8 million',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizedBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Specially customized for family, giving whole family stable guarantee',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildFeaturesList(
      BuildContext context, Color primaryColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Female doctor image
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.network(
              'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80', // Female doctor portrait
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, size: 100),
            ),
          ),
          const SizedBox(width: 8),
          // Feature items
          Expanded(
            child: Column(
              children: [
                _buildFeatureItem(
                  'Serious',
                  'General medical deduction',
                  'deductible 100%',
                  primaryColor,
                  subTextColor,
                ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String line1, String line2,
      Color primaryColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withAlpha(_alphaFromOpacity(0.2)),
            ),
            child: Center(
              child: Text(title,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line1,
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
                Text(
                  line2,
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar(Color primaryColor) {
    final numberFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Price', style: TextStyle(color: Colors.grey)),
              Text(
                numberFormat.format(185000000),
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text('BELI', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}