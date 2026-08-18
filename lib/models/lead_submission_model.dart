// File: lib/models/lead_submission_model.dart
// Purpose: Data model representing a lead submission.

import 'package:equatable/equatable.dart';

class LeadSubmissionModel extends Equatable {
  final String? id;
  final String name;
  final String phone;
  final String phoneCountryCode;
  final String phoneCountryIso;
  final String? address;
  final String? notes;
  final String? platform;
  final String? postId;
  final DateTime? createdAt;

  const LeadSubmissionModel({
    this.id,
    required this.name,
    required this.phone,
    this.phoneCountryCode = '91',
    this.phoneCountryIso = 'IN',
    this.address,
    this.notes,
    this.platform,
    this.postId,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'phone_country_code': phoneCountryCode,
      'phone_country_iso': phoneCountryIso,
      'address': address,
      'notes': notes,
      'platform': platform,
      'post_id': postId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  factory LeadSubmissionModel.fromJson(Map<String, dynamic> json) {
    return LeadSubmissionModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? json['contact_number'] as String? ?? '',
      phoneCountryCode: json['phone_country_code'] as String? ?? '91',
      phoneCountryIso: json['phone_country_iso'] as String? ?? 'IN',
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      platform: json['platform'] as String?,
      postId: json['post_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        phoneCountryCode,
        phoneCountryIso,
        address,
        notes,
        platform,
        postId,
        createdAt,
      ];
}

