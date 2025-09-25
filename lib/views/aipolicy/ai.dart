import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/config.dart';

class AIPolicyRecommendationScreen extends StatefulWidget {
  const AIPolicyRecommendationScreen({super.key});

  @override
  State<AIPolicyRecommendationScreen> createState() =>
      _AIPolicyRecommendationScreenState();
}

class _AIPolicyRecommendationScreenState
    extends State<AIPolicyRecommendationScreen> {
  List<PolicyRecommendation> recommendations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    final dummyUserData = {
      "age": 32,
      "location": "Urban",
      "driving_habits": "Safe driver (telematics data)",
      "health_metrics": "Active (wearable data)",
      "property_type": "Apartment",
      "previous_claims": 0
    };

    try {
      final prompt = """
      Analyze this insurance customer data and generate 3 personalized policy recommendations:
      
      User Data: ${jsonEncode(dummyUserData)}
      
      Generate recommendations with:
      1. A policy title
      2. Short description
      3. Appropriate FontAwesome icon name
      4. Hex color for the icon
      5. Behavior-based discount
      6. Monthly price
      7. Risk level assessment
      
      Format the response as a JSON array with these keys:
      title, description, icon, iconColor, discount, price, riskLevel
      """;

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [{"text": prompt}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final generatedText = responseData['candidates'][0]['content']['parts'][0]['text'];

        final startIndex = generatedText.indexOf('[');
        final endIndex = generatedText.lastIndexOf(']');
        final jsonArray = generatedText.substring(startIndex, endIndex + 1);

        final List<dynamic> parsed = jsonDecode(jsonArray);

        setState(() {
          recommendations = parsed.map((item) => PolicyRecommendation(
            title: item['title'] ?? 'Premium Coverage',
            description: item['description'] ?? 'Personalized policy based on your profile',
            icon: _getIconData(item['icon'] ?? 'shield'),
            iconColor: _parseColor(item['iconColor'] ?? '#2563eb'),
            discount: item['discount'] ?? '10% loyalty discount',
            price: item['price'] ?? '\$99/month',
            riskLevel: item['riskLevel'] ?? 'Moderate risk',
          )).toList();
          isLoading = false;
        });
      } else {
        _loadDummyData();
      }
    } catch (e) {
      debugPrint('Error calling Gemini API: $e');
      _loadDummyData();
    }
  }

  void _loadDummyData() {
    setState(() {
      recommendations = [
        PolicyRecommendation(
          title: "Smart Coverage Plus",
          description: "AI-recommended comprehensive coverage based on your safe driving patterns",
          icon: FontAwesomeIcons.car,
          iconColor: Colors.blue.shade600,
          discount: "15% telematics discount",
          price: "\$89/month",
          riskLevel: "Low risk",
        ),
        PolicyRecommendation(
          title: "Health Guardian Pro",
          description: "Personalized health insurance with wellness rewards for active users",
          icon: FontAwesomeIcons.heartPulse,
          iconColor: Colors.red.shade600,
          discount: "10% wearable bonus",
          price: "\$120/month",
          riskLevel: "Moderate risk",
        ),
        PolicyRecommendation(
          title: "Urban Home Shield",
          description: "Dynamic pricing optimized for apartment dwellers in urban areas",
          icon: FontAwesomeIcons.house,
          iconColor: Colors.green.shade600,
          discount: "5% claim-free discount",
          price: "\$75/month",
          riskLevel: "Low risk",
        ),
      ];
      isLoading = false;
    });
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'car': return FontAwesomeIcons.car;
      case 'heart-pulse': return FontAwesomeIcons.heartPulse;
      case 'house': return FontAwesomeIcons.house;
      case 'shield': return FontAwesomeIcons.shield;
      default: return FontAwesomeIcons.star;
    }
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.blue.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Policy Recommendations",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.all(12),
        child: isLoading
            ? _buildLoadingIndicator()
            : ListView.separated(
          itemCount: recommendations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return PolicyRecommendationCard(
              recommendation: recommendations[index],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            "Generating personalized recommendations...",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class PolicyRecommendationCard extends StatelessWidget {
  final PolicyRecommendation recommendation;

  const PolicyRecommendationCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),
            _buildDetailsRow(),
            const SizedBox(height: 8),
            _buildSelectButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: recommendation.iconColor.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: FaIcon(
            recommendation.icon,
            color: recommendation.iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recommendation.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                recommendation.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailColumn("Risk Level", recommendation.riskLevel,
            _getRiskColor(recommendation.riskLevel)),
        _buildDetailColumn("Your Discount", recommendation.discount,
            Colors.green.shade600),
        _buildDetailColumn("Monthly Price", recommendation.price,
            Colors.blue.shade600, isPrice: true),
      ],
    );
  }

  Widget _buildDetailColumn(String label, String value, Color color,
      {bool isPrice = false}) {
    return Column(
      crossAxisAlignment: isPrice
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 14 : 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Add your logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          "Select Plan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case "high risk": return Colors.red.shade600;
      case "moderate risk": return Colors.orange.shade600;
      case "low risk": return Colors.green.shade600;
      default: return Colors.grey.shade600;
    }
  }
}

class PolicyRecommendation {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String discount;
  final String price;
  final String riskLevel;

  PolicyRecommendation({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.discount,
    required this.price,
    required this.riskLevel,
  });
}