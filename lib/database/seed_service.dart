import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import '../util/log.dart';
import '../util/knowledge_categorizer.dart';
import 'package:drift/drift.dart';
import 'package:fsc_portal/database/app_database.dart';

Future<void> seedDatabase(AppDatabase db) async {
  // Check if already seeded
  final existingClients = await db.getAllClients();
  final existingUsers = await db.getAllUsers();
  final existingWeather = await db.getLatestWeather();
  final existingWorkCalls = await db.getOpenCallsCount();

  // [SCRAPER SIMULATION]
  // Only seed briefings if table is empty (deterministic - same data every launch)
  final existingBriefings = await db.getLatestIndustryBriefing(limit: 1);
  if (existingBriefings.isEmpty) {
    await db.insertIndustryBriefing(
      IndustryBriefingCompanion.insert(
        title: 'Bavis Fabacraft: New Solar-Powered Drive-Thru Audio',
        source: 'Bavis Fabacraft',
        previewImage: const Value('assets/images/news_AV.png'), // Proxy image
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        fetchedAt: DateTime.now(),
      ),
    );

    await db.insertIndustryBriefing(
      IndustryBriefingCompanion.insert(
        title: 'Cassida Pro Series: Mixed Valuation Update released',
        source: 'Cassida USA',
        previewImage: const Value(
          'assets/images/news_kisan.jpg',
        ), // Proxy: Currency counter
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        fetchedAt: DateTime.now(),
      ),
    );

    await db.insertIndustryBriefing(
      IndustryBriefingCompanion.insert(
        title: 'Fenco Solutions: 2026 Modular Vault Systems',
        source: 'Fenco',
        previewImage: const Value(
          'assets/images/news_AV_2.webp',
        ), // Proxy: Vault
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        fetchedAt: DateTime.now(),
      ),
    );

    await db.insertIndustryBriefing(
      IndustryBriefingCompanion.insert(
        title: 'Medeco: XT Intelligent Key System Refresh',
        source: 'Medeco Security',
        previewImage: const Value('assets/images/news_hyosung.png'),
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        fetchedAt: DateTime.now(),
      ),
    );

    await db.insertIndustryBriefing(
      IndustryBriefingCompanion.insert(
        title: 'American Vault: Class 2/3 Vault Door Specs',
        source: 'American Vault',
        previewImage: const Value('assets/images/news_hyosung_2.png'),
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        fetchedAt: DateTime.now(),
      ),
    );
    Log.info('- Industry briefing seeded (5 fresh items from Web Scraper)');
  }

  // Check if rest of DB is already seeded
  if (existingClients.isNotEmpty &&
      existingUsers.isNotEmpty &&
      existingWeather != null &&
      existingWorkCalls > 0) {
    Log.info('Rest of database already seeded. Skipping core seed...');
    // But we still check for GulfCoast enrichment, team updates, and knowledge
    await _seedGulfCoastLocations(db);
    await _seedTeamMembers(db);
    await _ingestKnowledgeEntries(db);
    return;
  }

  Log.info('Seeding database with demo data...');

  // Insert Default User if not exists
  if (existingUsers.isEmpty) {
    await db.into(db.users).insert(
          UsersCompanion.insert(
            username: 'jwhite',
            fullName: 'Demo Technician',
            email: '[redacted-email]',
            role: 'Senior Systems Engineer',
            password: const Value('password123'),
            location: const Value('San Antonio, TX'),
            bio: const Value('Senior Systems Engineer'),
            phoneNumber: const Value('(210) 937-2876'),
            dateOfBirth: Value(DateTime(1985, 5, 15)),
          ),
        );
    Log.info('- Default User (Demo Technician) created');
  } else {
    // Update existing user to ensure correct information
    try {
      // Find user by username or by name
      User? userToUpdate;
      try {
        userToUpdate = existingUsers.firstWhere(
          (u) => u.username == 'jwhite' || u.username == 'admin',
        );
      } catch (e) {
        // If no jwhite or admin, use first user
        if (existingUsers.isNotEmpty) {
          userToUpdate = existingUsers.first;
        }
      }

      if (userToUpdate != null) {
        await db.updateUser(
          UsersCompanion(
            id: Value(userToUpdate.id),
            username: const Value('jwhite'),
            fullName: const Value('Demo Technician'),
            email: const Value('[redacted-email]'),
            role: const Value('Senior Systems Engineer'),
            bio: const Value('Senior Systems Engineer'),
            phoneNumber: const Value('(210) 937-2876'),
          ),
        );
        Log.info(
          '- Updated user to Demo Technician with correct contact information',
        );
      }
    } catch (e) {
      // User update failed - that's fine, continue
      Log.info('- User update skipped: $e');
    }
  }

  // Clear and recreate team members to ensure they're correct
  await _seedTeamMembers(db);

  if (existingClients.isNotEmpty) {
    Log.info('- Clients already exist, skipping core client seed.');
  } else {
    // Insert Clients
    final NorthwindId = await db
        .into(db.clients)
        .insert(ClientsCompanion.insert(name: 'Northwind', themeColor: 'blue'));

    final LoneStarId = await db.into(db.clients).insert(
          ClientsCompanion.insert(name: 'Lone Star Bank', themeColor: 'yellow'),
        );

    final GulfCoastId = await db.into(db.clients).insert(
          ClientsCompanion.insert(name: 'Gulf Coast Bank', themeColor: 'red'),
        );

    // Insert Starting Points
    await db.into(db.startingPoints).insert(
          StartingPointsCompanion.insert(
            name: "Home Base",
            latitude: 29.4241, // [redacted-address]
            longitude: -98.4936,
          ),
        );

    await db.into(db.startingPoints).insert(
          StartingPointsCompanion.insert(
            name:
                'Office', // Shop: [redacted-address]
            latitude: 29.5150,
            longitude: -98.4600,
          ),
        );

    await db.into(db.startingPoints).insert(
          StartingPointsCompanion.insert(
            name: "Home Base 2",
            latitude: 29.703,
            longitude: -98.124,
          ),
        );

    // Insert Sites - Northwind
    await db.into(db.sites).insert(
          SitesCompanion.insert(
            clientId: NorthwindId,
            branchName: 'Bulverde Crossing',
            address: 'Bulverde Crossing, TX',
            latitude: 29.682,
            longitude: -98.432,
            region: 'North',
          ),
        );

    await db.into(db.sites).insert(
          SitesCompanion.insert(
            clientId: NorthwindId,
            branchName: 'Stone Oak',
            address: 'Stone Oak, TX',
            latitude: 29.645,
            longitude: -98.460,
            region: 'North',
          ),
        );

    // Insert Sites - Lone Star Bank
    await db.into(db.sites).insert(
          SitesCompanion.insert(
            clientId: LoneStarId,
            branchName: 'Alamo Heights',
            address: 'Alamo Heights, TX',
            latitude: 29.480,
            longitude: -98.465,
            region: 'Central',
          ),
        );

    await db.into(db.sites).insert(
          SitesCompanion.insert(
            clientId: LoneStarId,
            branchName: 'Downtown',
            address: 'Downtown, TX',
            latitude: 29.424,
            longitude: -98.493,
            region: 'Central',
          ),
        );

    // Insert Sites - Gulf Coast Bank
    await db.into(db.sites).insert(
          SitesCompanion.insert(
            clientId: GulfCoastId,
            branchName: 'New Braunfels',
            address: 'New Braunfels, TX',
            latitude: 29.700,
            longitude: -98.120,
            region: 'East',
          ),
        );

    await db.into(db.sites).insert(
          SitesCompanion.insert(
            clientId: GulfCoastId,
            branchName: 'Seguin',
            address: 'Seguin, TX',
            latitude: 29.560,
            longitude: -97.960,
            region: 'East',
          ),
        );
  } // End of else block for client seeding

  // Seed offline-first tables for home dashboard
  final weatherCheck = await db.getLatestWeather();
  if (weatherCheck == null) {
    await db.insertWeather(
      WeatherSnapshotCompanion.insert(
        region: 'North Region',
        temperature: 72,
        condition: 'Clear',
        fetchedAt: DateTime.now(),
        source: 'fallback',
      ),
    );
    Log.info('- Weather snapshot seeded');
  }

  final existingTraffic = await db.getLatestTraffic();
  if (existingTraffic == null) {
    await db.insertTraffic(
      TrafficSnapshotCompanion.insert(
        routeLabel: 'Northwind - Bulverde',
        etaMinutes: 22,
        conditionLabel: 'Light',
        fetchedAt: DateTime.now(),
        source: 'fallback',
      ),
    );
    Log.info('- Traffic snapshot seeded');
  }

  final workCallsCount = await db.getOpenCallsCount();
  if (workCallsCount == 0) {
    // Seed work calls for KPI cards
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    // 6 Open calls
    for (int i = 0; i < 6; i++) {
      await db.insertWorkCall(
        WorkCallsCompanion.insert(
          status: 'open',
          scheduledAt: Value(now.add(Duration(hours: i + 1))),
          workOrderNumber: Value('WO-${1000 + i}'),
        ),
      );
    }

    // 2 Completed today
    for (int i = 0; i < 2; i++) {
      await db.insertWorkCall(
        WorkCallsCompanion.insert(
          status: 'completed',
          completedAt: Value(now.subtract(Duration(hours: i + 1))),
          scheduledAt: Value(now.subtract(Duration(hours: i + 2))),
          workOrderNumber: Value('WO-${900 + i}'),
        ),
      );
    }

    // 10 More completed this week (for "This Week" = 12 total)
    for (int i = 0; i < 10; i++) {
      final dayOffset = (i % 7);
      await db.insertWorkCall(
        WorkCallsCompanion.insert(
          status: 'completed',
          completedAt: Value(
            weekStart.add(Duration(days: dayOffset, hours: 10 + i)),
          ),
          scheduledAt: Value(weekStart.add(Duration(days: dayOffset))),
          workOrderNumber: Value('WO-${800 + i}'),
        ),
      );
    }
    Log.info('- Work calls seeded (6 open, 12 completed this week)');
  }

  final existingAnnouncements = await db.getActiveCompanyAnnouncements();
  if (existingAnnouncements.isEmpty) {
    await db.into(db.companyAnnouncements).insert(
          CompanyAnnouncementsCompanion.insert(
            category: 'hr',
            title: 'HR: Open Enrollment',
            body: 'Ends Dec 15. Selections do not carry over.',
            actionLabel: const Value('SELECT BENEFITS'),
            active: const Value(true),
            publishedAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
        );

    await db.into(db.companyAnnouncements).insert(
          CompanyAnnouncementsCompanion.insert(
            category: 'safety',
            title: 'Safety: Black Ice',
            body: 'Winter advisory. Check tires and fluid.',
            actionLabel: const Value('ACKNOWLEDGE'),
            active: const Value(true),
            publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
        );

    await db.into(db.companyAnnouncements).insert(
          CompanyAnnouncementsCompanion.insert(
            category: 'fleet',
            title: 'Fleet: Repair Policy',
            body: 'Quotes > \$500 need approval.',
            actionLabel: const Value('VIEW POLICY'),
            active: const Value(true),
            publishedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        );
    Log.info('- Company announcements seeded (3 items)');
  }

  // Seed Operations domain model data
  final existingWorkOrders = await db.getAllWorkOrders();
  if (existingWorkOrders.isEmpty) {
    // Get first site for seeding
    final sites = await db.getAllSites();
    if (sites.isNotEmpty) {
      final firstSite = sites.first;
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final lastWeek = now.subtract(const Duration(days: 7));

      // Insert sample equipment
      final equipmentId = await db.into(db.equipment).insert(
            EquipmentCompanion.insert(
              siteId: firstSite.id,
              equipmentType: 'counter',
              manufacturer: const Value('Magner'),
              model: const Value('305 CDS'),
              serialNumber: const Value('MAG-305-12345'),
              underWarranty: const Value(true),
              active: const Value(true),
            ),
          );
      Log.info('- Equipment seeded (1 item)');

      // Insert sample work order
      final workOrderId = await db.into(db.workOrders).insert(
            WorkOrdersCompanion.insert(
              siteId: firstSite.id,
              status: 'open',
              priority: const Value('high'),
              descriptionOfWork: const Value(
                'Coin sorter not dispensing properly',
              ),
              internalNotes: const Value('Customer reported issue yesterday'),
              createdAt: yesterday,
              createdBy: const Value('system'),
              assignedTechnician: const Value('Tech 1'),
            ),
          );
      Log.info('- Work order seeded (1 item)');

      // Link equipment to work order
      await db.linkEquipmentToWorkOrder(workOrderId, equipmentId);

      // Insert appointment
      await db.into(db.appointments).insert(
            AppointmentsCompanion.insert(
              workOrderId: workOrderId,
              scheduledStart: now.add(const Duration(hours: 2)),
              expectedDurationMinutes: const Value(60),
              technician: const Value('Tech 1'),
            ),
          );
      Log.info('- Appointment seeded (1 item)');

      // Insert completed work order with work performed
      final completedWorkOrderId = await db.into(db.workOrders).insert(
            WorkOrdersCompanion.insert(
              siteId: firstSite.id,
              status: 'completed',
              priority: const Value('medium'),
              descriptionOfWork: const Value(
                'Routine maintenance and calibration',
              ),
              createdAt: lastWeek,
              closedAt: Value(lastWeek.add(const Duration(hours: 2))),
              createdBy: const Value('system'),
              assignedTechnician: const Value('Tech 1'),
            ),
          );

      // Link equipment to completed work order
      await db.linkEquipmentToWorkOrder(completedWorkOrderId, equipmentId);

      // Insert work performed
      final workPerformedId = await db.into(db.workPerformed).insert(
            WorkPerformedCompanion.insert(
              workOrderId: completedWorkOrderId,
              equipmentId: Value(equipmentId),
              technician: 'Tech 1',
              startedAt: lastWeek.add(const Duration(hours: 1)),
              durationMinutes: const Value(90),
              workDescription: const Value(
                'Calibrated coin sensors, cleaned sorting mechanism',
              ),
              resolution: const Value(
                'Equipment operating normally after calibration',
              ),
              repeatIssue: const Value(false),
            ),
          );
      Log.info('- Work performed seeded (1 item)');

      // Insert parts used
      await db.into(db.partsUsed).insert(
            PartsUsedCompanion.insert(
              workPerformedId: workPerformedId,
              partNumber: const Value('MAG-305-SENSOR-01'),
              description: const Value('Replacement sensor'),
              quantity: const Value(1),
            ),
          );
      Log.info('- Parts used seeded (1 item)');

      // Insert note
      await db.into(db.notes).insert(
            NotesCompanion.insert(
              siteId: firstSite.id,
              workOrderId: Value(completedWorkOrderId),
              noteType: 'poi',
              noteText: 'Equipment performs better after morning hours',
              createdAt: lastWeek,
              createdBy: const Value('Tech 1'),
            ),
          );
      Log.info('- Note seeded (1 item)');
    }
  }

  // Auto-ingest knowledge entries if directory exists
  await _ingestKnowledgeEntries(db);

  Log.info('Database seeded successfully!');
  Log.info('- 3 Clients (Northwind, Lone Star Bank, Gulf Coast Bank)');
  Log.info('- 3 Starting Points');
  Log.info('- 6 Sites total');
  Log.info('- Offline-first dashboard data ready');
  // Add this line after existing seed calls
  await seedContinuingEducationCourses(db);
}

// Seed Continuing Education Courses
Future<void> seedContinuingEducationCourses(AppDatabase db) async {
  final courses = await db.select(db.continuingEducationCourses).get();
  if (courses.isNotEmpty) {
    Log.info('Continuing Education courses already seeded');
    return;
  }

  Log.info('Seeding Continuing Education courses...');

  // Technical - ATM Training
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Diebold Nixdorf ATM Certification',
          provider: 'Diebold Nixdorf',
          description: Value(
            'Complete certification program for DN Series ATM maintenance and troubleshooting. Covers hardware, software, and diagnostics.',
          ),
          category: 'Technical',
          durationHours: Value(24),
          externalUrl: Value('https://training.dieboldnixdorf.com'),
        ),
      );

  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Genmega ATM Service Training',
          provider: 'Genmega',
          description: Value(
            'Service training for Genmega ATM models including Onyx, GT3000, and G2500 series.',
          ),
          category: 'Technical',
          durationHours: Value(16),
        ),
      );

  // Technical - Currency Counters
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Cummins Currency Counter Certification',
          provider: 'Cummins Allison',
          description: Value(
            'JetScan and JetSort currency counter maintenance, calibration, and troubleshooting certification.',
          ),
          category: 'Technical',
          durationHours: Value(8),
        ),
      );

  // Technical - Check Scanners
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Check Scanner Maintenance',
          provider: 'Canon/Panini',
          description: Value(
            'Service training for check scanners including cleaning, calibration, and MICR troubleshooting.',
          ),
          category: 'Technical',
          durationHours: Value(4),
        ),
      );

  // Technical - Coin Sorters
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Coin Sorter Service Training',
          provider: 'Cummins Allison',
          description: Value(
            'Service and maintenance for coin sorting equipment including JetSort series.',
          ),
          category: 'Technical',
          durationHours: Value(4),
        ),
      );

  // Technical - DVR Systems
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'DVR Systems Installation & Service',
          provider: 'Hanwha/Hikvision',
          description: Value(
            'Digital video recorder installation, configuration, and troubleshooting for banking security systems.',
          ),
          category: 'Technical',
          durationHours: Value(8),
        ),
      );

  // Technical - Locksmith
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Commercial Locksmith Certification',
          provider: 'ALOA',
          description: Value(
            'Associated Locksmiths of America certification for commercial locksmithing including vault locks and access control.',
          ),
          category: 'Technical',
          durationHours: Value(40),
          externalUrl: Value('https://aloa.org'),
        ),
      );

  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Vault & Safe Service',
          provider: 'SAVTA',
          description: Value(
            'Safe and Vault Technicians Association training for bank vault service and repair.',
          ),
          category: 'Technical',
          durationHours: Value(24),
        ),
      );

  // Technical - Alarm Systems
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Bank Alarm Systems Service',
          provider: 'Honeywell',
          description: Value(
            'Installation and service training for bank security alarm systems including intrusion detection and silent alarms.',
          ),
          category: 'Technical',
          durationHours: Value(16),
        ),
      );

  // Safety Training
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'OSHA Safety Compliance 2026',
          provider: 'OSHA',
          description: Value(
            'Annual OSHA safety training covering workplace hazards, PPE requirements, and emergency procedures.',
          ),
          category: 'Safety',
          durationHours: Value(4),
        ),
      );

  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Bank Security Protocols',
          provider: 'Internal',
          description: Value(
            'Banking facility security procedures, access control, and incident reporting protocols.',
          ),
          category: 'Safety',
          durationHours: Value(2),
        ),
      );

  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Electrical Safety Training',
          provider: 'OSHA',
          description: Value(
            'Electrical safety procedures for working with ATMs, currency counters, and other powered equipment.',
          ),
          category: 'Safety',
          durationHours: Value(4),
        ),
      );

  // Compliance Training
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'BSA/AML Awareness for Service Technicians',
          provider: 'Internal',
          description: Value(
            'Bank Secrecy Act and Anti-Money Laundering awareness training for field service personnel.',
          ),
          category: 'Compliance',
          durationHours: Value(2),
        ),
      );

  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Data Privacy & GLBA Compliance',
          provider: 'Internal',
          description: Value(
            'Gramm-Leach-Bliley Act compliance and customer data privacy requirements for service technicians.',
          ),
          category: 'Compliance',
          durationHours: Value(2),
        ),
      );

  // HR Compliance
  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Workplace Harassment Prevention',
          provider: 'Internal',
          description: Value(
            'Annual harassment prevention training covering workplace conduct, reporting procedures, and legal requirements.',
          ),
          category: 'HR',
          durationHours: Value(2),
        ),
      );

  await db.into(db.continuingEducationCourses).insert(
        ContinuingEducationCoursesCompanion.insert(
          title: 'Diversity & Inclusion Training',
          provider: 'Internal',
          description: Value(
            'Company diversity and inclusion training covering unconscious bias, inclusive practices, and respectful workplace behavior.',
          ),
          category: 'HR',
          durationHours: Value(2),
        ),
      );

  Log.info(
    'Continuing Education courses seeded successfully - 16 courses added',
  );
}

