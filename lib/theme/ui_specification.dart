/// FSC Portal - Complete UI Specification
/// Comprehensive documentation of all visual elements, colors, layout, and components
/// Based on the actual application screenshot
library;

import 'package:flutter/material.dart';

// ============================================
// COLOR PALETTE - Complete Reference
// ============================================

class UIPalette {
  // Background Colors
  static const Color deepBlack = Color(0xFF121212); // Main background
  static const Color darkGrey = Color(0xFF1E1E1E); // Cards, surfaces, selected nav items
  static const Color cardBackground = Color(0xFF1E1E1E); // Card backgrounds
  
  // Primary Brand Colors
  static const Color portalBlue = Color(0xFF0056D2); // Primary brand blue
  static const Color portalBlueLight = Color(0xFF1E6FE8); // Lighter blue variant
  
  // Status Colors
  static const Color successGreen = Color(0xFF03DAC6); // Completed, checkmarks
  static const Color warningAmber = Color(0xFFFFC107); // Low priority, warnings
  static const Color alertRed = Color(0xFFCF6679); // Notification badges, errors
  static const Color quietDayGreen = Color(0xFF4CAF50); // "Quiet Day" tag background
  
  // Accent Colors
  static const Color purpleAccent = Color(0xFF9C27B0); // Graph icons, purple accents
  
  // Text Colors
  static const Color textWhite = Color(0xFFFFFFFF); // Primary text, titles, numbers
  static const Color textGrey = Color(0xFFB0B0B0); // Secondary text, subtitles
  static const Color textGreyDark = Color(0xFF808080); // Tertiary text
  
  // Border Colors
  static const Color borderGrey = Color(0xFF2A2A2F); // Subtle borders
}

// ============================================
// LAYOUT SPECIFICATIONS
// ============================================

class UILayout {
  // Screen Structure
  static const double sidebarWidth = 240.0; // Left navigation sidebar
  static const double rightSidebarWidth = 280.0; // Right sidebar (Dispatch Insights)
  static const double headerHeight = 64.0; // Top header bar
  
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
  
  // Card Specifications
  static const double cardElevation = 2.0;
  static const double cardPadding = 16.0;
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(16.0);
  
  // Button Specifications
  static const double buttonHeight = 40.0;
  static const double buttonPaddingH = 16.0;
  static const double buttonPaddingV = 12.0;
  static const double buttonBorderRadius = 8.0;
  
  // Navigation Item Specifications
  static const double navItemHeight = 48.0;
  static const double navItemPaddingH = 16.0;
  static const double navIconSize = 24.0;
}

// ============================================
// TYPOGRAPHY SPECIFICATIONS
// ============================================

class UITypography {
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
  
  // Text Styles
  static const TextStyle appTitle = TextStyle(
    fontSize: fontSizeXL,
    fontWeight: weightBold,
    color: UIPalette.textWhite,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontSize: fontSizeXXL,
    fontWeight: weightBold,
    color: UIPalette.textWhite,
  );
  
  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: UIPalette.textGrey,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: fontSizeLG,
    fontWeight: weightSemiBold,
    color: UIPalette.textWhite,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: UIPalette.textGrey,
  );
  
  static const TextStyle cardNumber = TextStyle(
    fontSize: fontSizeMassive,
    fontWeight: weightBold,
    color: UIPalette.textWhite,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: UIPalette.textGrey,
  );
  
  static const TextStyle navItemActive = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightSemiBold,
    color: UIPalette.textWhite,
  );
  
  static const TextStyle navItemInactive = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightNormal,
    color: UIPalette.textGrey,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: fontSizeMD,
    fontWeight: weightMedium,
    color: UIPalette.textWhite,
  );
  
  static const TextStyle tagText = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: weightMedium,
    color: UIPalette.textWhite,
  );
  
  static const TextStyle timestamp = TextStyle(
    fontSize: fontSizeSM,
    fontWeight: weightNormal,
    color: UIPalette.textGrey,
  );
}

// ============================================
// COMPONENT SPECIFICATIONS
// ============================================

class UIComponents {
  // ============================================
  // HEADER BAR
  // ============================================
  
  static BoxDecoration headerBarDecoration = BoxDecoration(
    color: UIPalette.deepBlack,
    border: Border(
      bottom: BorderSide(
        color: UIPalette.borderGrey,
        width: 1,
      ),
    ),
  );
  
  static TextStyle headerAppName = const TextStyle(
    fontSize: UITypography.fontSizeLG,
    fontWeight: UITypography.weightMedium,
    color: UIPalette.textWhite,
  );
  
