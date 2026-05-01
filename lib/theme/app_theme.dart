import 'package:flutter/material.dart';

/// FSC Portal - Fixed Theme System
/// Proper light and dark themes with working toggle

// ============================================
// COLOR PALETTE
// ============================================

class AppPalette {
  // FSC Brand Colors (from logo)
  static const Color fscRoyalBlue = Color(0xFF1E4FA0);
  static const Color fscCharcoalGray = Color(0xFF3D4449);
  static const Color fscWhite = Color(0xFFFFFFFF);
  static const Color fscBlueLight = Color(0xFF2E6BC0);
  static const Color fscBlueDark = Color(0xFF0E3F80);

  // Dark Theme Colors
  static const Color deepBlack = Color(0xFF121212);
  static const Color darkGrey = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF2A2A2F);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF0F2F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFF9DAAB5);

  // Status Colors (same in both themes)
  static const Color successGreen = Color(0xFF1976D2);
  static const Color warningAmber = Color(0xFFF57C00);
  static const Color alertRed = Color(0xFFD32F2F);
  static const Color purpleAccent = Color(0xFF7B1FA2);

  // Dark Theme Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFB0B0B0);
  static const Color textGreyDark = Color(0xFF808080);

  // Light Theme Text
  static const Color textDark = Color(0xFF1A1D1F);
  static const Color textMedium = Color(0xFF4F5B67);
  static const Color textLight = Color(0xFF6F7C87);

  // Border Colors (aliases for backwards compatibility)
  static const Color borderGrey = darkBorder;
  static const Color borderLight = lightBorder;

  // Other status colors
  static const Color quietDayGreen = Color(0xFF4CAF50);
}

// ============================================
// LAYOUT & TYPOGRAPHY (same for both themes)
// ============================================

class AppLayout {
  // Screen Structure
  static const double sidebarWidth = 240.0;
  static const double rightSidebarWidth = 280.0;
  static const double headerHeight = 64.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double buttonBorderRadius = 8.0;

  // Card Specifications
  static const double cardElevation = 2.0;
  static const double cardPadding = 16.0;
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(16.0);

  // Button Specifications
  static const double buttonHeight = 40.0;
  static const double buttonPaddingH = 16.0;
  static const double buttonPaddingV = 12.0;

  // Navigation Item Specifications
  static const double navItemHeight = 48.0;
  static const double navItemPaddingH = 16.0;
  static const double navIconSize = 24.0;

  // Logo Specifications
  static const double logoSize = 48.0;
  static const EdgeInsets logoPadding = EdgeInsets.only(
    top: 32.0,
    bottom: 16.0,
  );
}

class AppTypography {
  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeSM = 12.0;
  static const double fontSizeMD = 14.0;
  static const double fontSizeLG = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeHuge = 24.0;
  static const double fontSizeMassive = 32.0;

  // Font Weights
  static const FontWeight weightNormal = FontWeight.normal;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.bold;

  // Predefined Text Styles (legacy - use Theme.of(context).textTheme instead)
  static const TextStyle appTitle = TextStyle(
    fontSize: fontSizeXL,
    fontWeight: weightBold,
    color: AppPalette.textWhite,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: fontSizeXXL,
    fontWeight: weightBold,
    color: AppPalette.textWhite,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: AppPalette.textGrey,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: fontSizeLG,
    fontWeight: weightSemiBold,
    color: AppPalette.textWhite,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: fontSizeLG,
    fontWeight: weightSemiBold,
    color: AppPalette.textWhite,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: AppPalette.textGrey,
  );

  static const TextStyle cardNumber = TextStyle(
    fontSize: fontSizeMassive,
    fontWeight: weightBold,
    color: AppPalette.textWhite,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: AppPalette.textGrey,
  );

  static const TextStyle navItemActive = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightSemiBold,
    color: AppPalette.textWhite,
  );

  static const TextStyle navItemInactive = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: AppPalette.textGrey,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightMedium,
    color: AppPalette.textWhite,
  );

  static const TextStyle tagText = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: weightMedium,
    color: AppPalette.textWhite,
  );

  static const TextStyle timestamp = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: weightNormal,
    color: AppPalette.textGrey,
  );
}

