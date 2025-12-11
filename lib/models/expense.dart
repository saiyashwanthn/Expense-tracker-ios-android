class Expense {
  final String? id;
  final String userId;
  final String categoryId;
  final String categoryName;
  final double amount;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Expense({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.description,
    required this.date,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'category_name': categoryName,
      'amount': amount,
      'description': description,
      // Format date as YYYY-MM-DD for DATE column (not TIMESTAMP)
      'date': _formatDateOnly(date),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Formats a DateTime as YYYY-MM-DD string for DATE column storage
  /// This ensures proper storage in PostgreSQL DATE columns
  static String _formatDateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Expense copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? categoryName,
    double? amount,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

