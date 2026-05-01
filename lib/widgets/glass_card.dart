import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A premium card component that adapts to light and dark themes.
///
/// Features:
/// - Dark mode: Glass effect with gradient and blur
/// - Light mode: Solid card color from theme
/// - Theme-aware borders and shadows
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool hasShine;
  final Color? activeBorderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = AppLayout.radiusLG,
    this.hasShine = true,
    this.activeBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? null : theme.cardColor,
            gradient: isDark ? AppGradients.glassSurface : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: activeBorderColor ??
                  (isDark
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.15)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: isDark ? 20 : 8,
                spreadRadius: isDark ? -5 : 0,
                offset: Offset(0, isDark ? 8 : 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              child: Padding(
                padding: padding ?? AppLayout.cardPaddingAll,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