// ============================================
// STATUS COLORS THEME EXTENSION
// ============================================

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  final Color warning;
  final Color success;
  final Color info;

  const StatusColors({
    required this.warning,
    required this.success,
    required this.info,
  });

  @override
  StatusColors copyWith({Color? warning, Color? success, Color? info}) {
    return StatusColors(
      warning: warning ?? this.warning,
      success: success ?? this.success,
      info: info ?? this.info,
    );
  }

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

// ============================================
// THEME DEFINITIONS
// ============================================

class AppTheme {
  // ============================================
  // DARK THEME (what works now)
  // ============================================
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,

      // Status Colors Extension
      extensions: const <ThemeExtension>[
        StatusColors(
          warning: AppPalette.warningAmber,
          success: AppPalette.successGreen,
          info: AppPalette.fscBlueLight,
        ),
      ],

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.fscRoyalBlue,
        secondary: AppPalette.fscBlueLight,
        surface: AppPalette.darkGrey,
        error: AppPalette.alertRed,
        onPrimary: AppPalette.textWhite,
        onSecondary: AppPalette.textWhite,
        onSurface: AppPalette.textWhite,
        onError: AppPalette.textWhite,
      ),

      // Backgrounds
      scaffoldBackgroundColor: AppPalette.deepBlack,
      cardColor: AppPalette.darkCard,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.deepBlack,
        foregroundColor: AppPalette.textWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: AppTypography.fontSizeXL,
          fontWeight: AppTypography.weightBold,
          color: AppPalette.textWhite,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppPalette.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusLG),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.darkGrey,
        labelStyle: const TextStyle(color: AppPalette.textGrey),
        hintStyle: const TextStyle(color: AppPalette.textGreyDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          borderSide: const BorderSide(color: AppPalette.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          borderSide: const BorderSide(color: AppPalette.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          borderSide: const BorderSide(
            color: AppPalette.fscRoyalBlue,
            width: 2,
          ),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.fscRoyalBlue,
          foregroundColor: AppPalette.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.buttonBorderRadius),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppPalette.fscRoyalBlue),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppPalette.darkBorder,
        thickness: 1,
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppPalette.textWhite,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppPalette.textWhite,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppPalette.textWhite,
        ),
        headlineLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppPalette.textWhite,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppPalette.textWhite,
        ),
        headlineSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppPalette.textWhite,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppPalette.textWhite),
        bodyMedium: TextStyle(fontSize: 14, color: AppPalette.textGrey),
        bodySmall: TextStyle(fontSize: 12, color: AppPalette.textGreyDark),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppPalette.textWhite,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppPalette.textGrey,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppPalette.textGreyDark,
        ),
      ),
    );
  }

  // ============================================
  // LIGHT THEME (fixed version)
  // ============================================
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,

      // Status Colors Extension
      extensions: const <ThemeExtension>[
        StatusColors(
          warning: AppPalette.warningAmber,
          success: AppPalette.successGreen,
          info: AppPalette.fscBlueLight,
        ),
      ],

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppPalette.fscRoyalBlue,
        secondary: AppPalette.fscBlueLight,
        surface: AppPalette.lightSurface,
        error: AppPalette.alertRed,
        onPrimary: AppPalette.textWhite,
        onSecondary: AppPalette.textWhite,
        onSurface: AppPalette.textDark,
        onError: AppPalette.textWhite,
      ),

      // Backgrounds
      scaffoldBackgroundColor: AppPalette.lightBackground,
      cardColor: AppPalette.lightSurface,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.lightBackground,
        foregroundColor: AppPalette.textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: AppTypography.fontSizeXL,
          fontWeight: AppTypography.weightBold,
          color: AppPalette.textDark,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppPalette.lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusLG),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.lightBackground,
        labelStyle: const TextStyle(color: AppPalette.textMedium),
        hintStyle: const TextStyle(color: AppPalette.textLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          borderSide: const BorderSide(color: AppPalette.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          borderSide: const BorderSide(color: AppPalette.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          borderSide: const BorderSide(
            color: AppPalette.fscRoyalBlue,
            width: 2,
          ),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.fscRoyalBlue,
          foregroundColor: AppPalette.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.buttonBorderRadius),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppPalette.fscRoyalBlue),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppPalette.lightBorder,
        thickness: 1,
      ),

      // Typography (dark text for page backgrounds, override to white inside cards)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppPalette.textDark,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppPalette.textDark,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppPalette.textDark,
        ),
        headlineLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppPalette.textDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppPalette.textDark,
        ),
        headlineSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppPalette.textDark,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppPalette.textDark),
        bodyMedium: TextStyle(fontSize: 14, color: AppPalette.textMedium),
        bodySmall: TextStyle(fontSize: 12, color: AppPalette.textLight),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppPalette.textDark,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppPalette.textMedium,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppPalette.textLight,
        ),
      ),

      // List Tiles
      listTileTheme: const ListTileThemeData(
        textColor: AppPalette.textDark,
        iconColor: AppPalette.fscRoyalBlue,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppPalette.textDark),
    );
  }
}

