import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/config.dart';

class FeedbackAnalysisScreen extends StatefulWidget {
  const FeedbackAnalysisScreen({super.key});

  @override
  State<FeedbackAnalysisScreen> createState() => _FeedbackAnalysisScreenState();
}

class _FeedbackAnalysisScreenState extends State<FeedbackAnalysisScreen> {
  List<FeedbackInsight> insights = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedbackInsights();
  }

  Future<void> fetchFeedbackInsights() async {
    final dummyFeedbackData = {
      "recent_reviews": [
        {
          "rating": 4,
          "comment": "Good service but claims process took too long",
          "category": "Claims"
        },
        {
          "rating": 5,
          "comment": "Excellent customer support!",
          "category": "Service"
        },
        {
          "rating": 2,
          "comment": "Premium increased without explanation",
          "category": "Pricing"
        }
      ],
      "survey_results": {
        "nps_score": 68,
        "top_complaint": "Slow response times",
        "top_praise": "Helpful agents"
      }
    };

    try {
      final prompt = """
      Analyze this insurance customer feedback data and generate 3 key insights:
      
      Feedback Data: ${jsonEncode(dummyFeedbackData)}
      
      Generate insights focusing on:
      1. Service improvement opportunities (use wrench icon)
      2. Positive aspects to emphasize (use thumbs-up icon)
      3. Critical issues needing immediate attention (use exclamation icon)
      
      For each insight include:
      - Title
      - Detailed analysis (in markdown format)
      - Hex color code
      - Urgency level (High/Medium/Low)
      
      Format response as JSON with:
      title, analysis, color, urgency
      """;

      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey'
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
          insights = parsed.map((item) => FeedbackInsight(
            title: item['title'] ?? 'Feedback Insight',
            analysis: item['analysis'] ?? 'No analysis generated',
            color: _parseColor(item['color'] ?? '#4285F4'),
            urgency: item['urgency'] ?? 'Medium',
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
        FeedbackInsight(
            title: "Claims Process Improvements",
            analysis: """
          **Key Issue:** 42% of negative feedback mentions claims processing  
          **Recommendations:**  
          - Implement digital claims submission  
          - Add status tracking dashboard  
          - Train staff on faster adjudication  
          **Expected Impact:** 30% reduction in complaints
          """,
            color: Colors.blue.shade600,
            urgency: "High"
        ),
        FeedbackInsight(
            title: "Customer Service Strengths",
            analysis: """
          **Positive Feedback Highlights:**  
          - 78% praise for support agents  
          - Top NPS driver is helpfulness  
          **Action Items:**  
          - Recognize top performers  
          - Share best practices team-wide  
          - Highlight in marketing materials
          """,
            color: Colors.green.shade600,
            urgency: "Medium"
        ),
        FeedbackInsight(
            title: "Pricing Transparency Needed",
            analysis: """
          **Critical Concern:** Unexpected premium increases  
          **Customer Impact:**  
          - 22% churn risk among affected  
          - 3.8/10 satisfaction on pricing  
          **Solutions:**  
          1. Advance notice for changes  
          2. Clear explanation documents  
          3. Payment plan options
          """,
            color: Colors.orange.shade600,
            urgency: "High"
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

  IconData _getInsightIcon(String title) {
    if (title.contains("Improve")) return FontAwesomeIcons.screwdriverWrench;
    if (title.contains("Strength")) return FontAwesomeIcons.thumbsUp;
    if (title.contains("Critical")) return FontAwesomeIcons.triangleExclamation;
    return FontAwesomeIcons.lightbulb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Feedback Analysis',
          style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Analyzing customer feedback...',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16
              ),
            ),
          ],
        ),
      )
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

  Widget _buildInsightCard(FeedbackInsight insight) {
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: insight.color.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    _getInsightIcon(insight.title),
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
                _buildUrgencyBadge(insight.urgency),
              ],
            ),
            const SizedBox(height: 12),
            MarkdownBody(
              data: insight.analysis,
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'AI-Generated Insight',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyBadge(String urgency) {
    Color badgeColor;
    switch (urgency.toLowerCase()) {
      case "high": badgeColor = Colors.red.shade600;
      case "medium": badgeColor = Colors.orange.shade600;
      case "low": badgeColor = Colors.blue.shade600;
      default: badgeColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        urgency,
        style: TextStyle(
            color: badgeColor,
            fontWeight: FontWeight.w600,
            fontSize: 12
        ),
      ),
    );
  }
}

class FeedbackInsight {
  final String title;
  final String analysis;
  final Color color;
  final String urgency;

  FeedbackInsight({
    required this.title,
    required this.analysis,
    required this.color,
    required this.urgency,
  });
}