Future<void> _ingestKnowledgeEntries(AppDatabase db) async {
  final knowledgeDir = r'C:\Portal_Knowledge_Staging';

  Log.info('=== Knowledge Ingestion Start ===');
  Log.info('Checking directory: $knowledgeDir');

  if (!Directory(knowledgeDir).existsSync()) {
    Log.info('✗ Knowledge directory not found: $knowledgeDir');
    Log.info('Skipping knowledge ingestion');
    return;
  }

  Log.info('✓ Knowledge directory exists');

  try {
    // Always clear and re-ingest to ensure fresh data
    final existingEntries = await db.getAllKnowledgeEntries();
    Log.info('Current entries in database: ${existingEntries.length}');

    if (existingEntries.isNotEmpty) {
      Log.info(
        'Clearing ${existingEntries.length} existing knowledge entries...',
      );
      await db.clearAllKnowledgeEntries();
      Log.info('✓ Cleared existing entries');
    }

    Log.info('Starting ingestion from: $knowledgeDir');

    // Find all .md files recursively
    final mdFiles = <File>[];
    final dir = Directory(knowledgeDir);

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        // Skip logs and temporary folders
        final lowerPath = entity.path.toLowerCase();
        if (lowerPath.contains('_logs') ||
            lowerPath.contains('_unclassified') ||
            lowerPath.contains('phase4-database') ||
            lowerPath.contains('temp')) {
          continue;
        }
        mdFiles.add(entity);
      }
    }

    if (mdFiles.isEmpty) {
      Log.info('No Markdown files found in knowledge directory');
      return;
    }

    Log.info('Found ${mdFiles.length} Markdown files');

    int successCount = 0;
    int errorCount = 0;

    for (final file in mdFiles) {
      try {
        final content = await file.readAsString();
        final lines = content.split('\n');

        // Parse YAML frontmatter
        String? title;
        String bodyMarkdown = '';
        Map? metadata;

        if (lines.isNotEmpty && lines[0].trim() == '---') {
          final yamlLines = <String>[];
          int bodyStartIndex = 1;

          for (int i = 1; i < lines.length; i++) {
            if (lines[i].trim() == '---') {
              bodyStartIndex = i + 1;
              break;
            }
            yamlLines.add(lines[i]);
          }

          if (yamlLines.isNotEmpty) {
            final yamlContent = yamlLines.join('\n');
            try {
              final doc = loadYaml(yamlContent);
              if (doc is Map) {
                metadata = doc;
                title = doc['title']?.toString();
              }
            } catch (e) {
              Log.info('Error parsing YAML in ${file.path}: $e');
            }
          }

          bodyMarkdown = lines.sublist(bodyStartIndex).join('\n').trim();
        } else {
          bodyMarkdown = content;
        }

        // Title: prefer frontmatter, then first H1, then filename
        if (title == null || title.isEmpty) {
          final h1Match =
              RegExp(r'^#\s+(.+)$', multiLine: true).firstMatch(bodyMarkdown);
          if (h1Match != null) {
            title = h1Match.group(1);
          } else {
            title = path
                .basenameWithoutExtension(file.path)
                .replaceAll('_', ' ')
                .replaceAll('-', ' ');
          }
        }

        final fileName = path.basenameWithoutExtension(file.path);

        // Always derive equipment type and category from path (most reliable)
        final equipmentType =
            KnowledgeCategorizer.guessEquipmentType(file.path);
        final contentType =
            KnowledgeCategorizer.guessContentType(fileName, bodyMarkdown);
        final category = KnowledgeCategorizer.guessCategory(file.path,
            contentType: contentType);
        final equipmentModel =
            KnowledgeCategorizer.guessEquipmentModel(fileName, metadata);
        final keywords = KnowledgeCategorizer.extractKeywords(
            title!, bodyMarkdown, equipmentType);
        final summary =
            KnowledgeCategorizer.extractSummary(title, bodyMarkdown);
        final difficulty = KnowledgeCategorizer.guessDifficulty(bodyMarkdown);
        final estimatedTime = KnowledgeCategorizer.estimateTime(bodyMarkdown);

        final entryId = metadata?['id']?.toString() ??
            fileName
                .toLowerCase()
                .replaceAll(' ', '-')
                .replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');

        // Insert into database with V15 enhanced fields
        await db.insertOrReplaceKnowledge(
          KnowledgeEntriesCompanion(
            id: Value(entryId),
            title: Value(title),
            category: Value(category),
            content: Value(bodyMarkdown),
            equipmentType: Value(equipmentType),
            equipmentModel: equipmentModel != null
                ? Value(equipmentModel)
                : const Value.absent(),
            sourceType:
                Value(metadata?['source_type']?.toString() ?? 'manual_import'),
            sourceFile: Value(metadata?['source_file']?.toString() ??
                path.basename(file.path)),
            version: Value(metadata?['version']?.toString() ?? '1.0.0'),
            status: Value(metadata?['status']?.toString() ?? 'active'),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
            contentType: Value(contentType),
            difficulty: Value(difficulty),
            estimatedTime: estimatedTime != null
                ? Value(estimatedTime)
                : const Value.absent(),
            keywords: Value(keywords),
            summary: summary != null ? Value(summary) : const Value.absent(),
          ),
        );

        successCount++;
      } catch (e) {
        errorCount++;
        Log.info('Error ingesting ${path.basename(file.path)}: $e');
      }
    }

    Log.info('=== Knowledge Ingestion Complete ===');
    Log.info('Success: $successCount');
    Log.info('Errors: $errorCount');
    Log.info('Total files processed: ${mdFiles.length}');

    // Verify
    final allEntries = await db.getAllKnowledgeEntries();
    Log.info(
      '✓ VERIFICATION: ${allEntries.length} knowledge entries now in database',
    );

    if (allEntries.isEmpty) {
      Log.info('⚠️  WARNING: No entries found after ingestion!');
      Log.info('This may indicate a database connection issue.');
    } else {
      final categories = allEntries.map((e) => e.category).toSet().toList()
        ..sort();
      Log.info(
        '✓ Categories: ${categories.length} (${categories.take(10).join(", ")}${categories.length > 10 ? "..." : ""})',
      );
      Log.info('✓ Knowledge base is ready!');
    }
  } catch (e, stackTrace) {
    Log.info('✗ ERROR during knowledge ingestion: $e');
    Log.info('Stack trace: $stackTrace');
    // Don't fail the entire seeding process if knowledge ingestion fails
  }

  Log.info('=== Knowledge Ingestion End ===');
}

