// Modern UI Components following Material 3 guidelines
// lib/widgets/modern_components.dart

import 'package:flutter/material.dart';

// Updated theme following Material 3 specifications
class ModernAppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      cardTheme: _cardTheme,
      filledButtonTheme: _filledButtonTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      navigationBarTheme: _navigationBarTheme,
    );
  }

  static ColorScheme get _colorScheme {
    return const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xFF4A9EFF),
      onPrimary: Color(0xFF002E69),
      primaryContainer: Color(0xFF00458A),
      onPrimaryContainer: Color(0xFFD4E3FF),
      
      secondary: Color(0xFFBBC7DB),
      onSecondary: Color(0xFF253140),
      secondaryContainer: Color(0xFF3B4858),
      onSecondaryContainer: Color(0xFFD7E3F7),
      
      tertiary: Color(0xFFD0BDE1),
      onTertiary: Color(0xFF362B3F),
      tertiaryContainer: Color(0xFF4D4156),
      onTertiaryContainer: Color(0xFFEDD9FD),
      
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      
      surface: Color(0xFF0F1419),
      onSurface: Color(0xFFE1E2E8),
      surfaceContainerHighest: Color(0xFF42474E),
      onSurfaceVariant: Color(0xFFC2C7CF),
      
      outline: Color(0xFF8C9199),
      outlineVariant: Color(0xFF42474E),
      
      inverseSurface: Color(0xFFE1E2E8),
      onInverseSurface: Color(0xFF2E3036),
      inversePrimary: Color(0xFF005CB8),
    );
  }

  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        height: 1.12,
        letterSpacing: -0.25,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        height: 1.16,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        height: 1.22,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.25,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.29,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.33,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.27,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.50,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        height: 1.45,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.50,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.25,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static CardTheme get _cardTheme {
    return CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
    );
  }

  static FilledButtonThemeData get _filledButtonTheme {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 40),
        maximumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: const Size(64, 40),
        maximumSize: const Size(double.infinity, 40),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static NavigationBarThemeData get _navigationBarTheme {
    return NavigationBarThemeData(
      height: 80,
      elevation: 3,
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

// Modern Work Order Card with Material 3 design
class ModernWorkOrderCard extends StatelessWidget {
  final WorkOrderWithDetails workOrder;
  final VoidCallback? onTap;

  const ModernWorkOrderCard({
    super.key,
    required this.workOrder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'WO-${workOrder.workOrder.id}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusBadge(status: workOrder.workOrder.status),
                ],
              ),
              const SizedBox(height: 8),
              
              // Client and site information
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${workOrder.client.name} • ${workOrder.site.name}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${workOrder.site.address}, ${workOrder.site.city}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              
              if (workOrder.workOrder.description?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text(
                  workOrder.workOrder.description!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Footer with priority and date
              Row(
                children: [
                  _PriorityIndicator(priority: workOrder.workOrder.priority),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(workOrder.workOrder.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    Color foregroundColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'open':
        backgroundColor = theme.colorScheme.errorContainer;
        foregroundColor = theme.colorScheme.onErrorContainer;
        icon = Icons.schedule_outlined;
        break;
      case 'in_progress':
        backgroundColor = theme.colorScheme.tertiaryContainer;
        foregroundColor = theme.colorScheme.onTertiaryContainer;
        icon = Icons.work_outline;
        break;
      case 'completed':
        backgroundColor = theme.colorScheme.primaryContainer;
        foregroundColor = theme.colorScheme.onPrimaryContainer;
        icon = Icons.check_circle_outline;
        break;
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        foregroundColor = theme.colorScheme.onSurfaceVariant;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 4),
          Text(
            status.replaceAll('_', ' ').toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityIndicator extends StatelessWidget {
  final String priority;

  const _PriorityIndicator({required this.priority});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = theme.colorScheme.error;
        break;
      case 'medium':
        color = theme.colorScheme.tertiary;
        break;
      case 'low':
        color = theme.colorScheme.outline;
        break;
      default:
        color = theme.colorScheme.outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          priority.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// Responsive layout helper
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 800) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

// Modern search bar with autocomplete
class ModernSearchBar extends StatefulWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<String> suggestions;

  const ModernSearchBar({
    super.key,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.suggestions = const [],
  });

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        SearchBar(
          controller: _controller,
          focusNode: _focusNode,
          hintText: widget.hint ?? 'Search...',
          leading: const Icon(Icons.search),
          trailing: [
            if (_controller.text.isNotEmpty)
              IconButton(
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                },
                icon: const Icon(Icons.clear),
              ),
          ],
          onChanged: (value) {
            setState(() {
              _showSuggestions = value.isNotEmpty && widget.suggestions.isNotEmpty;
            });
            widget.onChanged?.call(value);
          },
          onSubmitted: widget.onSubmitted,
          elevation: WidgetStateProperty.all(1),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
        ),
        
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: widget.suggestions
                  .where((s) => s.toLowerCase().contains(_controller.text.toLowerCase()))
                  .take(5)
                  .map((suggestion) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.history),
                        title: Text(suggestion),
                        onTap: () {
                          _controller.text = suggestion;
                          setState(() => _showSuggestions = false);
                          widget.onSubmitted?.call(suggestion);
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}
