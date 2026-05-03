import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

/// Allowed expense categories (matches [Expenses.category] schema).
const expenseCategories = <String>[
  'fuel',
  'tolls',
  'parking',
  'meals',
  'parts',
  'other',
];

/// Create a local expense row (offline-first).
class CreateExpense {
  const CreateExpense({
    required this.expenseDate,
    required this.category,
    required this.amount,
    this.description,
    this.receiptPath,
    this.workOrderId,
  });

  final DateTime expenseDate;
  final String category;
  final double amount;
  final String? description;
  final String? receiptPath;
  final int? workOrderId;
}

class ExpenseService {
  ExpenseService({
    required AppDatabase db,
    required User? currentUser,
  })  : _db = db,
        _currentUser = currentUser;

  final AppDatabase _db;
  final User? _currentUser;

  Future<Result<int>> create(CreateExpense cmd) async {
    if (_currentUser == null) {
      return const Err(UnauthorizedFailure('Authentication required'));
    }

    if (cmd.amount <= 0 || cmd.amount.isNaN || cmd.amount.isInfinite) {
      return Err(ValidationFailure('Enter a valid amount greater than zero', field: 'amount'));
    }

    final cat = cmd.category.toLowerCase().trim();
    if (!expenseCategories.contains(cat)) {
      return Err(ValidationFailure('Invalid category', field: 'category'));
    }

    if (cmd.workOrderId != null && cmd.workOrderId! > 0) {
      try {
        final wo = await _db.getWorkOrderById(cmd.workOrderId!);
        if (wo == null) {
          return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
        }
      } catch (e, st) {
        return Err(StorageFailure('Failed to verify work order', cause: e, stackTrace: st));
      }
    }

    try {
      final id = await _db.into(_db.expenses).insert(
            ExpensesCompanion.insert(
              userId: _currentUser!.id,
              expenseDate: cmd.expenseDate,
              category: cat,
              amount: cmd.amount,
              description: Value(
                cmd.description?.trim().isEmpty ?? true ? null : cmd.description?.trim(),
              ),
              receiptPath: Value(cmd.receiptPath),
              workOrderId: Value(cmd.workOrderId),
            ),
          );
      Log.info('ExpenseService: Created expense $id');
      return Ok(id);
    } catch (e, st) {
      Log.error('ExpenseService: insert failed', e, st);
      return Err(StorageFailure('Could not save expense', cause: e, stackTrace: st));
    }
  }
}
