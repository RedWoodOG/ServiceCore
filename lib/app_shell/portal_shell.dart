import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'eva_state.dart';
import 'eva_panel.dart';
import 'eva_collapse_rail.dart';

/// Portal Shell - Core layout that owns EVA and main content
/// Layout Rule: Horizontal Row
/// - Left child: Main content (Expanded)
/// - Right child: EVA Panel (fixed width or collapsed)
/// No overlays, no Stack hacks, no drawers
class PortalShell extends StatelessWidget {
  final Widget child;

  const PortalShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final evaState = context.watch<EvaState>();

    return Row(
      children: [
        // Main Content Area (LEFT)
        Expanded(
          child: child,
        ),
        // EVA Panel (RIGHT) - Always present, either expanded or collapsed
        evaState.isExpanded
            ? const EvaPanel()
            : const EvaCollapseRail(),
      ],
    );
  }
}

