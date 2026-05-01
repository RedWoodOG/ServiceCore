import 'package:flutter/material.dart';
import '../database/app_database.dart';

/// EVA State - Single source of truth for EVA panel state
/// This is global to the shell, not per view
class EvaState extends ChangeNotifier {
  bool _isExpanded = false;
  bool _isThinking = false;
  bool _hasUnread = false;
  AppDatabase? _database;
  String? _pendingQuery;

  bool get isExpanded => _isExpanded;
  bool get isThinking => _isThinking;
  bool get hasUnread => _hasUnread;
  String? get pendingQuery => _pendingQuery;

  void setDatabase(AppDatabase database) {
    _database = database;
  }

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void setExpanded(bool value) {
    if (_isExpanded != value) {
      _isExpanded = value;
      notifyListeners();
    }
  }

  void setIsThinking(bool value) {
    if (_isThinking != value) {
      _isThinking = value;
      notifyListeners();
    }
  }

  void setHasUnread(bool value) {
    if (_hasUnread != value) {
      _hasUnread = value;
      notifyListeners();
    }
  }

  void setPendingQuery(String? query) {
    _pendingQuery = query;
    notifyListeners();
  }

  String? consumePendingQuery() {
    final query = _pendingQuery;
    _pendingQuery = null;
    if (query != null) {
      notifyListeners();
    }
    return query;
  }

  // EVA can read local state (never mutates, never fetches)
  Future<Map<String, dynamic>> getDashboardContext() async {
    if (_database == null) return {};

    final weather = await _database!.getLatestWeather();
    final traffic = await _database!.getLatestTraffic();
    final openCalls = await _database!.getOpenCallsCount();
    final completedCalls = await _database!.getCompletedCallsCount();
    final weeklyCalls = await _database!.getWeeklyCallsCount();

    return {
      'weather': weather != null
          ? {
              'condition': weather.condition,
              'temperature': weather.temperature,
              'region': weather.region,
              'fetchedAt': weather.fetchedAt.toIso8601String(),
            }
          : null,
      'traffic': traffic != null
          ? {
              'routeLabel': traffic.routeLabel,
              'etaMinutes': traffic.etaMinutes,
              'condition': traffic.conditionLabel,
            }
          : null,
      'metrics': {
        'openCalls': openCalls,
        'completedToday': completedCalls,
        'thisWeek': weeklyCalls,
      },
    };
  }

  // EVA Operations read access - read-only queries over work history
  Future<Map<String, dynamic>> getWorkOrderContext(int workOrderId) async {
    if (_database == null) return {};

    final workOrder = await _database!.getWorkOrderById(workOrderId);
    if (workOrder == null) return {};

    // Get site - search all sites
    final allSites = await _database!.getAllSites();
    Site? site;
    try {
      site = allSites.firstWhere((s) => s.id == workOrder.siteId);
    } catch (e) {
      site = allSites.isNotEmpty ? allSites.first : null;
    }

    final equipment = await _database!.getEquipmentByWorkOrder(workOrderId);
    final workPerformed =
        await _database!.getWorkPerformedByWorkOrder(workOrderId);
    final notes = await _database!.getNotesByWorkOrder(workOrderId);

    return {
      'workOrder': {
        'id': workOrder.id,
        'status': workOrder.status,
        'priority': workOrder.priority,
        'description': workOrder.descriptionOfWork,
        'createdAt': workOrder.createdAt.toIso8601String(),
      },
      'site': site != null
          ? {
              'branchName': site.branchName,
              'address': site.address,
              'region': site.region,
            }
          : null,
      'equipment': equipment
          .map((eq) => {
                'type': eq.equipmentType,
                'manufacturer': eq.manufacturer,
                'model': eq.model,
                'serialNumber': eq.serialNumber,
              })
          .toList(),
      'workPerformed': workPerformed
          .map((wp) => {
                'technician': wp.technician,
                'startedAt': wp.startedAt.toIso8601String(),
                'description': wp.workDescription,
                'resolution': wp.resolution,
                'repeatIssue': wp.repeatIssue,
              })
          .toList(),
      'notes': notes
          .map((n) => {
                'type': n.noteType,
                'text': n.noteText,
                'createdAt': n.createdAt.toIso8601String(),
              })
          .toList(),
    };
  }

  Future<List<Map<String, dynamic>>> getSiteServiceHistory(int siteId) async {
    if (_database == null) return [];

    final workOrders = await _database!.getWorkOrdersBySite(siteId);
    final workPerformed = await _database!.getWorkPerformedBySite(siteId);

    final history = <Map<String, dynamic>>[];

    for (var wp in workPerformed) {
      final wo = workOrders.cast<WorkOrder?>().firstWhere(
            (w) => w!.id == wp.workOrderId,
            orElse: () => null,
          );
      if (wo == null) continue;
      final equipment = await _database!.getEquipmentById(wp.equipmentId ?? 0);

      history.add({
        'workOrderId': wo.id,
        'workPerformedId': wp.id,
        'technician': wp.technician,
        'startedAt': wp.startedAt.toIso8601String(),
        'description': wp.workDescription,
        'resolution': wp.resolution,
        'repeatIssue': wp.repeatIssue,
        'equipment': equipment != null
            ? {
                'type': equipment.equipmentType,
                'serialNumber': equipment.serialNumber,
              }
            : null,
      });
    }

    return history;
  }