Future<void> _seedGulfCoastLocations(AppDatabase db) async {
  final allSites = await db.getAllSites();
  final GulfCoastSites = allSites
      .where(
        (s) =>
            s.branchName.contains('Northwest Blvd') ||
            s.branchName.contains('Alice'),
      )
      .toList();

  if (GulfCoastSites.isNotEmpty) {
    Log.info('- GulfCoast locations already enriched, skipping.');
    return;
  }

  Log.info('Enriching Gulf Coast Bank locations...');

  // Find GulfCoast Client ID
  final clients = await db.getAllClients();
  final GulfCoastClient = clients.firstWhere(
    (c) => c.name.toLowerCase().contains('gulfcoast'),
    orElse: () => throw Exception('Gulf Coast Bank client not found'),
  );

  final List<Map<String, dynamic>> newSites = [
    {
      'name': 'Alice',
      'address': '1200 E. Main, Alice, TX',
      'lat': 27.75,
      'long': -98.07,
      'region': 'South',
    },
    {
      'name': 'Aransas Pass',
      'address': '1005 S. Commercial St, Aransas Pass, TX',
      'lat': 27.904,
      'long': -97.149,
      'region': 'Coastal',
    },
    {
      'name': 'Bastrop',
      'address': '499 Highway 71 West, Bastrop, TX',
      'lat': 30.110,
      'long': -97.311,
      'region': 'Central',
    },
    {
      'name': 'Beeville',
      'address': '100 S Washington, Beeville, TX',
      'lat': 28.401,
      'long': -97.750,
      'region': 'South',
    },
    {
      'name': 'Bryan (Texas Ave)',
      'address': '2807 S Texas Ave, Bryan, TX',
      'lat': 30.655,
      'long': -96.353,
      'region': 'East',
    },
    {
      'name': 'Bryan (29th St)',
      'address': '3710 E. 29th St., Bryan, TX',
      'lat': 30.665,
      'long': -96.342,
      'region': 'East',
    },
    {
      'name': 'Bryan (University)',
      'address': '3333 E University Dr, Bryan, TX',
      'lat': 30.648,
      'long': -96.331,
      'region': 'East',
    },
    {
      'name': 'Caldwell',
      'address': '129 W Buck St, Caldwell, TX',
      'lat': 30.531,
      'long': -96.691,
      'region': 'East',
    },
    {
      'name': 'Canton',
      'address': '898 W Dallas St, Canton, TX',
      'lat': 32.553,
      'long': -95.864,
      'region': 'North',
    },
    {
      'name': 'Cedar Park',
      'address': '650 E Whitestone Blvd, Cedar Park, TX',
      'lat': 30.506,
      'long': -97.824,
      'region': 'Central',
    },
    {
      'name': 'Mathis',
      'address': '103 N Highway 359, Mathis, TX',
      'lat': 28.09,
      'long': -97.82,
      'region': 'South',
    },
    {
      'name': 'Sinton',
      'address': '1127 E Sinton Street, Sinton, TX',
      'lat': 28.036,
      'long': -97.509,
      'region': 'Coastal',
    },
    {
      'name': 'Taft',
      'address': '421 Green Ave., Taft, TX',
      'lat': 27.981,
      'long': -97.400,
      'region': 'Coastal',
    },
    {
      'name': 'CC - Northwest',
      'address': '14201 Northwest Blvd, Corpus Christi, TX',
      'lat': 27.854,
      'long': -97.584,
      'region': 'Coastal',
    },
    {
      'name': 'CC - Leopard',
      'address': '11113 Leopard Street, Corpus Christi, TX',
      'lat': 27.818,
      'long': -97.534,
      'region': 'Coastal',
    },
    {
      'name': 'CC - Water St',
      'address': '921 N Water Street, Corpus Christi, TX',
      'lat': 27.801,
      'long': -97.394,
      'region': 'Coastal',
    },
    {
      'name': 'CC - Saratoga',
      'address': '4002 Saratoga Blvd, Corpus Christi, TX',
      'lat': 27.701,
      'long': -97.394,
      'region': 'Coastal',
    },
    {
      'name': 'CC - Staples South',
      'address': '6670 S. Staples St., Corpus Christi, TX',
      'lat': 27.652,
      'long': -97.375,
      'region': 'Coastal',
    },
    {
      'name': 'CC - Staples North',
      'address': '4115 S Staples St, Corpus Christi, TX',
      'lat': 27.712,
      'long': -97.382,
      'region': 'Coastal',
    },
    {
      'name': 'CC - Padre Island',
      'address': '15201 S Padre Island Dr, Corpus Christi, TX',
      'lat': 27.615,
      'long': -97.234,
      'region': 'Coastal',
    },
  ];

  for (final site in newSites) {
    try {
      await db.into(db.sites).insert(
            SitesCompanion.insert(
              clientId: GulfCoastClient.id,
              branchName: site['name'],
              address: site['address'],
              latitude: site['lat'],
              longitude: site['long'],
              region: site['region'],
            ),
          );
    } catch (e) {
      Log.info('Error seeding site ${site['name']}: $e');
    }
  }
  Log.info('✓ Added ${newSites.length} Gulf Coast Bank locations');
}

