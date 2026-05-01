import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fsc_portal/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Seed test client and site
    final client = await db
        .into(db.clients)
        .insertReturning(
          ClientsCompanion.insert(name: 'Test Client', themeColor: 'blue'),
        );

    await db
        .into(db.sites)
        .insert(
          SitesCompanion.insert(
            clientId: client.id,
            branchName: 'Test Branch',
            address: '123 Test St',
            latitude: 0.0,
            longitude: 0.0,
            region: 'Test',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('Performance Benchmarks', () {
    test('creates 1000 work orders in < 5 seconds', () async {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        await db
            .into(db.workOrders)
            .insert(
              WorkOrdersCompanion.insert(
                siteId: 1,
                status: 'open',
                createdAt: DateTime.now(),
                descriptionOfWork: Value('Test work order $i'),
              ),
            );
      }

      stopwatch.stop();
      print('Created 1000 work orders in ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    test('queries 10000 work orders by status in < 100ms', () async {
      // Seed database
      await db.batch((batch) {
        for (int i = 0; i < 10000; i++) {
          batch.insert(
            db.workOrders,
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: i % 3 == 0 ? 'open' : 'completed',
              createdAt: DateTime.now(),
              descriptionOfWork: Value('Test $i'),
            ),
          );
        }
      });

      // Benchmark query
      final stopwatch = Stopwatch()..start();
      final results = await db.watchWorkOrdersByStatus('open').first;
      stopwatch.stop();

      print(
        'Queried ${results.length} work orders in ${stopwatch.elapsedMilliseconds}ms',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    test('full-text search on 10000 records in < 200ms', () async {
      // Seed database with varied descriptions
      await db.batch((batch) {
        for (int i = 0; i < 10000; i++) {
          batch.insert(
            db.workOrders,
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              createdAt: DateTime.now(),
              descriptionOfWork: Value(
                'Work order $i - ${i % 2 == 0 ? "ATM repair" : "Counter service"}',
              ),
            ),
          );
        }
      });

      // Benchmark search
      final stopwatch = Stopwatch()..start();
      final results = await db.searchWorkOrders('ATM');
      stopwatch.stop();

      print(
        'Searched 10000 records in ${stopwatch.elapsedMilliseconds}ms, found ${results.length}',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });

    test('concurrent updates handle 100 simultaneous transactions', () async {
      // Create test work order
      final wo = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              createdAt: DateTime.now(),
              descriptionOfWork: const Value('Concurrent test'),
            ),
          );

      // Simulate 100 concurrent updates
      final stopwatch = Stopwatch()..start();
      final futures = List.generate(100, (i) async {
        try {
          await db
              .update(db.workOrders)
              .replace(
                wo.copyWith(
                  internalNotes: Value('Update $i'),
                  version: wo.version + i,
                ),
              );
        } catch (e) {
          // Expected - most will fail due to version mismatch
        }
      });

      await Future.wait(futures);
      stopwatch.stop();

      print(
        'Handled 100 concurrent updates in ${stopwatch.elapsedMilliseconds}ms',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });
  });
}
