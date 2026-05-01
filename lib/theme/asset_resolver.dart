/// Asset Resolver
/// Maps settings → tokens/assets.
/// Components must never reference asset files directly.
library;

import 'package:flutter/material.dart';
import 'settings_schema.dart';
import 'semantic_tokens.dart';

// =============================================================================
// LOGO ASSETS (Invariant paths)
// =============================================================================

class LogoAssets {
  static const String dark = 'assets/logo-dark.svg';
  static const String light = 'assets/logo-light.svg';
  static const String raster = 'assets/logo.webp';

  LogoAssets._();
}

// =============================================================================
// ASSET RESOLVER
// =============================================================================

class AssetResolver {
  final UserSettings settings;
  final Brightness systemBrightness;

  const AssetResolver({
    required this.settings,
    required this.systemBrightness,
  });

  /// Resolve effective brightness from settings
  Brightness get resolvedBrightness {
    switch (settings.theme) {
      case ThemeSetting.light:
        return Brightness.light;
      case ThemeSetting.dark:
        return Brightness.dark;
      case ThemeSetting.system:
        return systemBrightness;
    }
  }

  /// Resolve semantic tokens
  SemanticTokens get tokens => TokenRegistry.resolve(resolvedBrightness);

  /// Resolve logo path based on settings and background context
  /// 
  /// [backgroundContext] - Optional override for specific background scenarios.
  /// If null, uses the resolved theme brightness.
  String resolveLogo({Brightness? backgroundContext}) {
    // Explicit user override
    if (settings.logoVariant == LogoVariantSetting.light) {
      return LogoAssets.light;
    }
    if (settings.logoVariant == LogoVariantSetting.dark) {
      return LogoAssets.dark;
    }

    // Auto: determine from background
    final effectiveBrightness = backgroundContext ?? resolvedBrightness;

    // Dark background → use dark variant (white logo)
    // Light background → use light variant (blue logo)
    return effectiveBrightness == Brightness.dark
        ? LogoAssets.dark
        : LogoAssets.light;
  }

  /// Resolve raster logo fallback
  String get rasterLogo => LogoAssets.raster;

  /// Check if current theme is dark
  bool get isDarkTheme => resolvedBrightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLightTheme => resolvedBrightness == Brightness.light;
}

// =============================================================================
// RESOLVER PROVIDER EXTENSION
// =============================================================================

extension AssetResolverContext on BuildContext {
  /// Get asset resolver from context
  /// Requires ThemeProvider to be in the widget tree
  AssetResolver getAssetResolver(UserSettings settings) {
    final brightness = MediaQuery.platformBrightnessOf(this);
    return AssetResolver(
      settings: settings,
      systemBrightness: brightness,
    );
  }
}
