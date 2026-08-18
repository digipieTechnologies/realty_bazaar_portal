// File: lib/modules/form/screens/lead_form_screen.dart
// Purpose: Interactive lead generation form screen with UUID validation and database submission.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../widgets/images/cached_image.dart';
import '../../../widgets/loaders/app_loader.dart';
import '../../../widgets/toast/app_toast.dart';
import '../../../providers/form/form_provider.dart';
import '../../../models/social_post_model.dart';
import '../../../models/social_enums.dart';

class LeadFormScreen extends StatefulWidget {
  final String? postId;

  const LeadFormScreen({
    super.key,
    this.postId,
  });

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fetch linked post details if postId is provided
    if (widget.postId != null && widget.postId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FormProvider>().fetchPostDetails(widget.postId!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanValue.length != 10) {
      return 'Number must be exactly 10 digits';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanValue)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      AppToast.showError('Invalid Form', 'Please correct the errors in the form.');
      return;
    }

    final provider = context.read<FormProvider>();
    final contactVal = _phoneController.text.trim();

    final success = await provider.submitLead(
      userName: _nameController.text.trim(),
      phone: contactVal,
      phoneCountryCode: '91',
      phoneCountryIso: 'IN',
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      socialPostId: provider.post?.id,
    );

    if (success && mounted) {
      AppToast.showSuccess('Submitted!', 'Inquiry received successfully.');
    } else if (mounted) {
      AppToast.showError('Error', provider.errorMessage ?? 'Submission failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<FormProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0E7FF), // Richer Light Indigo
              Color(0xFFF8FAFC), // Slate 50
              Color(0xFFCCFBF1), // Richer Light Teal
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form Card
                  Card(
                    elevation: 12.0,
                    shadowColor: AppColors.primary.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: const BorderSide(color: AppColors.border, width: 1.0),
                    ),
                    color: AppColors.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: _buildCardContent(formProvider),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  
                  // Powered By Footer
                  Center(
                    child: Text(
                      'Powered by BrokerHive',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(FormProvider provider) {
    if (widget.postId == null || widget.postId!.isEmpty) {
      return _buildErrorState('Invalid listing reference. Please request a new form link.');
    }

    if (provider.isLoadingPost) {
      return _buildLoaderState();
    }

    if (provider.isPostValid == false) {
      return _buildErrorState('Listing Link Invalid\nThe listing link you followed is invalid or has expired. Please verify the URL and try again.');
    }

    if (provider.isSubmitted) {
      return _buildSuccessState(provider);
    }

    return _buildFormState(provider);
  }

  Widget _buildLoaderState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom Rotating Logo Loader
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80.0,
                height: 80.0,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary.withValues(alpha: 0.8)),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  'assets/logo/app_logo.png',
                  width: 56.0,
                  height: 56.0,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Verifying Listing Details',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Connecting to database services...',
            style: AppTextStyles.body2,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            message.contains('\n') ? message.split('\n')[0] : 'Listing Link Invalid',
            style: AppTextStyles.heading3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            message.contains('\n') ? message.split('\n')[1] : message,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormState(FormProvider provider) {
    final post = provider.post!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Logo & Title
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/logo/app_logo.png',
                    width: 64.0,
                    height: 64.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'BrokerHive Connect',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Tell us a bit about yourself to receive detailed brochures, pricing, and availability updates for this property.',
                  style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          const Divider(color: AppColors.divider, height: 1.0),
          const SizedBox(height: 24.0),

          // Linked Post Preview
          _buildPostPreviewCard(post),
          const SizedBox(height: 24.0),

          // Name Field
          _buildFieldLabel('Full Name *'),
          TextFormField(
            controller: _nameController,
            style: AppTextStyles.textField,
            textCapitalization: TextCapitalization.words,
            decoration: _buildInputDecoration(
              hint: 'Enter your full name',
              prefixIconWidget: _buildFieldPrefix(
                iconWidget: const Icon(Icons.person_outline_rounded, size: 20.0, color: AppColors.primary),
                isEnabled: true,
              ),
            ),
            validator: _validateName,
          ),
          const SizedBox(height: 20.0),

          // Contact Number Field
          _buildFieldLabel('Contact Number *'),
          TextFormField(
            controller: _phoneController,
            style: AppTextStyles.textField,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: _buildInputDecoration(
              hint: '10-digit mobile number',
              prefixIconWidget: _buildFieldPrefix(
                iconWidget: const Icon(Icons.phone_outlined, size: 20.0, color: AppColors.primary),
                isEnabled: true,
                showCountryCode: true,
              ),
            ),
            validator: _validatePhone,
          ),
          const SizedBox(height: 20.0),

          // Notes Field (Optional)
          _buildFieldLabel('Special Notes / Requests (Optional)'),
          TextFormField(
            controller: _notesController,
            style: AppTextStyles.textField,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: _buildInputDecoration(
              hint: 'Any specific property parameters or queries?',
              prefixIconWidget: _buildFieldPrefix(
                iconWidget: const Icon(Icons.edit_note_outlined, size: 20.0, color: AppColors.primary),
                isEnabled: true,
              ),
            ),
          ),
          const SizedBox(height: 28.0),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: provider.isSavingLead ? null : _handleSubmit,
              child: provider.isSavingLead
                  ? const AppLoader(size: 20.0, color: Colors.white)
                  : const Text('Save & Connect', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(FormProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 64.0,
          ),
        ),
        const SizedBox(height: 24.0),
        const Text(
          'Inquiry Submitted Successfully!',
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12.0),
        Text(
          'Your interest has been successfully registered. A verified broker will review your details and contact you shortly. Thank you for connecting with us!',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32.0),
        SizedBox(
          width: double.infinity,
          height: 46.0,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () {
              provider.resetForm();
              _nameController.clear();
              _phoneController.clear();
              _notesController.clear();
            },
            child: Text(
              'Submit Another Request',
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostPreviewCard(SocialPostModel post) {
    final hasImage = post.mediaUrls != null && post.mediaUrls!.isNotEmpty;
    final firstMedia = hasImage ? post.mediaUrls!.first : null;
    final isFB = post.platform == SocialPlatform.facebook || post.platform?.name == 'facebook';

    // Display property location (full address) if property is present, otherwise fallback to reel caption
    final addressObj = post.property?.address;
    final fullAddressStr = addressObj?.fullAddress.trim();
    final cityStr = addressObj?.city?.trim();
    
    String? propertyLocationText;
    if (fullAddressStr != null && fullAddressStr.isNotEmpty) {
      propertyLocationText = fullAddressStr;
    } else if (cityStr != null && cityStr.isNotEmpty) {
      propertyLocationText = cityStr;
    } else if (post.property?.propertyTitle != null && post.property!.propertyTitle.trim().isNotEmpty) {
      propertyLocationText = post.property!.propertyTitle.trim();
    }

    final displayText = propertyLocationText ??
        (post.caption != null && post.caption!.isNotEmpty
            ? post.caption!
            : 'Video or image update without description.');

    String? mediaUrl;
    if (firstMedia != null) {
      if (firstMedia is Map) {
        mediaUrl = firstMedia['thumbnail']?.toString() ??
            firstMedia['thumbnail_url']?.toString() ??
            firstMedia['url']?.toString() ??
            firstMedia['media_url']?.toString();
      } else {
        mediaUrl = firstMedia.toString();
      }
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Row(
        children: [
          // Post Thumbnail
          if (mediaUrl != null && mediaUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: 52.0,
                height: 52.0,
                child: CachedImage(
                  mediaUrl,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 52.0,
              height: 52.0,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                isFB ? Icons.facebook_rounded : Icons.camera_alt_outlined,
                color: isFB ? const Color(0xFF1877F2) : const Color(0xFFE1306C),
              ),
            ),
          const SizedBox(width: 12.0),
          // Post Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      propertyLocationText != null
                          ? Icons.location_on_rounded
                          : (isFB ? Icons.facebook_rounded : Icons.camera_alt_outlined),
                      size: 14.0,
                      color: isFB ? const Color(0xFF1877F2) : const Color(0xFFE1306C),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      propertyLocationText != null
                          ? 'Property Location'
                          : (isFB ? 'Linked Facebook Post' : 'Linked Instagram Media'),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isFB ? const Color(0xFF1877F2) : const Color(0xFFE1306C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  displayText,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12.0,
                    fontWeight: propertyLocationText != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(text, style: AppTextStyles.label),
    );
  }

  Widget _buildFieldPrefix({
    required Widget iconWidget,
    required bool isEnabled,
    bool showCountryCode = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 16.0),
        iconWidget,
        if (showCountryCode) ...[
          const SizedBox(width: 8.0),
          Text(
            '+91 ',
            style: AppTextStyles.textField.copyWith(
              fontWeight: FontWeight.bold,
              color: isEnabled ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 4.0),
          Container(
            width: 1.0,
            height: 16.0,
            color: AppColors.border,
          ),
        ],
        const SizedBox(width: 12.0),
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required Widget prefixIconWidget,
    bool isEnabled = true,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 13.0),
      prefixIcon: prefixIconWidget,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
      filled: !isEnabled,
      fillColor: isEnabled ? Colors.transparent : AppColors.divider,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
