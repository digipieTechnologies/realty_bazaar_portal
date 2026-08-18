// File: lib/providers/form/form_provider.dart
// Purpose: Handles post loading by Meta post_id and lead form submission logic.

import 'package:flutter/material.dart';

import '../../core/supabase/supabase_config.dart';
import '../../models/social_post_model.dart';

class FormProvider extends ChangeNotifier {
  SocialPostModel? _post;
  bool _isLoadingPost = false;
  bool? _isPostValid; // null = unchecked, true = valid, false = invalid
  bool _isSavingLead = false;
  bool _isSubmitted = false;
  String? _errorMessage;

  SocialPostModel? get post => _post;
  bool get isLoadingPost => _isLoadingPost;
  bool? get isPostValid => _isPostValid;
  bool get isSavingLead => _isSavingLead;
  bool get isSubmitted => _isSubmitted;
  String? get errorMessage => _errorMessage;

  /// Fetches a social post by its Meta post_id (e.g. 475656465456) in the database
  /// Includes related property and address information
  Future<void> fetchPostDetails(String postId) async {
    _isLoadingPost = true;
    _errorMessage = null;
    _post = null;
    _isPostValid = null;
    notifyListeners();

    try {
      final response =
          await SupabaseConfig.client
              .from('social_posts')
              .select('*, properties(*, addresses(*))')
              .eq('post_id', postId)
              .maybeSingle();

      if (response != null) {
        _post = SocialPostModel.fromJson(response);
        _isPostValid = true;
      } else {
        _isPostValid = false;
        _errorMessage = 'Listing not found.';
      }
    } catch (e) {
      debugPrint('Database query failed: $e');
      _isPostValid = false;
      _errorMessage = 'Failed to fetch details: $e';
    } finally {
      _isLoadingPost = false;
      notifyListeners();
    }
  }

  /// Submits the lead form data to the social_leads table in Supabase.
  /// Stores broker_id from the social post record if present.
  Future<bool> submitLead({
    required String userName,
    required String phone,
    String phoneCountryCode = '91',
    String phoneCountryIso = 'IN',
    String? address,
    String? notes,
    String? socialPostId, // This is the database UUID (social_posts.id)
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
      final Map<String, dynamic> leadPayload = {
        'user_name': userName,
        'phone': phone,
        'phone_country_code': phoneCountryCode,
        'phone_country_iso': phoneCountryIso,
        'notes': finalNotes,
        'social_post_id': socialPostId,
      };

      // If broker_id is present on the fetched social post, store it in social_leads
      if (_post?.brokerId?.id != null && _post!.brokerId!.id!.isNotEmpty) {
        leadPayload['broker_id'] = _post!.brokerId!.id;
      }

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
