import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';

class AIMarketingScreen extends StatefulWidget {
  const AIMarketingScreen({super.key});

  @override
  State<AIMarketingScreen> createState() => _AIMarketingScreenState();
}

class _AIMarketingScreenState extends State<AIMarketingScreen> {
  List<MarketingInsight> insights = [];
  bool isLoading = true;
  final String geminiApiKey = 'YOUR_API_KEY';

  @override
  void initState() {
    super.initState();
    fetchInsights();
  }

  Future<void> fetchInsights() async {
    final dummyCustomerData = {
      "customer_segments": [
        {"id": 1001, "name": "Safe Drivers", "purchase_probability": 0.82},
        {"id": 1002, "name": "Young Professionals", "purchase_probability": 0.65},
        {"id": 1003, "name": "Senior Citizens", "purchase_probability": 0.45}
      ],
      "recent_campaigns": [
        {"name": "Summer Discount", "conversion_rate": 0.15},
        {"name": "Referral Bonus", "conversion_rate": 0.22}
      ],
      "churn_risk_customers": [
        {"id": 5001, "name": "John D.", "risk_score": 0.78},
        {"id": 5002, "name": "Sarah M.", "risk_score": 0.63}
      ]
    };

    try {
      final prompt = """
      Analyze this insurance customer data and generate 3 key marketing insights:
      
      Customer Data: ${jsonEncode(dummyCustomerData)}
      
      Generate insights focusing on:
      1. Lead scoring recommendations (use target icon)
      2. Personalized campaign suggestions (use bullseye icon) 
      3. Churn prevention strategies (use bell icon)
      
      For each insight include:
      - Title
      - Detailed recommendation (in markdown format)
      - Hex color code
      - Priority level (High/Medium/Low)
      
      Format response as JSON with:
      title, recommendation, color, priority
      """;

      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey'
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [{"text": prompt}]
          }
          ]
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
          insights = parsed.map((item) =>
              MarketingInsight(
                title: item['title'] ?? 'Marketing Insight',
                recommendation: item['recommendation'] ?? 'No recommendation generated',
                color: _parseColor(item['color'] ?? '#4285F4'),
                priority: item['priority'] ?? 'Medium',
              )).toList();
          isLoading = false;
        });
      } else {
        _loadDummyInsights();
      }
    } catch (e) {
      debugPrint('Gemini API Error: $e');
      _loadDummyInsights();
    }
  }

  void _loadDummyInsights() {
    setState(() {
      insights = [
        MarketingInsight(
            title: "High-Value Lead Targeting",
            recommendation: """
          **Top Segment:** Safe Drivers (82% conversion probability)  
          **Recommended Action:**  
          - Prioritize phone outreach to this group  
          - Offer bundled policies (auto + home)  
          - Use testimonials from similar customers  
          **Expected Lift:** 15-20% conversion increase
          """,
            color: Colors.blue.shade600,
            priority: "High"
        ),
        MarketingInsight(
            title: "Personalized Retention Campaign",
            recommendation: """
          **At-Risk Group:** Customers with 3+ years tenure  
          **Strategy:**  
          - Send anniversary discount (10% renewal bonus)  
          - Personalized policy review offers  
          - Highlight loyalty benefits in communications  
          **Projected Impact:** Reduce churn by 8-12%
          """,
            color: Colors.green.shade600,
            priority: "Medium"
        ),
        MarketingInsight(
            title: "Churn Prevention Alert",
            recommendation: """
          **High-Risk Customers:**  
          - John D. (78% churn risk)  
          - Sarah M. (63% churn risk)  
          **Intervention Plan:**  
          1. Schedule courtesy check-in calls  
          2. Offer free policy review  
          3. Provide exclusive retention offers  
          **Urgency:** Immediate action required
          """,
            color: Colors.orange.shade600,
            priority: "High"
        )
      ];
      isLoading = false;
    });
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return FontAwesomeIcons.solidBell;
      case "medium":
        return FontAwesomeIcons.bullseye;
      case "low":
        return FontAwesomeIcons.solidFlag;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red.shade600;
      case "medium":
        return Colors.orange.shade600;
      case "low":
        return Colors.blue.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'AI Marketing Insights',
          style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? _buildLoadingState()
          : ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: insights.length,
        separatorBuilder: (_, __) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildInsightCard(insights[index]);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Analyzing customer data...',
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(MarketingInsight insight) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: insight.color.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    _getPriorityIcon(insight.priority),
                    color: insight.color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    insight.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(insight.priority).withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    insight.priority,
                    style: TextStyle(
                      color: _getPriorityColor(insight.priority),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MarkdownBody(
              data: insight.recommendation,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.5,
                ),
                strong: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'AI-Powered Insight',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  class MarketingInsight {
  final String title;
  final String recommendation;
  final Color color;
  final String priority;

  MarketingInsight({
    required this.title,
    required this.recommendation,
    required this.color,
    required this.priority,
  });
}