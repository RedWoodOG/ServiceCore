import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../providers/theme_provider.dart';
import '../feedback/feedback_annotation_page.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _selectedCategory = 'general';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.2),
        border: Border(
          bottom:
              BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'settings_icon',
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SYSTEM CONFIGURATION",
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                "TERMINAL v2.0.26 // OFFLINE PRIORITY",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildCategorySelector(),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return GlassCard(
      padding: const EdgeInsets.all(4),
      borderRadius: 12,
      child: Row(
        children: [
          _buildCategoryItem("GENERAL", Icons.tune, 'general'),
          _buildCategoryItem("KNOWLEDGE", Icons.menu_book, 'knowledge'),
          _buildCategoryItem("SECURITY", Icons.security, 'security'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, String category) {
    final theme = Theme.of(context);
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedCategory) {
      case 'knowledge':
        return _buildKnowledgeTab();
      case 'security':
        return _buildSecurityTab();
      default:
        return _buildGeneralTab();
    }
  }

  Widget _buildGeneralTab() {
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("INTERFACE PREFERENCES"),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 2.5,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildToggleCard(
              "LIGHT THEME",
              "Use FSC brand colors with white background (professional).",
              themeProvider.isLightMode,
              (v) {
                if (v) {
                  themeProvider.setLightTheme();
                } else {
                  themeProvider.setDarkTheme();
                }
              },
            ),
            _buildToggleCard(
              "OFFLINE-FIRST MODE",
              "Prioritize local storage and sync in background.",
              true,
              (v) {},
            ),
            _buildToggleCard(
              "BIOMETRIC ACCESS",
              "Require Windows Hello for secure stop entry.",
              false,
              (v) {},
            ),
            _buildToggleCard(
              "HIGH DENSITY UI",
              "Maximize information display for wide screens.",
              true,
              (v) {},
            ),
          ],
        ),
        const SizedBox(height: 48),
        _buildSectionHeader("AI ASSISTANT BRIDGE"),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Screen capture + structured notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Capture the current portal view, draw boxes on what should change, '
                'and export a PNG plus JSON. Attach both when you share a screenshot with '
                'Cursor or another assistant so it can read your exact targets.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.72),
                    ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => openAiFeedbackAnnotationFlow(context),
                icon: const Icon(Icons.smart_toy_outlined),
                label: const Text('Capture & annotate for AI'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        _buildSectionHeader("SYSTEM HEALTH"),
        const SizedBox(height: 24),
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              _buildHealthMetric("CPU", "12%",
                  Theme.of(context).extension<StatusColors>()!.success),
              _buildSeparator(),
              _buildHealthMetric(
                  "STORAGE", "1.2 GB", Theme.of(context).colorScheme.primary),
              _buildSeparator(),
              _buildHealthMetric("DATABASE", "HEALTHY",
                  Theme.of(context).extension<StatusColors>()!.success),
              _buildSeparator(),
              _buildHealthMetric("LATENCY", "42ms",
                  Theme.of(context).extension<StatusColors>()!.success),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKnowledgeTab() {
    final theme = Theme.of(context);
    final db = context.watch<AppDatabase>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("DATA INGESTION ENGINE"),
        const SizedBox(height: 24),
        StreamBuilder<List<KnowledgeEntry>>(
          stream: db.watchAllKnowledgeEntries(),
          builder: (context, snapshot) {
            final count = snapshot.data?.length ?? 0;
            return GlassCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildMetricBox(
                        "INDEXED ENTRIES",
                        count.toString(),
                        Colors.tealAccent,
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "LOCAL KNOWLEDGE REPOSITORY",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Files stored at C:\\Portal_Knowledge_Staging\\knowledge_entries",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          "REBUILD INDEX",
                          Icons.refresh,
                          () => _ingestKnowledgeEntries(db),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          "EXPORT DATA",
                          Icons.ios_share,
                          () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSecurityTab() {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 100),
        Icon(
          Icons.lock_clock_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          size: 120,
        ),
        const SizedBox(height: 24),
        Text(
          "SECURITY PROTOCOLS ENFORCED",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildToggleCard(
    String title,
    String desc,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Theme.of(context).colorScheme.primary,
            activeTrackColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.5),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    final theme = Theme.of(context);
    return Container(
        height: 32,
        width: 1,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05));
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        foregroundColor: theme.colorScheme.onSurface,
        side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
      ),
    );
  }

  Future<void> _ingestKnowledgeEntries(AppDatabase db) async {
    final knowledgeDir = r'C:\Portal_Knowledge_Staging\knowledge_entries';
    if (!Directory(knowledgeDir).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Source directory missing: $knowledgeDir'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await db.clearAllKnowledgeEntries();
      final dir = Directory(knowledgeDir);
      final mdFiles = dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.md'))
          .toList();

      int success = 0;
      for (final file in mdFiles) {
        final content = await file.readAsString();
        String title = path.basenameWithoutExtension(file.path);
        String? category;

        if (content.startsWith('---')) {
          final yamlMatch = RegExp(
            r'---\s*\n(.*?)\n---',
            dotAll: true,
          ).firstMatch(content);
          if (yamlMatch != null) {
            final doc = loadYaml(yamlMatch.group(1)!);
            if (doc is Map) {
              title = doc['title']?.toString() ?? title;
              category = doc['category']?.toString();
            }
          }
        }

        await db.insertOrReplaceKnowledge(
          KnowledgeEntriesCompanion.insert(
            id: title.toLowerCase().replaceAll(' ', '-'),
            title: title,
            category: category ?? 'General',
            content: content,
            equipmentType: 'general',
            sourceType: 'settings_import',
            sourceFile: path.basename(file.path),
            version: '1.0.0',
            status: 'active',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        success++;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('INDEX REBUILT: $success ENTRIES PROCESSED'),
            backgroundColor:
                Theme.of(context).extension<StatusColors>()!.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('FAILURE: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