  // Header Buttons
  static ButtonStyle headerButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: UIPalette.portalBlue,
    foregroundColor: UIPalette.textWhite,
    padding: const EdgeInsets.symmetric(
      horizontal: UILayout.buttonPaddingH,
      vertical: UILayout.buttonPaddingV,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(UILayout.buttonBorderRadius),
    ),
    elevation: 0,
  );
  
  // Notification Badge
  static BoxDecoration notificationBadgeDecoration = BoxDecoration(
    color: UIPalette.alertRed,
    shape: BoxShape.circle,
  );
  
  // ============================================
  // LEFT NAVIGATION SIDEBAR
  // ============================================
  
  static BoxDecoration sidebarDecoration = const BoxDecoration(
    color: UIPalette.deepBlack,
  );
  
  // Logo Area
  static const double logoSize = 48.0;
  static const EdgeInsets logoPadding = EdgeInsets.only(
    top: UILayout.spacingXL,
    bottom: UILayout.spacingMD,
  );
  
  // Navigation Items
  static BoxDecoration navItemActiveDecoration = BoxDecoration(
    color: UIPalette.portalBlue,
    borderRadius: BorderRadius.circular(UILayout.radiusMD),
  );
  
  static BoxDecoration navItemInactiveDecoration = const BoxDecoration(
    color: Colors.transparent,
  );
  
  static EdgeInsets navItemPadding = const EdgeInsets.symmetric(
    horizontal: UILayout.navItemPaddingH,
    vertical: UILayout.spacingSM,
  );
  
  // Dark Mode Toggle
  static TextStyle darkModeLabel = const TextStyle(
    fontSize: UITypography.fontSizeMD,
    fontWeight: UITypography.weightNormal,
    color: UIPalette.textGrey,
  );
  
  // User Profile Section
  static BoxDecoration userAvatarDecoration = BoxDecoration(
    color: UIPalette.portalBlue,
    shape: BoxShape.circle,
  );
  
  static TextStyle userName = const TextStyle(
    fontSize: UITypography.fontSizeMD,
    fontWeight: UITypography.weightSemiBold,
    color: UIPalette.textWhite,
  );
  
  static TextStyle userRole = const TextStyle(
    fontSize: UITypography.fontSizeSM,
    fontWeight: UITypography.weightNormal,
    color: UIPalette.textGrey,
  );
  
  // ============================================
  // MAIN CONTENT AREA
  // ============================================
  
  static BoxDecoration mainContentDecoration = const BoxDecoration(
    color: UIPalette.deepBlack,
  );
  
  static EdgeInsets mainContentPadding = const EdgeInsets.all(UILayout.spacingXL);
  
  // Section Headers
  static EdgeInsets sectionHeaderPadding = const EdgeInsets.only(
    bottom: UILayout.spacingMD,
  );
  
  // Tag Styles
  static BoxDecoration tagQuietDayDecoration = BoxDecoration(
    color: UIPalette.quietDayGreen,
    borderRadius: BorderRadius.circular(UILayout.radiusSM),
  );
  
  static BoxDecoration tagLowDecoration = BoxDecoration(
    color: UIPalette.warningAmber,
    borderRadius: BorderRadius.circular(UILayout.radiusSM),
  );
  
  static BoxDecoration tagCompletedDecoration = BoxDecoration(
    color: UIPalette.successGreen,
    borderRadius: BorderRadius.circular(UILayout.radiusSM),
  );
  
  static EdgeInsets tagPadding = const EdgeInsets.symmetric(
    horizontal: UILayout.spacingSM,
    vertical: UILayout.spacingXS,
  );
  
  // ============================================
  // SUMMARY CARDS (Top Row)
  // ============================================
  
  static BoxDecoration summaryCardDecoration = BoxDecoration(
    color: UIPalette.darkGrey,
    borderRadius: BorderRadius.circular(UILayout.radiusLG),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static EdgeInsets summaryCardPadding = const EdgeInsets.all(UILayout.cardPadding);
  
  static const double summaryCardIconSize = 32.0;
  static const double summaryCardGraphIconSize = 16.0;
  
  // Card Icons Colors
  static const Color cardIconBlue = UIPalette.portalBlue;
  static const Color cardIconGreen = UIPalette.successGreen;
  static const Color cardIconPurple = UIPalette.purpleAccent;
  
  // ============================================
  // INFORMATION CARDS
  // ============================================
  
  static BoxDecoration infoCardDecoration = BoxDecoration(
    color: UIPalette.darkGrey,
    borderRadius: BorderRadius.circular(UILayout.radiusLG),
  );
  
  static EdgeInsets infoCardPadding = const EdgeInsets.all(UILayout.cardPadding);
  
  static const double infoCardIconSize = 24.0;
  
  // ============================================
  // ACTION CARDS
  // ============================================
  
  static BoxDecoration actionCardDecoration = BoxDecoration(
    color: UIPalette.darkGrey,
    borderRadius: BorderRadius.circular(UILayout.radiusLG),
  );
  
  static EdgeInsets actionCardPadding = const EdgeInsets.all(UILayout.cardPadding);
  
  static const double actionCardIconSize = 24.0;
  
  // Action Button (Text Button)
  static TextStyle actionButtonText = const TextStyle(
    fontSize: UITypography.fontSizeMD,
    fontWeight: UITypography.weightMedium,
    color: UIPalette.portalBlue,
  );
  
  // ============================================
  // COMPLETION/ACTIVITY ENTRIES
  // ============================================
  
  static BoxDecoration entryCardDecoration = BoxDecoration(
    color: UIPalette.darkGrey,
    borderRadius: BorderRadius.circular(UILayout.radiusLG),
  );
  
  static EdgeInsets entryCardPadding = const EdgeInsets.all(UILayout.cardPadding);
  
  static const double entryIconSize = 20.0;
  
  // ============================================
  // RIGHT SIDEBAR
  // ============================================
  
  static BoxDecoration rightSidebarDecoration = const BoxDecoration(
    color: UIPalette.deepBlack,
  );
  
  static EdgeInsets rightSidebarPadding = const EdgeInsets.all(UILayout.spacingXL);
  
  static TextStyle rightSidebarTitle = const TextStyle(
    fontSize: UITypography.fontSizeXL,
    fontWeight: UITypography.weightSemiBold,
    color: UIPalette.textWhite,
  );
  
  static const double rightSidebarIconSize = 24.0;
}

