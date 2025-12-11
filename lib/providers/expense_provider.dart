import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _expenseService.getExpenses(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newExpense = await _expenseService.createExpense(expense);
      _expenses.insert(0, newExpense);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedExpense = await _expenseService.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _expenseService.deleteExpense(expenseId);
      _expenses.removeWhere((e) => e.id == expenseId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, double>> getExpensesByCategory({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    return await _expenseService.getExpensesByCategory(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );
  }

  Future<double> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    return await _expenseService.getTotalExpenses(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );
  }
}

