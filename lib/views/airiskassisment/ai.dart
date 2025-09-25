import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/config.dart';

class RiskAssessmentScreen extends StatefulWidget {
  const RiskAssessmentScreen({super.key});

  @override
  State<RiskAssessmentScreen> createState() => _RiskAssessmentScreenState();
}

class _RiskAssessmentScreenState extends State<RiskAssessmentScreen> {
  final List<RiskItem> _risks = [];
  bool _isAnalyzing = false;
  String _analysisResult = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadDummyRisks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDummyRisks() {
    setState(() {
      _risks.addAll([
        RiskItem(
          id: 'RA-2023-001',
          type: 'Vehicle',
          status: 'Active Monitoring',
          date: '2023-11-15',
          riskLevel: 'Medium',
          score: 45,
          devices: 2,
          hasDiscount: true,
        ),
        RiskItem(
          id: 'RA-2023-002',
          type: 'Health',
          status: 'Excellent',
          date: '2023-11-18',
          riskLevel: 'Low',
          score: 15,
          devices: 3,
          hasDiscount: true,
        ),
        RiskItem(
          id: 'RA-2023-003',
          type: 'Property',
          status: 'Needs Attention',
          date: '2023-11-10',
          riskLevel: 'High',
          score: 78,
          devices: 1,
          hasDiscount: false,
        ),
      ]);
    });
  }

  Future<void> _analyzeRisk(RiskItem risk) async {
    setState(() {
      _isAnalyzing = true;
      _analysisResult = '';
    });

    try {
      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Act as an insurance risk assessment AI. Analyze this risk profile:\n"
                      "Risk ID: ${risk.id}\n"
                      "Type: ${risk.type}\n"
                      "Risk Level: ${risk.riskLevel}\n"
                      "Score: ${risk.score}/100\n\n"
                      "Provide:\n"
                      "- Predictive risk analysis\n"
                      "- Recommended prevention measures\n"
                      "- IoT integration suggestions\n"
                      "- Health/wellness recommendations if applicable\n"
                      "Format response with clear markdown bullet points"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _analysisResult = aiResponse;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        });
      } else {
        throw Exception('Failed to analyze risk');
      }
    } catch (e) {
      setState(() {
        _analysisResult = 'Analysis failed. Please try again later.';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Assessment AI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            color: Colors.blue[600],
            onPressed: _loadDummyRisks,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(20),
              border: Border(
                bottom: BorderSide(
                  color: Colors.blue.withAlpha(50),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.shieldHalved,
                  color: Colors.blue[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Risk Prevention Dashboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      Text(
                        'Predictive analytics, IoT monitoring & wellness tracking',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Risk Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _risks.map((risk) => RiskCard(
                        risk: risk,
                        onAnalyze: () => _analyzeRisk(risk),
                      )).toList(),
                    ),
                  ),

                  // Analysis Result
                  if (_analysisResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.robot,
                                    color: Colors.teal[400],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI Risk Analysis',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: SingleChildScrollView(
                                  child: MarkdownBody(
                                    data: _analysisResult,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                      listBullet: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Loading Indicator
          if (_isAnalyzing)
            const LinearProgressIndicator(),
        ],
      ),
    );
  }
}

class RiskItem {
  final String id;
  final String type;
  final String status;
  final String date;
  final String riskLevel;
  final int score;
  final int devices;
  final bool hasDiscount;

  RiskItem({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.riskLevel,
    required this.score,
    required this.devices,
    required this.hasDiscount,
  });
}

class RiskCard extends StatelessWidget {
  final RiskItem risk;
  final VoidCallback onAnalyze;

  const RiskCard({
    required this.risk,
    required this.onAnalyze,
    super.key,
  });

  Color getRiskColor() {
    switch (risk.riskLevel) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color getStatusColor() {
    switch (risk.status) {
      case 'Excellent':
        return Colors.green;
      case 'Active Monitoring':
        return Colors.blue;
      case 'Needs Attention':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  risk.id,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue[800],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getRiskColor().withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    risk.riskLevel,
                    style: TextStyle(
                      color: getRiskColor(),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: _getTypeIcon(),
              text: risk.type,
              secondIcon: FontAwesomeIcons.calendar,
              secondText: risk.date,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.gaugeHigh,
              text: 'Score: ${risk.score}/100',
              secondIcon: FontAwesomeIcons.accusoft,
              secondText: '${risk.devices} ${risk.devices == 1 ? 'device' : 'devices'}',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.circleInfo,
                  color: Colors.blue[600],
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  risk.status,
                  style: TextStyle(
                    color: getStatusColor(),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (risk.hasDiscount)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.tag,
                          color: Colors.green,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Discount Active',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.magnifyingGlassChart, size: 14),
                label: const Text('Analyze Risk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onAnalyze,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (risk.type) {
      case 'Vehicle':
        return FontAwesomeIcons.car;
      case 'Health':
        return FontAwesomeIcons.heartPulse;
      case 'Property':
        return FontAwesomeIcons.house;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    IconData? secondIcon,
    String? secondText,
  }) {
    return Row(
      children: [
        FaIcon(
          icon,
          color: Colors.blue[600],
          size: 14,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        const Spacer(),
        if (secondIcon != null && secondText != null)
          Row(
            children: [
              FaIcon(
                secondIcon,
                color: Colors.blue[600],
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                secondText,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
      ],
    );
  }
}