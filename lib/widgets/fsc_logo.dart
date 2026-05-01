/// FSC Logo Widget
/// Components must never reference logo files directly.
/// Uses AssetResolver to select appropriate variant.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../theme/asset_resolver.dart';
import '../providers/theme_provider.dart';

class FscLogo extends StatelessWidget {
  /// Logo dimensions. Preserves aspect ratio.
  final double? width;
  final double? height;

  /// Optional explicit background brightness override.
  /// If null, resolver determines from theme.
  final Brightness? backgroundBrightness;

  /// Fit mode for the logo.
  final BoxFit fit;

  const FscLogo({
    super.key,
    this.width,
    this.height,
    this.backgroundBrightness,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    
    final resolver = AssetResolver(
      settings: themeProvider.settings,
      systemBrightness: systemBrightness,
    );

    final logoPath = resolver.resolveLogo(
      backgroundContext: backgroundBrightness,
    );

    return SvgPicture.asset(
      logoPath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