Future<void> _seedTeamMembers(AppDatabase db) async {
  // Check if we already have the expected count to avoid constant deletions
  final allUsers = await db.getAllUsers();
  final teamMemberUsernames = [
    'tech1',
    'tech2',
    'tech3',
    'tech4',
    'tech5',
    'tech6',
    'tech7',
    'tech8',
  ];

  // Count how many of our target team members actually exist
  int existingTeamCount = 0;
  for (var user in allUsers) {
    if (teamMemberUsernames.contains(user.username.toLowerCase())) {
      existingTeamCount++;
    }
  }

  // If we already have everyone, don't clear and recreate unless names changed
  if (existingTeamCount == teamMemberUsernames.length &&
      !allUsers.any((u) => u.username == 'jbennet' || u.username == 'Chand')) {
    Log.info('- Team members already up to date.');
    return;
  }

  Log.info('Updating team members list...');

  // Delete existing team members (by username) - keeps Demo Technician and other users
  for (var user in allUsers) {
    if (teamMemberUsernames.contains(user.username.toLowerCase()) ||
        user.username.toLowerCase() == 'jbennet' ||
        user.username.toLowerCase() == 'tech3') {
      await (db.delete(db.users)..where((tbl) => tbl.id.equals(user.id))).go();
    }
  }

  final teamMembers = [
    {
      'username': 'tech1',
      'fullName': 'Demo Technician 1',
      'email': '[redacted-email]',
    },
    {
      'username': 'tech2',
      'fullName': 'Demo Technician 2',
      'email': '[redacted-email]',
    },
    {
      'username': 'tech3',
      'fullName': 'Demo Technician 3',
      'email': '[redacted-email]',
    },
    {
      'username': 'tech4',
      'fullName': 'Demo Technician 4',
      'email': '[redacted-email]',
    },
    {
      'username': 'tech5',
      'fullName': 'Demo Technician 5',
      'email': '[redacted-email]',
    },
    {
      'username': 'tech6',
      'fullName': 'Demo Technician 6',
      'email': '[redacted-email]',
    },
    {
      'username': 'tech7',
      'fullName': 'Demo Technician 7',
      'email': '[redacted-email]',
    },
    {
      'username': 'tech8',
      'fullName': 'Demo Technician 8',
      'email': '[redacted-email]',
    },
  ];

  for (final member in teamMembers) {
    await db.into(db.users).insert(
          UsersCompanion.insert(
            username: member['username']!,
            fullName: member['fullName']!,
            email: member['email']!,
            role: 'Technician',
            password: const Value(''),
            location: const Value.absent(),
            bio: const Value.absent(),
            phoneNumber: const Value.absent(),
            dateOfBirth: const Value.absent(),
          ),
        );
  }
  Log.info('✓ Added ${teamMembers.length} team members');
}
