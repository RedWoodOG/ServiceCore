import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../database/app_database.dart';

class KnowledgeEntryView extends StatefulWidget {
  final String entryId;

  const KnowledgeEntryView({super.key, required this.entryId});

  @override
  State<KnowledgeEntryView> createState() => _KnowledgeEntryViewState();
}

class _KnowledgeEntryViewState extends State<KnowledgeEntryView> {
  KnowledgeEntry? _entry;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    final db = context.read<AppDatabase>();
    final entry = await db.getKnowledgeEntryById(widget.entryId);

    setState(() {
      _entry = entry;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_entry?.equipmentType ?? 'Knowledge Entry'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _entry == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error.withValues(alpha: 0.6)),
                      const SizedBox(height: 16),
                      Text(
                        'Entry not found',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        _entry!.title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Metadata badges row
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildBadge(
                            _getContentTypeLabel(_entry!.contentType),
                            _getContentTypeColor(_entry!.contentType, theme),
                            theme,
                          ),
                          _buildBadge(
                            _entry!.category,
                            theme.colorScheme.primary,
                            theme,
                          ),
                          if (_entry!.difficulty != null)
                            _buildBadge(
                              _entry!.difficulty!.toUpperCase(),
                              _getDifficultyColor(_entry!.difficulty!),
                              theme,
                            ),
                          if (_entry!.estimatedTime != null)
                            _buildBadge(
                              '~${_entry!.estimatedTime} min',
                              theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              theme,
                              icon: Icons.schedule,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Metadata card
                      _buildMetadataCard(theme),
                      const SizedBox(height: 16),

                      // Markdown content
                      MarkdownBody(
                        data: _entry!.content,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.8),
                              fontSize: 15,
                              height: 1.7),
                          h1: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          h2: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          h3: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          h4: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          code: TextStyle(
                            backgroundColor: theme.colorScheme.surface,
                            color: theme.colorScheme.primary,
                            fontFamily: 'monospace',
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          codeblockPadding: const EdgeInsets.all(12),
                          listBullet: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                          strong: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold),
                          em: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              fontStyle: FontStyle.italic),
                          blockquote: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Source info footer
                      _buildSourceFooter(theme),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }

  Widget _buildMetadataCard(ThemeData theme) {
    final entry = _entry!;
    final hasModel =
        entry.equipmentModel != null && entry.equipmentModel!.isNotEmpty;
    final hasSummary = entry.summary != null && entry.summary!.isNotEmpty;

    if (!hasModel && !hasSummary) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasModel) ...[
            Row(
              children: [
                Icon(Icons.precision_manufacturing,
                    size: 15,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text(
                  'Equipment: ${entry.equipmentModel}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (hasSummary) const SizedBox(height: 8),
          ],
          if (hasSummary)
            Text(
              entry.summary!,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSourceFooter(ThemeData theme) {
    final entry = _entry!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SOURCE INFORMATION',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          _buildSourceRow(
              Icons.description_outlined, 'Source', entry.sourceFile, theme),
          const SizedBox(height: 4),
          _buildSourceRow(Icons.tag, 'Version', entry.version, theme),
          const SizedBox(height: 4),
          _buildSourceRow(
              Icons.verified_outlined, 'Status', entry.status, theme),
        ],
      ),
    );
  }

  Widget _buildSourceRow(
      IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon,
            size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            fontSize: 12,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color, ThemeData theme,
      {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Color _getContentTypeColor(String contentType, ThemeData theme) {
    switch (contentType) {
      case 'procedure':
        return theme.colorScheme.primary;
      case 'troubleshooting':
        return Colors.orange;
      case 'safety':
        return theme.colorScheme.error;
      case 'specification':
        return Colors.teal;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  String _getContentTypeLabel(String contentType) {
    switch (contentType) {
      case 'procedure':
        return 'PROCEDURE';
      case 'troubleshooting':
        return 'TROUBLESHOOT';
      case 'safety':
        return 'SAFETY';
      case 'specification':
        return 'SPEC';
      default:
        return 'REFERENCE';
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
