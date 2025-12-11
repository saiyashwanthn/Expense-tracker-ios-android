import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';

class ExpenseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> getCurrentUserId() async {
    final user = _supabase.auth.currentUser;
    return user?.id;
  }

  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    var query = _supabase
        .from('expenses')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);

    if (startDate != null) {
      query = query.gte('date', startDate.toIso8601String());
    }

    if (endDate != null) {
      query = query.lte('date', endDate.toIso8601String());
    }

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final response = await query;
    return (response as List)
        .map((json) => Expense.fromJson(json))
        .toList();
  }

  Future<Expense> createExpense(Expense expense) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('expenses')
        .insert(expense.toJson())
        .select()
        .single();

    return Expense.fromJson(response);
  }

  Future<Expense> updateExpense(Expense expense) async {
    if (expense.id == null) throw Exception('Expense ID is required');

    final response = await _supabase
        .from('expenses')
        .update(expense.copyWith(updatedAt: DateTime.now()).toJson())
        .eq('id', expense.id!)
        .select()
        .single();

    return Expense.fromJson(response);
  }

  Future<void> deleteExpense(String expenseId) async {
    await _supabase.from('expenses').delete().eq('id', expenseId);
  }

  Future<Map<String, double>> getExpensesByCategory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await getExpenses(
      startDate: startDate,
      endDate: endDate,
    );

    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.categoryName] =
          (categoryTotals[expense.categoryName] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  Future<double> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await getExpenses(
      startDate: startDate,
      endDate: endDate,
    );

    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}

