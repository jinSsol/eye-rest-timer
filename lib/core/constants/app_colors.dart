import 'package:flutter/material.dart';

/// 앱에서 사용하는 색상 정의 - Nuny 스타일 올리브/세이지 그린
class AppColors {
  AppColors._();

  // Primary colors - 부드러운 올리브/세이지 그린
  static const Color primary = Color(0xFF8B9A7D);
  static const Color primaryLight = Color(0xFFB5C4A8);
  static const Color primaryDark = Color(0xFF6B7A5D);

  // Background gradients
  static const Color bgGreenLight = Color(0xFFD4E4C9);
  static const Color bgGreenDark = Color(0xFF9BB08A);
  static const Color bgYellowLight = Color(0xFFFFF9E6);
  static const Color bgYellowDark = Color(0xFFF5E6A3);

  // Accent colors
  static const Color accent = Color(0xFFE8B4B8);
  static const Color coral = Color(0xFFE07A7A);
  static const Color yellow = Color(0xFFF5D76E);
  static const Color blue = Color(0xFF7EB6D8);
  static const Color skyBlue = Color(0xFFB5D8FF);
  static const Color peach = Color(0xFFFFCBA4);
  static const Color lavender = Color(0xFFD4B5FF);
  static const Color warning = Color(0xFFFFD93D);
  static const Color confettiRed = Color(0xFFE57373);
  static const Color confettiYellow = Color(0xFFFFD54F);
  static const Color confettiBlue = Color(0xFF64B5F6);

  // Timer colors
  static const Color timerBackground = Color(0xFFE8E8E8);
  static const Color timerBackgroundDark = Color(0xFF3A3A5C);

  // Surface colors
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Character colors
  static const Color eyeWhite = Color(0xFFFFFFFF);
  static const Color eyePupil = Color(0xFF2D3436);
  static const Color eyeBlue = Color(0xFF74B9E7);
  static const Color characterBody = Color(0xFF74B9E7);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFFFFFFF);

  // Button colors
  static const Color buttonPrimary = Color(0xFF6B7A5D);
  static const Color buttonLight = Color(0xFFFFFFFF);

  // Dark mode
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceDark = Color(0xFF252542);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color cardDark = Color(0xFF2D2D4A);

  // Dark mode gradients
  static const Color bgDarkLight = Color(0xFF2A2A45);
  static const Color bgDarkDeep = Color(0xFF1A1A2E);
  static const Color bgDarkGreen = Color(0xFF2D4A3A);
  static const Color bgDarkGreenLight = Color(0xFF3D5A4A);

  // Gradients
  static const List<Color> greenGradient = [bgGreenLight, bgGreenDark];
  static const List<Color> yellowGradient = [bgYellowLight, bgYellowDark];
  static const List<Color> primaryGradient = [primary, skyBlue];
  static const List<Color> restGradient = [accent, lavender];
}
