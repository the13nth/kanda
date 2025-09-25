import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/config.dart';

class ClaimsProcessingScreen extends StatefulWidget {
  const ClaimsProcessingScreen({super.key});

  @override
  State<ClaimsProcessingScreen> createState() => _ClaimsProcessingScreenState();
}

class _ClaimsProcessingScreenState extends State<ClaimsProcessingScreen> {
  final List<ClaimItem> _claims = [];
  bool _isAnalyzing = false;
  String _analysisResult = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadDummyClaims();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDummyClaims() {
    setState(() {
      _claims.addAll([
        ClaimItem(
          id: 'CL-2023-001',
          type: 'Auto',
          status: 'Submitted',
          date: '2023-11-15',
          amount: 2450.00,
          photos: 3,
          documents: 2,
          riskScore: 12,
        ),
        ClaimItem(
          id: 'CL-2023-002',
          type: 'Property',
          status: 'Pending Review',
          date: '2023-11-18',
          amount: 8750.00,
          photos: 5,
          documents: 4,
          riskScore: 68,
        ),
        ClaimItem(
          id: 'CL-2023-003',
          type: 'Health',
          status: 'Approved',
          date: '2023-11-10',
          amount: 1200.00,
          photos: 0,
          documents: 3,
          riskScore: 5,
        ),
      ]);
    });
  }

  Future<void> _analyzeClaim(ClaimItem claim) async {
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
                  "text": "Act as an insurance claims AI analyzer. Analyze this claim:\n"
                      "Claim ID: ${claim.id}\n"
                      "Type: ${claim.type}\n"
                      "Amount: \$${claim.amount}\n"
                      "Risk Score: ${claim.riskScore}/100\n\n"
                      "Provide: \n"
                      "- Damage assessment \n"
                      "- Fraud likelihood with reasoning\n"
                      "- Recommended action\n"
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
          // Scroll to bottom after analysis result is shown
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        });
      } else {
        throw Exception('Failed to analyze claim');
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
        title: const Text('Claims Processing AI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            color: Colors.blue[600],
            onPressed: _loadDummyClaims,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card (fixed height)
          SizedBox(
            height: 140, // Fixed height to prevent overflow
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.bolt,
                            color: Colors.amber[600],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Claims Processing',
                            style: TextStyle(
                              fontSize: 16, // Slightly smaller font
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          'Automated document review, damage assessment, and fraud detection',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13, // Slightly smaller font
                          ),
                          maxLines: 2, // Limit to 2 lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content area with scrollable claims and analysis
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Claims List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _claims.map((claim) => ClaimCard(
                        claim: claim,
                        onAnalyze: () => _analyzeClaim(claim),
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
                                    'AI Analysis Result',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                // Constrained height for markdown
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

          // Loading indicator at bottom
          if (_isAnalyzing)
            const LinearProgressIndicator(),
        ],
      ),
    );
  }
}

class ClaimItem {
  final String id;
  final String type;
  final String status;
  final String date;
  final double amount;
  final int photos;
  final int documents;
  final int riskScore;

  ClaimItem({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.amount,
    required this.photos,
    required this.documents,
    required this.riskScore,
  });
}

class ClaimCard extends StatelessWidget {
  final ClaimItem claim;
  final VoidCallback onAnalyze;

  const ClaimCard({
    required this.claim,
    required this.onAnalyze,
    super.key,
  });

  Color getStatusColor() {
    switch (claim.status) {
      case 'Approved':
        return Colors.green;
      case 'Pending Review':
        return Colors.orange;
      case 'Submitted':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color getRiskColor() {
    if (claim.riskScore < 30) return Colors.green;
    if (claim.riskScore < 70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 11),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    claim.id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[800],
                    ),
                    overflow: TextOverflow.ellipsis,
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
                    claim.status,
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
              icon: FontAwesomeIcons.fileLines,
              text: claim.type,
              secondIcon: FontAwesomeIcons.calendar,
              secondText: claim.date,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.sackDollar,
              text: '\$${claim.amount.toStringAsFixed(2)}',
              secondIcon: FontAwesomeIcons.images,
              secondText: '${claim.photos} photos',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.fileCircleCheck,
              text: '${claim.documents} docs',
              secondWidget: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getRiskColor().withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.shieldHalved,
                      color: getRiskColor(),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Risk: ${claim.riskScore}/100',
                      style: TextStyle(
                        color: getRiskColor(),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 14),
                label: const Text('Analyze with AI'),
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
    IconData? secondIcon,
    String? secondText,
    Widget? secondWidget,
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
        if (secondWidget != null)
          secondWidget
        else if (secondIcon != null && secondText != null)
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