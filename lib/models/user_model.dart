import 'package:equatable/equatable.dart';
import 'broker_model.dart';

class UserModel extends Equatable {
  static String tableName = "users";

  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? phoneCountryCode;
  final String? phoneCountryIso;
  final String? role;
  final bool? isActive;
  final bool? isDeleted;
  final BrokerModel? brokerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.phoneCountryCode = '91',
    this.phoneCountryIso = 'IN',
    this.role,
    this.isActive,
    this.isDeleted,
    this.brokerId,
    this.createdAt,
    this.updatedAt,
  });

  static UserModel fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return UserModel(id: json?.toString());
    }
    return UserModel(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      phoneCountryCode: json['phone_country_code']?.toString() ?? '91',
      phoneCountryIso: json['phone_country_iso']?.toString() ?? 'IN',
      role: json['role']?.toString() ?? 'broker',
      isActive: json['is_active'] as bool? ?? true,
      isDeleted: json['is_deleted'] as bool? ?? false,
      brokerId: json['broker_id'] != null
          ? BrokerModel.fromJson(json['broker_id'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())?.toLocal()
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['phone_country_code'] = phoneCountryCode ?? '91';
    data['phone_country_iso'] = phoneCountryIso ?? 'IN';
    data['role'] = role;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    data['broker_id'] = brokerId?.id;
    if (createdAt != null) {
      data['created_at'] = createdAt?.toUtc().toIso8601String();
    }
    return data;
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? phoneCountryCode,
    String? phoneCountryIso,
    String? role,
    bool? isActive,
    bool? isDeleted,
    BrokerModel? brokerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      phoneCountryIso: phoneCountryIso ?? this.phoneCountryIso,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      brokerId: brokerId ?? this.brokerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    phoneCountryCode,
    phoneCountryIso,
    role,
    isActive,
    isDeleted,
    brokerId,
    createdAt,
    updatedAt,
  ];
}
