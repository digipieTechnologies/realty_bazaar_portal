// File: lib/widgets/icons/whatsapp_icon_widget.dart
// Purpose: Modular reusable WhatsApp brand image icon widget.

import 'package:flutter/material.dart';

class WhatsappIconWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const WhatsappIconWidget({
    super.key,
    this.size = 20.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/whatsapp.png',
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
    );
  }
}
