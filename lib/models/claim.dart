class Claim {
  final String id;
  final String userId;
  final String? policyId;
  final String claimNumber;
  final String claimType; // 'accident', 'theft', 'damage', 'other'
  final String status; // 'submitted', 'approved', 'rejected', 'processing'
  final String incidentDate;
  final String description;
  final double? claimAmount;
  final double? approvedAmount;
  final List<String>? documentsUrls; // URLs to uploaded files
  final String? adjusterNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Claim({
    required this.id,
    required this.userId,
    this.policyId,
    required this.claimNumber,
    required this.claimType,
    required this.status,
    required this.incidentDate,
    required this.description,
    this.claimAmount,
    this.approvedAmount,
    this.documentsUrls,
    this.adjusterNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      policyId: json['policy_id'] as String?,
      claimNumber: json['claim_number'] as String,
      claimType: json['claim_type'] as String,
      status: json['status'] as String,
      incidentDate: json['incident_date'] as String,
      description: json['description'] as String,
      claimAmount: json['claim_amount'] != null
          ? (json['claim_amount'] as num).toDouble()
          : null,
      approvedAmount: json['approved_amount'] != null
          ? (json['approved_amount'] as num).toDouble()
          : null,
      documentsUrls: json['documents_urls'] != null
          ? List<String>.from(json['documents_urls'] as List)
          : null,
      adjusterNotes: json['adjuster_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'user_id': userId,
      'claim_number': claimNumber,
      'claim_type': claimType,
      'status': status,
      'incident_date': incidentDate,
      'description': description,
    };

    // Only include optional fields if they have values
    if (policyId != null && policyId!.isNotEmpty) {
      json['policy_id'] = policyId;
    }
    if (claimAmount != null) {
      json['claim_amount'] = claimAmount;
    }
    if (approvedAmount != null) {
      json['approved_amount'] = approvedAmount;
    }
    if (documentsUrls != null && documentsUrls!.isNotEmpty) {
      json['documents_urls'] = documentsUrls;
    }
    if (adjusterNotes != null && adjusterNotes!.isNotEmpty) {
      json['adjuster_notes'] = adjusterNotes;
    }

    // Only include ID if it's not empty (for updates)
    if (id.isNotEmpty) {
      json['id'] = id;
    }

    return json;
  }

  Claim copyWith({
    String? id,
    String? userId,
    String? policyId,
    String? claimNumber,
    String? claimType,
    String? status,
    String? incidentDate,
    String? description,
    double? claimAmount,
    double? approvedAmount,
    List<String>? documentsUrls,
    String? adjusterNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Claim(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      policyId: policyId ?? this.policyId,
      claimNumber: claimNumber ?? this.claimNumber,
      claimType: claimType ?? this.claimType,
      status: status ?? this.status,
      incidentDate: incidentDate ?? this.incidentDate,
      description: description ?? this.description,
      claimAmount: claimAmount ?? this.claimAmount,
      approvedAmount: approvedAmount ?? this.approvedAmount,
      documentsUrls: documentsUrls ?? this.documentsUrls,
      adjusterNotes: adjusterNotes ?? this.adjusterNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