// ============================================
// SEMANTIC COLOR MAPPING (for legacy code)
// ============================================
// NOTE: For theme-aware code, use Theme.of(context).colorScheme
// These are kept for backwards compatibility with existing components

class AppColors {
  // Core Colors - DEFAULT (dark theme values for backwards compat)
  static const Color background = AppPalette.deepBlack;
  static const Color surface = AppPalette.darkGrey;
  static const Color primary = AppPalette.fscRoyalBlue;

  // Status Colors
  static const Color error = AppPalette.alertRed;
  static const Color success = AppPalette.successGreen;
  static const Color warning = AppPalette.warningAmber;
  static const Color successGreen = AppPalette.successGreen;
  static const Color alertRed = AppPalette.alertRed;

  // Accent Colors
  static const Color purpleAccent = AppPalette.purpleAccent;

  // Text Colors (dark theme defaults)
  static const Color textPrimary = AppPalette.textWhite;
  static const Color textSecondary = AppPalette.textGrey;
  static const Color textTertiary = AppPalette.textGreyDark;

  // Border & Divider
  static const Color border = AppPalette.borderGrey;
  static const Color divider = AppPalette.borderGrey;

  // Status Backgrounds
  static Color successBg = AppPalette.successGreen.withValues(alpha: 0.15);
  static Color infoBg = AppPalette.fscRoyalBlue.withValues(alpha: 0.15);
  static Color errorBg = AppPalette.alertRed.withValues(alpha: 0.15);

  // Map Pins
  static const Color pinNorthwind = Colors.blue;
  static const Color pinLoneStar = Colors.amber;
  static const Color pinGulfCoast = Colors.red;
  static const Color pinStartPoint = AppPalette.successGreen;
}

// ============================================
// ASSET PATH CONSTANTS
// ============================================

class AppAssets {
  static const String logo = 'assets/logo.webp';
  static const String fscLogo = 'assets/FSC_Logo.svg';
  static const String mapStyle = 'assets/map_style_dark.json';
}

// ============================================
// COMPONENT STYLES (Theme-aware versions)
// ============================================

class AppComponents {
  // Header Bar
  static BoxDecoration headerBarDecoration = BoxDecoration(
    color: AppColors.background,
    border: Border(bottom: BorderSide(color: AppPalette.borderGrey, width: 1)),
  );

