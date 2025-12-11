import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1); // Start of month
    _endDate = now; // Today
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedCategoryId = null; // Reset category filter
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Column(
        children: [
          // Date Range Selector
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date Range',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _startDate != null && _endDate != null
                            ? '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}'
                            : 'Select date range',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDateRange,
                  ),
                ],
              ),
            ),
          ),

          // Category Filter
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Category (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.filter_list),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ...categoryProvider.categories.map((Category category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text('${category.icon} ${category.name}'),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Analytics Content
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, expenseProvider, _) {
                return FutureBuilder<Map<String, double>>(
                  future: expenseProvider.getExpensesByCategory(
                    startDate: _startDate,
                    endDate: _endDate,
                    categoryId: _selectedCategoryId,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final categoryTotals = snapshot.data ?? {};
                    
                    if (categoryTotals.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No expenses in this period',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

                    return RefreshIndicator(
                      onRefresh: () => expenseProvider.loadExpenses(
                        startDate: _startDate,
                        endDate: _endDate,
                        categoryId: _selectedCategoryId,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Total Amount Card
                            Card(
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Expenses',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${total.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Pie Chart
                            const Text(
                              'Spending by Category',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: _PieChartWidget(
                                categoryTotals: categoryTotals,
                                total: total,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Category Breakdown List
                            const Text(
                              'Category Breakdown',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...categoryTotals.entries.map((entry) {
                              final percentage = (entry.value / total * 100);
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  title: Text(entry.key),
                                  subtitle: LinearProgressIndicator(
                                    value: percentage / 100,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${entry.value.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${percentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PieChartWidget extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double total;

  const _PieChartWidget({
    required this.categoryTotals,
    required this.total,
  });

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final entries = categoryTotals.entries.toList();
    
    return PieChart(
      PieChartData(
        sections: entries.asMap().entries.map((entry) {
          final index = entry.key;
          final categoryEntry = entry.value;
          final percentage = (categoryEntry.value / total * 100);
          
          return PieChartSectionData(
            value: categoryEntry.value,
            title: '${percentage.toStringAsFixed(1)}%',
            color: _getColorForIndex(index),
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}

