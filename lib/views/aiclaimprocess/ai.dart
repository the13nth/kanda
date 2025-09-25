import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/config.dart';
import '../../models/claim.dart';
import '../../services/claim_service.dart';

class ClaimsProcessingScreen extends StatefulWidget {
  const ClaimsProcessingScreen({super.key});

  @override
  State<ClaimsProcessingScreen> createState() => _ClaimsProcessingScreenState();
}

class _ClaimsProcessingScreenState extends State<ClaimsProcessingScreen> {
  List<Claim> _claims = [];
  bool _isLoading = true;
  bool _isAnalyzing = false;
  String _analysisResult = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadClaims();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadClaims() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final claims = await ClaimService.getUserClaims();
      setState(() {
        _claims = claims;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading claims: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _analyzeClaim(Claim claim) async {
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
                  "text":
                      "Act as an insurance claims AI analyzer. Analyze this claim:\n"
                      "Claim ID: ${claim.claimNumber}\n"
                      "Type: ${claim.claimType}\n"
                      "Amount: \$${claim.claimAmount ?? 0}\n"
                      "Status: ${claim.status}\n"
                      "Description: ${claim.description}\n"
                      "Incident Date: ${claim.incidentDate}\n"
                      "Documents: ${claim.documentsUrls?.length ?? 0} files\n\n"
                      "Provide: \n"
                      "- Damage assessment \n"
                      "- Fraud likelihood with reasoning\n"
                      "- Recommended action\n"
                      "- Risk assessment (score 1-100)\n"
                      "Format response with clear markdown bullet points",
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['candidates'][0]['content']['parts'][0]['text'];

        // Extract risk score from AI response (look for "Risk: X/100" pattern)
        final riskScoreMatch = RegExp(
          r'Risk:?\s*(\d+)/100',
        ).firstMatch(aiResponse);
        final riskScore = riskScoreMatch != null
            ? int.parse(riskScoreMatch.group(1)!)
            : 50;

        // Update claim with analysis
        await ClaimService.updateClaimWithAnalysis(
          claim.id,
          aiResponse,
          riskScore,
        );

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
            onPressed: _loadClaims,
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _claims.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.fileCircleXmark,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No claims found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Submit a claim to see it here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/claim-form');
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Submit New Claim'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Claims List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: _claims
                                .map(
                                  (claim) => ClaimCard(
                                    claim: claim,
                                    onAnalyze: () => _analyzeClaim(claim),
                                  ),
                                )
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.3,
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
          if (_isAnalyzing) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}

class ClaimCard extends StatelessWidget {
  final Claim claim;
  final VoidCallback onAnalyze;

  const ClaimCard({required this.claim, required this.onAnalyze, super.key});

  Color getStatusColor() {
    switch (claim.status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'submitted':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getRiskColor() {
    // Calculate risk score based on claim amount and type
    double riskScore = 50; // Default risk score

    if (claim.claimAmount != null) {
      if (claim.claimAmount! > 10000) {
        riskScore = 80;
      } else if (claim.claimAmount! > 5000) {
        riskScore = 60;
      } else if (claim.claimAmount! > 1000) {
        riskScore = 40;
      } else {
        riskScore = 20;
      }
    }

    if (claim.claimType == 'theft') {
      riskScore += 20;
    }
    if (claim.claimType == 'accident') {
      riskScore += 10;
    }

    if (riskScore < 30) {
      return Colors.green;
    }
    if (riskScore < 70) {
      return Colors.orange;
    }
    return Colors.red;
  }

  int getRiskScore() {
    double riskScore = 50; // Default risk score

    if (claim.claimAmount != null) {
      if (claim.claimAmount! > 10000) {
        riskScore = 80;
      } else if (claim.claimAmount! > 5000) {
        riskScore = 60;
      } else if (claim.claimAmount! > 1000) {
        riskScore = 40;
      } else {
        riskScore = 20;
      }
    }

    if (claim.claimType == 'theft') {
      riskScore += 20;
    }
    if (claim.claimType == 'accident') {
      riskScore += 10;
    }

    return riskScore.clamp(0, 100).round();
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
                    claim.claimNumber,
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
                    claim.status.toUpperCase(),
                    style: TextStyle(color: getStatusColor(), fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.fileLines,
              text: claim.claimType.toUpperCase(),
              secondIcon: FontAwesomeIcons.calendar,
              secondText: claim.incidentDate,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.sackDollar,
              text: '\$${(claim.claimAmount ?? 0).toStringAsFixed(2)}',
              secondIcon: FontAwesomeIcons.images,
              secondText: '${claim.documentsUrls?.length ?? 0} files',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: FontAwesomeIcons.fileCircleCheck,
              text: '${claim.documentsUrls?.length ?? 0} docs',
              secondWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      'Risk: ${getRiskScore()}/100',
                      style: TextStyle(color: getRiskColor(), fontSize: 12),
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
        FaIcon(icon, color: Colors.blue[600], size: 14),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        const Spacer(),
        if (secondWidget != null)
          secondWidget
        else if (secondIcon != null && secondText != null)
          Row(
            children: [
              FaIcon(secondIcon, color: Colors.blue[600], size: 14),
              const SizedBox(width: 8),
              Text(
                secondText,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ],
          ),
      ],
    );
  }
}
