import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/config.dart';

class FinancialAdvisoryScreen extends StatefulWidget {
  const FinancialAdvisoryScreen({super.key});

  @override
  State<FinancialAdvisoryScreen> createState() => _FinancialAdvisoryScreenState();
}

class _FinancialAdvisoryScreenState extends State<FinancialAdvisoryScreen> {
  final List<FinancialProfile> _profiles = [];
  bool _isAnalyzing = false;
  String _analysisResult = '';
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDummyProfiles();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDummyProfiles() {
    setState(() {
      _profiles.addAll([
        FinancialProfile(
          id: 'FP-2023-001',
          type: 'Retirement',
          status: 'Planning Phase',
          age: 42,
          currentSavings: 125000,
          riskTolerance: 'Moderate',
          healthConditions: ['Hypertension'],
        ),
        FinancialProfile(
          id: 'FP-2023-002',
          type: 'Health Protection',
          status: 'Active',
          age: 35,
          currentSavings: 85000,
          riskTolerance: 'Conservative',
          healthConditions: ['None'],
        ),
        FinancialProfile(
          id: 'FP-2023-003',
          type: 'Comprehensive',
          status: 'Review Needed',
          age: 58,
          currentSavings: 320000,
          riskTolerance: 'Aggressive',
          healthConditions: ['Diabetes', 'High Cholesterol'],
        ),
      ]);
    });
  }

  Future<void> _analyzeProfile(FinancialProfile profile) async {
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
                  "text": "Act as an insurance financial advisor AI. Analyze this profile:\n"
                      "Profile ID: ${profile.id}\n"
                      "Type: ${profile.type}\n"
                      "Age: ${profile.age}\n"
                      "Current Savings: \$${profile.currentSavings}\n"
                      "Risk Tolerance: ${profile.riskTolerance}\n"
                      "Health Conditions: ${profile.healthConditions.join(', ')}\n\n"
                      "Provide:\n"
                      "- Retirement/savings plan recommendations\n"
                      "- Insurance product suggestions\n"
                      "- Health risk predictions\n"
                      "- Investment strategy\n"
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
        throw Exception('Failed to analyze profile');
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
        title: const Text('Financial Advisory AI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            color: Colors.blue[600],
            onPressed: _loadDummyProfiles,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withAlpha(50),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                _buildTabButton(0, 'Retirement', FontAwesomeIcons.piggyBank),
                _buildTabButton(1, 'Health', FontAwesomeIcons.heartPulse),
                _buildTabButton(2, 'Comprehensive', FontAwesomeIcons.scaleBalanced),
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
                  // Header Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            FaIcon(
                              _selectedTabIndex == 0
                                  ? FontAwesomeIcons.piggyBank
                                  : _selectedTabIndex == 1
                                  ? FontAwesomeIcons.heartPulse
                                  : FontAwesomeIcons.scaleBalanced,
                              color: Colors.blue[600],
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedTabIndex == 0
                                        ? 'Retirement Planning'
                                        : _selectedTabIndex == 1
                                        ? 'Health Protection'
                                        : 'Comprehensive Advisory',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedTabIndex == 0
                                        ? 'AI-powered retirement savings strategies'
                                        : _selectedTabIndex == 1
                                        ? 'Health risk predictions and coverage'
                                        : 'Complete financial protection plan',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Profile Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _profiles
                          .where((profile) => _selectedTabIndex == 0
                          ? profile.type == 'Retirement'
                          : _selectedTabIndex == 1
                          ? profile.type == 'Health Protection'
                          : true)
                          .map((profile) => FinancialProfileCard(
                        profile: profile,
                        onAnalyze: () => _analyzeProfile(profile),
                      ))
                          .toList(),
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
                                    'AI Financial Recommendation',
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
          if (_isAnalyzing) const LinearProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _selectedTabIndex == index
                    ? Colors.blue[600]!
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                color: _selectedTabIndex == index
                    ? Colors.blue[600]
                    : Colors.grey[600],
                size: 16,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: _selectedTabIndex == index
                      ? Colors.blue[600]
                      : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FinancialProfile {
  final String id;
  final String type;
  final String status;
  final int age;
  final int currentSavings;
  final String riskTolerance;
  final List<String> healthConditions;

  FinancialProfile({
    required this.id,
    required this.type,
    required this.status,
    required this.age,
    required this.currentSavings,
    required this.riskTolerance,
    required this.healthConditions,
  });
}

class FinancialProfileCard extends StatelessWidget {
  final FinancialProfile profile;
  final VoidCallback onAnalyze;

  const FinancialProfileCard({
    required this.profile,
    required this.onAnalyze,
    super.key,
  });

  Color getStatusColor() {
    switch (profile.status) {
      case 'Planning Phase':
        return Colors.orange;
      case 'Active':
        return Colors.green;
      case 'Review Needed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getRiskColor() {
    switch (profile.riskTolerance) {
      case 'Aggressive':
        return Colors.red;
      case 'Moderate':
        return Colors.orange;
      case 'Conservative':
        return Colors.green;
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
                  profile.id,
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
                    color: getStatusColor().withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    profile.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.user,
              text: 'Age: ${profile.age}',
              secondIcon: FontAwesomeIcons.sackDollar,
              secondText: '\$${profile.currentSavings.toString()}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.gaugeHigh,
              text: 'Risk: ${profile.riskTolerance}',
              secondIcon: FontAwesomeIcons.heartCircleCheck,
              secondText: '${profile.healthConditions.length} ${profile.healthConditions.length == 1 ? 'condition' : 'conditions'}',
            ),
            if (profile.healthConditions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: profile.healthConditions
                    .map((condition) => Chip(
                  label: Text(
                    condition,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.red.withAlpha(20),
                  labelStyle: TextStyle(
                    color: Colors.red[600],
                  ),
                  visualDensity: VisualDensity.compact,
                ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.chartLine, size: 14),
                label: const Text('Get AI Recommendation'),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required IconData secondIcon,
    required String secondText,
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
    );
  }
}