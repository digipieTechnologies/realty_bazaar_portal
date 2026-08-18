// File: lib/widgets/images/cached_image.dart
// Purpose: Image widget caching network image requests with placeholder/fallback capability.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/app_assets.dart';
import '../../app/app_colors.dart';
import '../../util/common_ext.dart';

class CachedImage extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? imageBytes;
  final double height;
  final double width;
  final double borderWidth;
  final BoxFit fit;
  final String? placeholder;
  final Color? borderColor;
  final BorderRadius borderRadius;

  const CachedImage(
    this.imageUrl, {
    super.key,
    this.height = 50.0,
    this.width = 50.0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.imageBytes,
    this.borderRadius = BorderRadius.zero,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    // Single placeholder and fallback widget
    final Widget placeHolderWidget = Container(
      height: widget.height,
      width: widget.width,
      decoration: const BoxDecoration(color: AppColors.background),
      child: Image.asset(
        widget.placeholder ?? AppAssets.logo,
        height: widget.height,
        width: widget.width,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
      ),
    );

    try {
      final imageChild = Container(
        decoration: BoxDecoration(
          border: widget.borderColor != null
              ? Border.all(
                  color: widget.borderColor!,
                  width: widget.borderWidth,
                )
              : null,
          borderRadius: widget.borderRadius,
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: Builder(
            builder: (context) {
              final image = widget.imageUrl ?? '';
              final isAssetsImage = image.startsWith('assets/');
              final isNetWorkImage = image.startsWith('http');

              final dpr = MediaQuery.devicePixelRatioOf(context);
              final screenWidth = context.width;
              final effectiveWidth =
                  (widget.width > 0 && widget.width != double.infinity)
                  ? widget.width
                  : screenWidth;
              final cacheWidth = (effectiveWidth * dpr).round();

              if (widget.imageBytes != null) {
                return Image.memory(
                  widget.imageBytes!,
                  fit: widget.fit,
                  height: widget.height,
                  width: widget.width,
                  cacheWidth: cacheWidth,
                  filterQuality: FilterQuality.low,
                );
              }
              if (isAssetsImage && widget.imageUrl != null) {
                return Image.asset(
                  widget.imageUrl!,
                  fit: widget.fit,
                  height: widget.height,
                  width: widget.width,
                  cacheWidth: cacheWidth,
                  filterQuality: FilterQuality.low,
                );
              }
              if (isNetWorkImage && widget.imageUrl != null) {
                return CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  cacheKey: widget.imageUrl,
                  fit: widget.fit,
                  height: widget.height,
                  width: widget.width,
                  memCacheWidth: cacheWidth,
                  fadeInDuration: const Duration(milliseconds: 50),
                  placeholder: (context, url) => placeHolderWidget,
                  errorWidget: (context, url, error) => placeHolderWidget,
                );
              }
              if (widget.imageUrl == null || image.isEmpty) {
                return placeHolderWidget;
              }
              return Image.file(
                File(widget.imageUrl!),
                fit: widget.fit,
                height: widget.height,
                width: widget.width,
                cacheWidth: cacheWidth,
                filterQuality: FilterQuality.low,
              );
            },
          ),
        ),
      );

      return imageChild;
    } catch (e) {
      return ClipRRect(
        borderRadius: widget.borderRadius,
        child: Image.asset(
          AppAssets.logo,
          height: widget.height,
          width: widget.width,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
        ),
      );
    }
  }
}
