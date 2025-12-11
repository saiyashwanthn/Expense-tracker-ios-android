import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> getCurrentUserId() async {
    final user = _supabase.auth.currentUser;
    return user?.id;
  }

  Future<List<Category>> getCategories() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('categories')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false)
        .order('name', ascending: true);

    return (response as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  Future<Category> createCategory(Category category) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('categories')
        .insert(category.toJson())
        .select()
        .single();

    return Category.fromJson(response);
  }

  Future<Category> updateCategory(Category category) async {
    if (category.id == null) throw Exception('Category ID is required');

    final response = await _supabase
        .from('categories')
        .update(category.copyWith(updatedAt: DateTime.now()).toJson())
        .eq('id', category.id!)
        .select()
        .single();

    return Category.fromJson(response);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _supabase.from('categories').delete().eq('id', categoryId);
  }

  Future<void> initializeDefaultCategories() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    // Check if default categories already exist
    final existingCategories = await getCategories();
    if (existingCategories.any((c) => c.isDefault)) {
      return; // Default categories already initialized
    }

    final defaultCategories = [
      Category(
        userId: userId,
        name: 'Groceries',
        icon: '🛒',
        color: '#4CAF50',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
      Category(
        userId: userId,
        name: 'Online Food',
        icon: '🍔',
        color: '#FF9800',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
      Category(
        userId: userId,
        name: 'Mandatory Bills',
        icon: '💡',
        color: '#2196F3',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
      Category(
        userId: userId,
        name: 'Credit Card Bills',
        icon: '💳',
        color: '#9C27B0',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
      Category(
        userId: userId,
        name: 'Transportation',
        icon: '🚗',
        color: '#00BCD4',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
      Category(
        userId: userId,
        name: 'Entertainment',
        icon: '🎬',
        color: '#E91E63',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
      Category(
        userId: userId,
        name: 'Healthcare',
        icon: '🏥',
        color: '#F44336',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
      Category(
        userId: userId,
        name: 'Other',
        icon: '📦',
        color: '#9E9E9E',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
    ];

    for (var category in defaultCategories) {
      await _supabase.from('categories').insert(category.toJson());
    }
  }
}

