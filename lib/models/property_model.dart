import 'package:equatable/equatable.dart';
import 'address_model.dart';
import 'broker_model.dart';

class PropertyModel extends Equatable {
  static const String tableName = "properties";

  final String? id;
  final BrokerModel? brokerId;
  final AddressModel? addressId;
  final String propertyTitle;
  final String? propertyDescription;
  final double price;
  final double area;
  final int bedrooms;
  final int bathrooms;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Getter for address backward compatibility
  AddressModel? get address => addressId;

  const PropertyModel({
    this.id,
    this.brokerId,
    this.addressId,
    required this.propertyTitle,
    this.propertyDescription,
    this.price = 0.0,
    this.area = 0.0,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.createdAt,
    this.updatedAt,
  });

  static PropertyModel fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return PropertyModel(
        id: json?.toString(),
        propertyTitle: '',
      );
    }

    AddressModel? parsedAddress;
    if (json['address'] != null) {
      parsedAddress = AddressModel.fromJson(json['address']);
    } else if (json['addresses'] != null) {
      parsedAddress = AddressModel.fromJson(json['addresses']);
    } else if (json['address_id'] != null) {
      parsedAddress = AddressModel.fromJson(json['address_id']);
    }

    return PropertyModel(
      id: json['id']?.toString(),
      brokerId: json['broker_id'] != null
          ? BrokerModel.fromJson(json['broker_id'])
          : null,
      addressId: parsedAddress,
      propertyTitle: json['property_title']?.toString() ?? '',
      propertyDescription: json['property_description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      area: double.tryParse(json['area']?.toString() ?? '0') ?? 0.0,
      bedrooms: int.tryParse(json['bedrooms']?.toString() ?? '0') ?? 0,
      bathrooms: int.tryParse(json['bathrooms']?.toString() ?? '0') ?? 0,
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
    data['broker_id'] = brokerId?.id;
    data['address_id'] = addressId?.id;
    data['property_title'] = propertyTitle;
    data['property_description'] = propertyDescription;
    data['price'] = price;
    data['area'] = area;
    data['bedrooms'] = bedrooms;
    data['bathrooms'] = bathrooms;
    if (addressId != null) data['address'] = addressId!.toJson();
    if (createdAt != null) data['created_at'] = createdAt?.toUtc().toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt?.toUtc().toIso8601String();
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        brokerId,
        addressId,
        propertyTitle,
        propertyDescription,
        price,
        area,
        bedrooms,
        bathrooms,
        createdAt,
        updatedAt,
      ];
}