// ============================================
// SPACING SYSTEM
// ============================================

class UISpacing {
  // Vertical Spacing
  static const SizedBox v4 = SizedBox(height: 4);
  static const SizedBox v8 = SizedBox(height: 8);
  static const SizedBox v12 = SizedBox(height: 12);
  static const SizedBox v16 = SizedBox(height: 16);
  static const SizedBox v24 = SizedBox(height: 24);
  static const SizedBox v32 = SizedBox(height: 32);
  static const SizedBox v48 = SizedBox(height: 48);
  
  // Horizontal Spacing
  static const SizedBox h4 = SizedBox(width: 4);
  static const SizedBox h8 = SizedBox(width: 8);
  static const SizedBox h12 = SizedBox(width: 12);
  static const SizedBox h16 = SizedBox(width: 16);
  static const SizedBox h24 = SizedBox(width: 24);
  static const SizedBox h32 = SizedBox(width: 32);
}

// ============================================
// ICON SPECIFICATIONS
// ============================================

class UIIcons {
  // Icon Sizes
  static const double sizeXS = 16.0;
  static const double sizeSM = 20.0;
  static const double sizeMD = 24.0;
  static const double sizeLG = 32.0;
  static const double sizeXL = 48.0;
  
  // Icon Colors
  static const Color colorPrimary = UIPalette.portalBlue;
  static const Color colorSuccess = UIPalette.successGreen;
  static const Color colorWarning = UIPalette.warningAmber;
  static const Color colorError = UIPalette.alertRed;
  static const Color colorWhite = UIPalette.textWhite;
  static const Color colorGrey = UIPalette.textGrey;
  static const Color colorPurple = UIPalette.purpleAccent;
}

// ============================================
// GRID SYSTEM
// ============================================

class UIGrid {
  // Card Grid Spacing
  static const double cardSpacing = 16.0;
  static const int cardsPerRow = 3; // For summary cards
  
  // Responsive Breakpoints (if needed)
  static const double breakpointSM = 640.0;
  static const double breakpointMD = 768.0;
  static const double breakpointLG = 1024.0;
  static const double breakpointXL = 1280.0;
}

// ============================================
// ANIMATION SPECIFICATIONS
// ============================================

class UIAnimations {
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveBounce = Curves.easeOutBack;
}

// ============================================
// SHADOW SPECIFICATIONS
// ============================================

class UIShadows {
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: UIPalette.portalBlue.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> navItemShadow = [
    BoxShadow(
      color: UIPalette.portalBlue.withValues(alpha: 0.2),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
}