  // Primary Button Style
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppPalette.fscRoyalBlue,
    foregroundColor: AppPalette.textWhite,
    padding: const EdgeInsets.symmetric(
      horizontal: AppLayout.buttonPaddingH,
      vertical: AppLayout.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppLayout.buttonBorderRadius),
    ),
    elevation: 0,
  );

  // Text Button Style
  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppPalette.fscRoyalBlue,
    padding: const EdgeInsets.symmetric(
      horizontal: AppLayout.spacingSM,
      vertical: AppLayout.spacingXS,
    ),
  );

  // Navigation Item - Active
  static BoxDecoration navItemActiveDecoration = BoxDecoration(
    color: AppPalette.fscRoyalBlue,
    borderRadius: BorderRadius.circular(AppLayout.radiusMD),
  );

  // Navigation Item - Inactive
  static BoxDecoration navItemInactiveDecoration = const BoxDecoration(
    color: Colors.transparent,
  );

  // Card Decorations
  static BoxDecoration summaryCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppLayout.radiusLG),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration infoCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppLayout.radiusLG),
  );

  static BoxDecoration actionCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppLayout.radiusLG),
  );

  static BoxDecoration entryCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppLayout.radiusLG),
  );

  // Tag Decorations
  static BoxDecoration tagQuietDayDecoration = BoxDecoration(
    color: AppPalette.successGreen,
    borderRadius: BorderRadius.circular(AppLayout.radiusSM),
  );

  static BoxDecoration tagLowDecoration = BoxDecoration(
    color: AppPalette.warningAmber,
    borderRadius: BorderRadius.circular(AppLayout.radiusSM),
  );

  static BoxDecoration tagCompletedDecoration = BoxDecoration(
    color: AppPalette.successGreen,
    borderRadius: BorderRadius.circular(AppLayout.radiusSM),
  );

  static EdgeInsets tagPadding = const EdgeInsets.symmetric(
    horizontal: AppLayout.spacingSM,
    vertical: AppLayout.spacingXS,
  );

  // Notification Badge
  static BoxDecoration notificationBadgeDecoration = BoxDecoration(
    color: AppPalette.alertRed,
    shape: BoxShape.circle,
  );

  // User Avatar
  static BoxDecoration userAvatarDecoration = BoxDecoration(
    color: AppPalette.fscRoyalBlue,
    shape: BoxShape.circle,
  );
}

// ============================================
// ICON SPECIFICATIONS
// ============================================

class AppIcons {
  static const double sizeXS = 16.0;
  static const double sizeSM = 20.0;
  static const double sizeMD = 24.0;
  static const double sizeLG = 32.0;
  static const double sizeXL = 48.0;

  static const Color colorPrimary = AppPalette.fscRoyalBlue;
  static const Color colorSuccess = AppPalette.successGreen;
  static const Color colorWarning = AppPalette.warningAmber;
  static const Color colorError = AppPalette.alertRed;
  static const Color colorWhite = AppPalette.textWhite;
  static const Color colorGrey = AppPalette.textGrey;
  static const Color colorPurple = AppPalette.purpleAccent;
}

// ============================================
// GRADIENTS
// ============================================

class AppGradients {
  static const LinearGradient deepOcean = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF020617)],
  );

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E4FA0), Color(0xFF0E3F80)],
  );

  static LinearGradient glassSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.02)],
  );

  static LinearGradient borderShine = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withValues(alpha: 0.1),
      Colors.white.withValues(alpha: 0.0),
      Colors.white.withValues(alpha: 0.02),
    ],
    stops: const [0.0, 0.5, 1.0],
  );
}

class AppGlass {
  static const double blurSigma = 10.0;

  static BoxDecoration mediumDecoration = BoxDecoration(
    gradient: AppGradients.glassSurface,
    borderRadius: BorderRadius.circular(AppLayout.radiusLG),
    border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 16,
        spreadRadius: 2,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration activeDecoration = BoxDecoration(
    color: AppPalette.fscRoyalBlue.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(AppLayout.radiusMD),
    border: Border.all(
      color: AppPalette.fscRoyalBlue.withValues(alpha: 0.3),
      width: 1,
    ),
  );
}

class AppAnimations {
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve emphasis = Curves.easeInOutCubic;
  static const Curve entrance = Curves.easeOutQuad;
  static const Curve exit = Curves.easeInQuad;
}

// ============================================
// SPACING SYSTEM
// ============================================

class AppSpacing {
  static const SizedBox v4 = SizedBox(height: 4);
  static const SizedBox v8 = SizedBox(height: 8);
  static const SizedBox v12 = SizedBox(height: 12);
  static const SizedBox v16 = SizedBox(height: 16);
  static const SizedBox v24 = SizedBox(height: 24);
  static const SizedBox v32 = SizedBox(height: 32);
  static const SizedBox v48 = SizedBox(height: 48);

  static const SizedBox h4 = SizedBox(width: 4);
  static const SizedBox h8 = SizedBox(width: 8);
  static const SizedBox h12 = SizedBox(width: 12);
  static const SizedBox h16 = SizedBox(width: 16);
  static const SizedBox h24 = SizedBox(width: 24);
  static const SizedBox h32 = SizedBox(width: 32);
}
