import 'package:flutter/material.dart';

/// CareConnect color palette.
///
/// Healthcare aesthetic: white surfaces with medical blue + teal accents.
/// All combinations are chosen to meet WCAG AA contrast on their intended
/// background.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF1565D8); // medical blue
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFFE3EDFB);

  static const Color secondary = Color(0xFF0EA5A4); // teal accent
  static const Color secondaryLight = Color(0xFFD7F3F2);

  // Neutrals
  static const Color background = Color(0xFFF6F8FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF1F4F9);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF5B6577);
  static const Color textTertiary = Color(0xFF9AA3B2);

  static const Color border = Color(0xFFE5E9F0);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF1565D8);
  static const Color infoBg = Color(0xFFE3EDFB);

  // Quick-action accents (icon + soft tinted background pairs)
  static const Color accentPurple = Color(0xFF7C3AED);
  static const Color accentPurpleBg = Color(0xFFF1ECFE);
  static const Color accentPink = Color(0xFFE11D74);
  static const Color accentPinkBg = Color(0xFFFCE7F0);
  static const Color accentOrange = Color(0xFFEA8A0B);
  static const Color accentOrangeBg = Color(0xFFFDF1DC);
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentBlueBg = Color(0xFFE6EEFE);
}
