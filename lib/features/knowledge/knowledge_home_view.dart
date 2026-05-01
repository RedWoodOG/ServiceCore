import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../util/log.dart';
import '../../database/app_database.dart';
import 'knowledge_category_view.dart';
import 'knowledge_equipment_view.dart';
import 'knowledge_entry_view.dart';

class KnowledgeHomeView extends StatefulWidget {
  const KnowledgeHomeView({super.key});

  @override
  State<KnowledgeHomeView> createState() => _KnowledgeHomeViewState();
}

class _KnowledgeHomeViewState extends State<KnowledgeHomeView> {
  String _searchQuery = '';
  List<KnowledgeEntry> _searchResults = [];
  bool _isSearching = false;
  bool _groupByEquipment = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
        _searchQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query;
    });

    try {
      final db = context.read<AppDatabase>();
      final results = await db.searchKnowledge(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      Log.error('KnowledgeHomeView: Search error: $e');
      Log.error('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: StreamBuilder<List<KnowledgeEntry>>(
          stream: context.read<AppDatabase>().watchAllKnowledgeEntries(),
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.length : 0;
            return Text('Knowledge Base${count > 0 ? ' ($count)' : ''}');
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.05))),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            // Search box
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search procedures, equipment, troubleshooting...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: _performSearch,
              ),
            ),

            // View Toggle
            if (_searchQuery.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    _buildToggleChip(
                        'By Equipment', Icons.build_outlined, _groupByEquipment,
                        () {
                      setState(() => _groupByEquipment = true);
                    }),
                    const SizedBox(width: 8),
                    _buildToggleChip('By Category', Icons.category_outlined,
                        !_groupByEquipment, () {
                      setState(() => _groupByEquipment = false);
                    }),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: _searchQuery.isNotEmpty
                  ? _buildSearchResults()
                  : _buildGroupedList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleChip(
      String label, IconData icon, bool selected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedList() {
    final theme = Theme.of(context);
    final db = context.read<AppDatabase>();

    return StreamBuilder<Map<String, int>>(
      stream: db.watchKnowledgeGroupCounts(byEquipment: _groupByEquipment),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final groups = snapshot.data ?? {};

        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.library_books_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                const SizedBox(height: 16),
                Text(
                  'No entries found',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Import knowledge from Settings → Knowledge tab',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final name = groups.keys.elementAt(index);
            final count = groups.values.elementAt(index);
            final icon = _groupByEquipment
                ? _getEquipmentIcon(name)
                : _getCategoryIcon(name);

            return Card(
              color: theme.colorScheme.surface,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 22),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  '$count ${count == 1 ? 'article' : 'articles'}',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 12),
                ),
                trailing: Icon(Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _groupByEquipment
                          ? KnowledgeEquipmentView(equipmentType: name)
                          : KnowledgeCategoryView(category: name),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  IconData _getEquipmentIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('atm')) return Icons.atm;
    if (t.contains('lock')) return Icons.enhanced_encryption;
    if (t.contains('coin')) return Icons.toll;
    if (t.contains('currency') || t.contains('counter')) return Icons.payments;
    if (t.contains('surveillance') || t.contains('dvr')) return Icons.videocam;
    if (t.contains('printer')) return Icons.print;
    if (t.contains('scanner')) return Icons.scanner;
    if (t.contains('validator') || t.contains('bill')) {
      return Icons.receipt_long;
    }
    return Icons.settings_input_component;
  }

  IconData _getCategoryIcon(String category) {
    final c = category.toLowerCase();
    if (c.contains('trouble')) return Icons.build;
    if (c.contains('procedure')) return Icons.assignment;
    if (c.contains('safety')) return Icons.warning_amber;
    if (c.contains('part')) return Icons.extension;
    if (c.contains('manual')) return Icons.menu_book;
    if (c.contains('install') || c.contains('setup')) {
      return Icons.install_desktop;
    }
    if (c.contains('mainten')) return Icons.handyman;
    if (c.contains('spec')) return Icons.description;
    return Icons.folder_outlined;
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
      case 'howto':
        return 'HOW-TO';
      default:
        return 'REFERENCE';
    }
  }

  Widget _buildSearchResults() {
    final theme = Theme.of(context);
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              'No results for "$_searchQuery"',
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final entry = _searchResults[index];
        final typeColor = _getContentTypeColor(entry.contentType, theme);

        return Card(
          color: theme.colorScheme.surface,
          margin: const EdgeInsets.only(bottom: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
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
                  // Content type badge + equipment type
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
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
                      if (entry.difficulty != null)
                        _buildDifficultyDot(entry.difficulty!, theme),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    entry.title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  // Summary or equipment model
                  if (entry.summary != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.summary!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ] else if (entry.equipmentModel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.equipmentModel!,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                  // Bottom row: estimated time + category
                  if (entry.estimatedTime != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 13,
                            color:
                                theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                        const SizedBox(width: 4),
                        Text(
                          '~${entry.estimatedTime} min',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.folder_outlined,
                            size: 13,
                            color:
                                theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                        const SizedBox(width: 4),
                        Text(
                          entry.category,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDifficultyDot(String difficulty, ThemeData theme) {
    Color color;
    switch (difficulty) {
      case 'beginner':
        color = Colors.green;
        break;
      case 'intermediate':
        color = Colors.orange;
        break;
      case 'advanced':
        color = Colors.red;
        break;
      default:
        color = theme.colorScheme.onSurface.withValues(alpha: 0.3);
    }
    return Tooltip(
      message: '${difficulty[0].toUpperCase()}${difficulty.substring(1)}',
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
