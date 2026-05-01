import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'eva_state.dart';

/// EVA Collapsed Rail - Slim vertical rail when EVA is collapsed
/// Still visible, still clickable, preserves spatial memory
class EvaCollapseRail extends StatelessWidget {
  const EvaCollapseRail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final evaState = context.watch<EvaState>();

    return Container(
      width: 56, // Collapsed width
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Top spacer
          const SizedBox(height: 24),
          // EVA indicator/button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                evaState.setExpanded(true);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: evaState.hasUnread 
                        ? theme.colorScheme.primary 
                        : theme.dividerColor,
                    width: evaState.hasUnread ? 2 : 1,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Unread indicator if present
          if (evaState.hasUnread)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          const Spacer(),
          // Expand hint
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: RotatedBox(
              quarterTurns: 1,
              child: Text(
                'EVA',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

