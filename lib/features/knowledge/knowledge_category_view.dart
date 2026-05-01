import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import 'knowledge_entry_view.dart';

class KnowledgeCategoryView extends StatefulWidget {
  final String category;

  const KnowledgeCategoryView({super.key, required this.category});

  @override
  State<KnowledgeCategoryView> createState() => _KnowledgeCategoryViewState();
}

class _KnowledgeCategoryViewState extends State<KnowledgeCategoryView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: StreamBuilder<List<KnowledgeEntry>>(
          stream: context
              .read<AppDatabase>()
              .watchKnowledgeEntriesByCategory(widget.category),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final entries = snapshot.data!;

            if (entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text(
                      'No entries in ${widget.category}',
                      style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _buildEntryCard(entry, theme);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEntryCard(KnowledgeEntry entry, ThemeData theme) {
    final typeColor = _getContentTypeColor(entry.contentType, theme);

    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeEntryView(entryId: entry.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getContentTypeLabel(entry.contentType),
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.equipmentType,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (entry.estimatedTime != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule,
                            size: 12,
                            color:
                                theme.colorScheme.onSurface.withValues(alpha: 0.35)),
                        const SizedBox(width: 3),
                        Text(
                          '${entry.estimatedTime}m',
                          style: TextStyle(
                            color:
                                theme.colorScheme.onSurface.withValues(alpha: 0.35),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  Icon(Icons.chevron_right,
                      size: 18,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.25)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                entry.title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (entry.equipmentModel != null) ...[
                const SizedBox(height: 4),
                Text(
                  entry.equipmentModel!,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
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
}
