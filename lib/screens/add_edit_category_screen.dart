import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';
import '../services/category_service.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final Category? category;

  const AddEditCategoryScreen({super.key, this.category});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedIcon = '📦';
  String _selectedColor = '#9E9E9E';
  bool _isLoading = false;

  final List<String> _availableIcons = [
    '🛒', '🍔', '💡', '💳', '🚗', '🎬', '🏥', '📦',
    '🍕', '☕', '🎮', '✈️', '🏠', '👕', '📱', '💻',
    '🎓', '🏋️', '🎨', '🎵', '📚', '🌮', '🍰', '🥤',
  ];

  final List<String> _availableColors = [
    '#4CAF50', '#FF9800', '#2196F3', '#9C27B0',
    '#00BCD4', '#E91E63', '#F44336', '#9E9E9E',
    '#FF5722', '#795548', '#607D8B', '#3F51B5',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedIcon = widget.category!.icon;
      _selectedColor = widget.category!.color;
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final categoryService = CategoryService();
      final userId = await categoryService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final category = Category(
        id: widget.category?.id,
        userId: userId,
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        isDefault: false,
        createdAt: widget.category?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      
      if (widget.category == null) {
        await categoryProvider.addCategory(category);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category added successfully')),
          );
        }
      } else {
        await categoryProvider.updateCategory(category);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category updated successfully')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Name Input
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Icon Selection
                  const Text(
                    'Select Icon',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableIcons.map((icon) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIcon = icon;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedIcon == icon
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.1),
                            border: Border.all(
                              color: _selectedIcon == icon
                                  ? Colors.blue
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Color Selection
                  const Text(
                    'Select Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableColors.map((colorHex) {
                      final color = _getColorFromHex(colorHex);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = colorHex;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: _selectedColor == colorHex
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: _selectedColor == colorHex
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Preview
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: _getColorFromHex(_selectedColor).withOpacity(0.2),
                            child: Text(
                              _selectedIcon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _nameController.text.isEmpty
                                ? 'Category Preview'
                                : _nameController.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveCategory,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      widget.category == null ? 'Add Category' : 'Update Category',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

