import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _categoryService.getCategories();
      if (_categories.isEmpty) {
        await _categoryService.initializeDefaultCategories();
        _categories = await _categoryService.getCategories();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(Category category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCategory = await _categoryService.createCategory(category);
      _categories.add(newCategory);
      _categories.sort((Category a, Category b) {
        if (a.isDefault != b.isDefault) {
          return a.isDefault ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(Category category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCategory = await _categoryService.updateCategory(category);
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = updatedCategory;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _categoryService.deleteCategory(categoryId);
      _categories.removeWhere((c) => c.id == categoryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Category? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }
}

