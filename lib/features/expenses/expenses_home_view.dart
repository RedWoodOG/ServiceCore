import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/services/expense_service.dart';
import '../../database/app_database.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_card.dart';

class ExpensesHomeView extends StatelessWidget {
  const ExpensesHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      floatingActionButton: user == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openAddExpense(context),
              icon: const Icon(Icons.add),
              label: const Text('Add expense'),
            ),
      body: user == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Sign in to record and view your expenses.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ),
            )
          : StreamBuilder<List<Expense>>(
              stream: context.read<AppDatabase>().watchUserExpenses(user.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Could not load expenses: ${snapshot.error}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                final items = snapshot.data ?? const <Expense>[];
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 72,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No expenses yet',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Track fuel, meals, parking, and other field costs. '
                            'Entries stay on this device until you sync or export.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final e = items[i];
                    return GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _categoryLabel(e.category),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                NumberFormat.currency(symbol: r'$').format(e.amount),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DateFormat.yMMMd().add_jm().format(e.expenseDate.toLocal()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          if (e.description != null && e.description!.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              e.description!.trim(),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                          if (e.workOrderId != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Work order #${e.workOrderId}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ],
                          if (e.receiptPath != null && e.receiptPath!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 18,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    p.basename(e.receiptPath!),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelSmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  static String _categoryLabel(String c) {
    return c.split('_').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  static Future<void> _openAddExpense(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddExpenseSheet(),
    );
  }
}

class _AddExpenseSheet extends StatefulWidget {
  const _AddExpenseSheet();

  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();
  String _category = expenseCategories.first;
  int? _workOrderId;
  List<WorkOrder> _workOrders = const [];
  bool _loadingOrders = true;
  String? _receiptCopyPath;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWorkOrders();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkOrders() async {
    final db = context.read<AppDatabase>();
    try {
      final list = await (db.select(db.workOrders)
            ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]))
          .get();
      if (!mounted) return;
      setState(() {
        _workOrders = list.take(80).toList();
        _loadingOrders = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingOrders = false);
    }
  }

  Future<void> _pickReceipt() async {
    final auth = context.read<AuthProvider>();
    final uid = auth.currentUser?.id ?? 0;
    if (uid == 0) return;

    final picker = ImagePicker();
    final shot = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (shot == null || !context.mounted) return;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(appDir.path, 'portal_offline', 'expenses', '$uid'));
      if (!await dir.exists()) await dir.create(recursive: true);
      final ext = p.extension(shot.path);
      final dest = p.join(dir.path, 'receipt_${DateTime.now().millisecondsSinceEpoch}$ext');
      await File(shot.path).copy(dest);
      if (mounted) {
        setState(() => _receiptCopyPath = dest);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save receipt copy: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text.trim().replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final svc = context.read<ExpenseService>();
    final result = await svc.create(
      CreateExpense(
        expenseDate: _date,
        category: _category,
        amount: amount,
        description: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        receiptPath: _receiptCopyPath,
        workOrderId: _workOrderId,
      ),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    result.when(
      ok: (_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense saved')),
        );
      },
      err: (f) => setState(() => _error = f.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scroll) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Text('New expense', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                ),
              Expanded(
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Date & time'),
                      subtitle: Text(DateFormat.yMMMd().add_jm().format(_date.toLocal())),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );
                        if (d == null || !context.mounted) return;
                        final t = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_date),
                        );
                        if (!context.mounted) return;
                        setState(() {
                          _date = DateTime(
                            d.year,
                            d.month,
                            d.day,
                            t?.hour ?? _date.hour,
                            t?.minute ?? _date.minute,
                          );
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: expenseCategories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(ExpensesHomeView._categoryLabel(c)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _category = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: r'$ ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_loadingOrders)
                      const LinearProgressIndicator()
                    else
                      DropdownButtonFormField<int?>(
                        initialValue: _workOrderId,
                        decoration: const InputDecoration(
                          labelText: 'Link to work order (optional)',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('None'),
                          ),
                          ..._workOrders.map(
                            (w) => DropdownMenuItem<int?>(
                              value: w.id,
                              child: Text(
                                '#${w.id} — ${(w.descriptionOfWork ?? 'Work order').split('\n').first}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _workOrderId = v),
                      ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _pickReceipt,
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: Text(_receiptCopyPath == null ? 'Attach receipt photo' : 'Receipt attached'),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save expense'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