  Future<Map<String, dynamic>?> getEquipmentBySerial(
      String serialNumber) async {
    if (_database == null) return null;

    final equipment = await _database!.getEquipmentBySerial(serialNumber);
    if (equipment == null) return null;

    final allSites = await _database!.getAllSites();
    Site? site;
    try {
      site = allSites.firstWhere((s) => s.id == equipment.siteId);
    } catch (e) {
      site = allSites.isNotEmpty ? allSites.first : null;
    }

    // Get work history for this equipment
    final allWorkOrders = await _database!.getAllWorkOrders();
    final equipmentWorkOrders = <WorkOrder>[];
    for (var wo in allWorkOrders) {
      final eq = await _database!.getEquipmentByWorkOrder(wo.id);
      if (eq.any((e) => e.id == equipment.id)) {
        equipmentWorkOrders.add(wo);
      }
    }

    return {
      'equipment': {
        'id': equipment.id,
        'type': equipment.equipmentType,
        'manufacturer': equipment.manufacturer,
        'model': equipment.model,
        'serialNumber': equipment.serialNumber,
        'underWarranty': equipment.underWarranty,
      },
      'site': site != null
          ? {
              'branchName': site.branchName,
              'address': site.address,
            }
          : null,
      'workOrderCount': equipmentWorkOrders.length,
    };
  }

  Future<String> describeDashboard() async {
    final context = await getDashboardContext();

    final buffer = StringBuffer();
    buffer.writeln("Current Dashboard State:");
    buffer.writeln("");

    if (context['weather'] != null) {
      final weather = context['weather'] as Map<String, dynamic>;
      buffer.writeln(
          "Weather: ${weather['condition']}, ${weather['temperature']}°F in ${weather['region']}");
    }

    if (context['traffic'] != null) {
      final traffic = context['traffic'] as Map<String, dynamic>;
      buffer.writeln(
          "Traffic: ${traffic['condition']} - ${traffic['etaMinutes']} minutes to ${traffic['routeLabel']}");
    }

    if (context['metrics'] != null) {
      final metrics = context['metrics'] as Map<String, dynamic>;
      buffer.writeln(
          "Work Orders: ${metrics['openCalls']} open, ${metrics['completedToday']} completed today, ${metrics['thisWeek']} this week");
    }

    return buffer.toString();
  }

  // ============================================
  // Knowledge Entries Read Access (EVA)
  // ============================================

  /// Search knowledge entries by keyword
  /// Returns list of entries with title, category, and excerpt
  Future<List<Map<String, dynamic>>> searchKnowledge(String keyword) async {
    if (_database == null) return [];

    final entries = await _database!.searchKnowledge(keyword);

    return entries.map((entry) {
      // Create short excerpt from content (first 150 chars)
      final excerpt = entry.content.length > 150
          ? '${entry.content.substring(0, 150)}...'
          : entry.content;

      return {
        'id': entry.id,
        'title': entry.title,
        'category': entry.category,
        'excerpt': excerpt,
        'route': 'knowledge/${entry.id}', // Internal route for navigation
      };
    }).toList();
  }

  /// Get knowledge entries by category
  /// Returns list of entries in the specified category
  Future<List<Map<String, dynamic>>> getKnowledgeByCategory(
      String category) async {
    if (_database == null) return [];

    final entries = await _database!.getKnowledgeEntriesByCategory(category);

    return entries.map((entry) {
      final excerpt = entry.content.length > 150
          ? '${entry.content.substring(0, 150)}...'
          : entry.content;

      return {
        'id': entry.id,
        'title': entry.title,
        'category': entry.category,
        'excerpt': excerpt,
        'route': 'knowledge/${entry.id}',
      };
    }).toList();
  }

  /// Get knowledge entry by title
  /// Returns single entry or null
  Future<Map<String, dynamic>?> getKnowledgeByTitle(String title) async {
    if (_database == null) return null;

    final entry = await _database!.getKnowledgeByTitle(title);
    if (entry == null) return null;

    final excerpt = entry.content.length > 150
        ? '${entry.content.substring(0, 150)}...'
        : entry.content;

    return {
      'id': entry.id,
      'title': entry.title,
      'category': entry.category,
      'excerpt': excerpt,
      'route': 'knowledge/${entry.id}',
    };
  }

  /// Get all available categories
  /// Returns list of category names
  Future<List<String>> getKnowledgeCategories() async {
    if (_database == null) return [];
    return await _database!.getDistinctCategories();
  }
}
