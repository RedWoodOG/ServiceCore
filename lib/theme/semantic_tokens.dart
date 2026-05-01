/// Semantic Token System
/// Components must reference tokens, never raw values.
library;

import 'package:flutter/material.dart';

// =============================================================================
// SEMANTIC TOKENS (ABSTRACT)
// =============================================================================

abstract class SemanticTokens {
  // Background
  Color get bgPrimary;
  Color get bgSecondary;
  Color get bgTertiary;

  // Foreground
  Color get fgPrimary;
  Color get fgSecondary;
  Color get fgMuted;

  // Accent
  Color get accent;
  Color get accentMuted;

  // Border
  Color get border;
  Color get borderMuted;

  // Status (invariant across themes)
  Color get statusSuccess;
  Color get statusWarning;
  Color get statusError;

  // Surface
  Color get surfaceCard;
  Color get surfaceElevated;
}

// =============================================================================
// THEME MAPS
// =============================================================================

class DarkThemeTokens implements SemanticTokens {
  const DarkThemeTokens();

  @override
  Color get bgPrimary => const Color(0xFF121212);
  @override
  Color get bgSecondary => const Color(0xFF1E1E1E);
  @override
  Color get bgTertiary => const Color(0xFF2A2A2F);

  @override
  Color get fgPrimary => const Color(0xFFFFFFFF);
  @override
  Color get fgSecondary => const Color(0xFFB0B0B0);
  @override
  Color get fgMuted => const Color(0xFF808080);

  @override
  Color get accent => const Color(0xFF1E4FA0);
  @override
  Color get accentMuted => const Color(0xFF2E6BC0);

  @override
  Color get border => const Color(0xFF2A2A2F);
  @override
  Color get borderMuted => const Color(0xFF3D3D42);

  @override
  Color get statusSuccess => const Color(0xFF03DAC6);
  @override
  Color get statusWarning => const Color(0xFFFFC107);
  @override
  Color get statusError => const Color(0xFFCF6679);

  @override
  Color get surfaceCard => const Color(0xFF1E1E1E);
  @override
  Color get surfaceElevated => const Color(0xFF2A2A2F);
}

class LightThemeTokens implements SemanticTokens {
  const LightThemeTokens();

  @override
  Color get bgPrimary => const Color(0xFFFFFFFF);
  @override
  Color get bgSecondary => const Color(0xFFF5F7FA);
  @override
  Color get bgTertiary => const Color(0xFFE8ECF0);

  @override
  Color get fgPrimary => const Color(0xFF1A1D1F);
  @override
  Color get fgSecondary => const Color(0xFF4F5B67);
  @override
  Color get fgMuted => const Color(0xFF6F7C87);

  @override
  Color get accent => const Color(0xFF1E4FA0);
  @override
  Color get accentMuted => const Color(0xFF2E6BC0);

  @override
  Color get border => const Color(0xFFE0E4E8);
  @override
  Color get borderMuted => const Color(0xFFD0D4D8);

  @override
  Color get statusSuccess => const Color(0xFF03DAC6);
  @override
  Color get statusWarning => const Color(0xFFFFC107);
  @override
  Color get statusError => const Color(0xFFCF6679);

  @override
  Color get surfaceCard => const Color(0xFFFFFFFF);
  @override
  Color get surfaceElevated => const Color(0xFFF5F7FA);
}

// =============================================================================
// TOKEN REGISTRY (Singleton)
// =============================================================================

class TokenRegistry {
  static const SemanticTokens dark = DarkThemeTokens();
  static const SemanticTokens light = LightThemeTokens();

  static SemanticTokens resolve(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}
