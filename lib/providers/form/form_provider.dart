// File: lib/providers/form/form_provider.dart
// Purpose: Handles property details loading via get_property_details RPC and lead form submission logic.

import 'package:flutter/material.dart';

import '../../core/supabase/supabase_config.dart';
import '../../models/property_model.dart';

class FormProvider extends ChangeNotifier {
  PropertyModel? _property;
  bool _isLoadingProperty = false;
  bool? _isPropertyValid; // null = unchecked, true = valid, false = invalid
  bool _isSavingLead = false;
  bool _isSubmitted = false;
  String? _errorMessage;

  PropertyModel? get property => _property;
  bool get isLoadingProperty => _isLoadingProperty;
  bool? get isPropertyValid => _isPropertyValid;
  bool get isSavingLead => _isSavingLead;
  bool get isSubmitted => _isSubmitted;
  String? get errorMessage => _errorMessage;

  // Backward compatibility getters
  bool get isLoadingPost => _isLoadingProperty;
  bool? get isPostValid => _isPropertyValid;

  /// Fetches property details by calling only the `get_property_details` RPC function
  Future<void> fetchPropertyDetails(String identifier) async {
    _isLoadingProperty = true;
    _errorMessage = null;
    _property = null;
    _isPropertyValid = null;
    notifyListeners();

    try {
      final res = await SupabaseConfig.client.rpc(
        'get_property_details',
        params: {'p_identifier': identifier},
      );

      if (res != null && res is Map && res['success'] == true && res['data'] != null) {
        _property = PropertyModel.fromJson(res['data']);
        _isPropertyValid = true;
      } else {
        _isPropertyValid = false;
        _errorMessage = res is Map ? res['message']?.toString() ?? 'Property not found.' : 'Property not found.';
      }
    } catch (e) {
      debugPrint('Error calling get_property_details RPC: $e');
      _isPropertyValid = false;
      _errorMessage = 'Failed to fetch property details: $e';
    } finally {
      _isLoadingProperty = false;
      notifyListeners();
    }
  }

  /// Backward compatibility wrapper for fetchPostDetails
  Future<void> fetchPostDetails(String identifier) => fetchPropertyDetails(identifier);

  /// Submits the lead form data to the social_leads table in Supabase.
  /// Stores property_id and broker_id directly in social_leads.
  Future<bool> submitLead({
    required String userName,
    required String phone,
    String phoneCountryCode = '91',
    String phoneCountryIso = 'IN',
    String? address,
    String? notes,
    String? propertyId,
    String? brokerId,
  }) async {
    _isSavingLead = true;
    _errorMessage = null;
    notifyListeners();

    // Format notes to include address if present
    String? finalNotes = notes;
    if (address != null && address.trim().isNotEmpty) {
      finalNotes =
          finalNotes != null && finalNotes.trim().isNotEmpty
              ? 'Address: $address\nNotes: $finalNotes'
              : 'Address: $address';
    }

    try {
      final String? targetPropertyId = propertyId ?? _property?.id;
      final String? targetBrokerId = brokerId ?? _property?.brokerId?.id;

      final Map<String, dynamic> leadPayload = {
        'user_name': userName,
        'phone': phone,
        'phone_country_code': phoneCountryCode,
        'phone_country_iso': phoneCountryIso,
        'notes': finalNotes,
        if (targetPropertyId != null && targetPropertyId.isNotEmpty) 'property_id': targetPropertyId,
        if (targetBrokerId != null && targetBrokerId.isNotEmpty) 'broker_id': targetBrokerId,
      };

      await SupabaseConfig.client.from('social_leads').insert(leadPayload);
      _isSubmitted = true;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isSavingLead = false;
      notifyListeners();
    }
  }

  /// Resets the submission state (e.g. for submitting another response).
  void resetForm() {
    _isSubmitted = false;
    _errorMessage = null;
    notifyListeners();
  }
}
