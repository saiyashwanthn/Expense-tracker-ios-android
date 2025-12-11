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

    // Build query with conditional filters
    final baseQuery = _supabase.from('expenses').select().eq('user_id', userId);
    
    final queryWithDateFilters = startDate != null
        ? (baseQuery as dynamic).gte('date', startDate.toIso8601String())
        : baseQuery;
    
    final queryWithEndDate = endDate != null
        ? (queryWithDateFilters as dynamic).lte('date', endDate.toIso8601String())
        : queryWithDateFilters;
    
    final queryWithCategory = categoryId != null
        ? (queryWithEndDate as dynamic).eq('category_id', categoryId)
        : queryWithEndDate;

    final response = await (queryWithCategory as dynamic).order('date', ascending: false);
    return (response as List<dynamic>)
        .map((json) => Expense.fromJson(json as Map<String, dynamic>))
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

    double total = 0.0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }
}

