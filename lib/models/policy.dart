class Policy {
  final String id;
  final String userId;
  final String vehicleId;
  final String policyNumber;
  final String policyType; // 'comprehensive', 'third_party', 'collision'
  final String coverageLevel; // 'basic', 'standard', 'premium'
  final double monthlyPremium;
  final double annualPremium;
  final String riskLevel; // 'low', 'moderate', 'high'
  final String status; // 'active', 'inactive', 'pending', 'expired'
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final Map<String, dynamic>? coverageDetails;
  final double? discount;
  final String? discountReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  Policy({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.policyNumber,
    required this.policyType,
    required this.coverageLevel,
    required this.monthlyPremium,
    required this.annualPremium,
    required this.riskLevel,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.description,
    this.coverageDetails,
    this.discount,
    this.discountReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vehicleId: json['vehicle_id'] as String,
      policyNumber: json['policy_number'] as String,
      policyType: json['policy_type'] as String,
      coverageLevel: json['coverage_level'] as String,
      monthlyPremium: (json['monthly_premium'] as num).toDouble(),
      annualPremium: (json['annual_premium'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      description: json['description'] as String?,
      coverageDetails: json['coverage_details'] as Map<String, dynamic>?,
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : null,
      discountReason: json['discount_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'user_id': userId,
      'vehicle_id': vehicleId,
      'policy_type': policyType,
      'coverage_level': coverageLevel,
      'monthly_premium': monthlyPremium,
      'annual_premium': annualPremium,
      'risk_level': riskLevel,
      'status': status,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'coverage_details': coverageDetails,
    };

    // Only include optional fields if they have values
    if (description != null && description!.isNotEmpty) {
      json['description'] = description;
    }
    if (discount != null && discount! > 0) {
      json['discount'] = discount;
    }
    if (discountReason != null && discountReason!.isNotEmpty) {
      json['discount_reason'] = discountReason;
    }

    // Only include ID and policyNumber if they're not empty (for updates)
    if (id.isNotEmpty) {
      json['id'] = id;
    }
    if (policyNumber.isNotEmpty) {
      json['policy_number'] = policyNumber;
    }

    return json;
  }

  Policy copyWith({
    String? id,
    String? userId,
    String? vehicleId,
    String? policyNumber,
    String? policyType,
    String? coverageLevel,
    double? monthlyPremium,
    double? annualPremium,
    String? riskLevel,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    Map<String, dynamic>? coverageDetails,
    double? discount,
    String? discountReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Policy(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      policyNumber: policyNumber ?? this.policyNumber,
      policyType: policyType ?? this.policyType,
      coverageLevel: coverageLevel ?? this.coverageLevel,
      monthlyPremium: monthlyPremium ?? this.monthlyPremium,
      annualPremium: annualPremium ?? this.annualPremium,
      riskLevel: riskLevel ?? this.riskLevel,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      coverageDetails: coverageDetails ?? this.coverageDetails,
      discount: discount ?? this.discount,
      discountReason: discountReason ?? this.discountReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
