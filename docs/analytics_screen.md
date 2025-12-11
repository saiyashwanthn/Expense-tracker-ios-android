# Analytics Screen Documentation

## Overview
The Analytics Screen provides users with visual representations and detailed breakdowns of their spending patterns. It includes charts, category-wise analysis, and flexible date range filtering.

## Location
`lib/screens/analytics_screen.dart`

## Functionality

### Screen Features
1. **Date Range Selection**: Filter expenses by custom date range
2. **Category Filtering**: Optional filter by specific category
3. **Total Expenses Display**: Prominent card showing total for selected period
4. **Pie Chart Visualization**: Interactive pie chart showing spending by category
5. **Category Breakdown List**: Detailed list with percentages and progress bars

### Date Range Filter
- **Default**: Current month (from 1st of month to today)
- **Selection**: Tap calendar icon to open date range picker
- **Display**: Shows formatted date range (e.g., "Jan 01 - Jan 15, 2024")
- **Reset**: Selecting new range resets category filter

### Category Filter
- **Type**: Dropdown with all categories
- **Default**: "All Categories" (no filter)
- **Behavior**: Filters both chart and breakdown list
- **Reset**: Automatically reset when date range changes

### Visualizations

#### 1. Total Expenses Card
- Large blue card at top
- Shows total amount for selected period
- Formatted currency display

#### 2. Pie Chart
- **Library**: fl_chart
- **Sections**: One per category (if expenses exist)
- **Labels**: Percentage of total spending
- **Colors**: Assigned automatically from color palette
- **Size**: 300px height
- **Center Space**: 40px radius (for potential center label)

#### 3. Category Breakdown List
- **Format**: Card-based list
- **Information**:
  - Category name
  - Amount spent
  - Percentage of total
  - Visual progress bar
- **Order**: By amount (highest first)

## State Management

### Providers Used
- `ExpenseProvider`: For fetching expense data and calculations
- `CategoryProvider`: For category filter dropdown

### Data Loading
1. On screen initialization:
   - Sets default date range (start of month to today)
   - Loads category totals via `getExpensesByCategory()`
2. On date range change:
   - Recalculates category totals
   - Resets category filter
3. On category filter change:
   - Filters displayed data

## Code Flow

### Initialization
```dart
@override
void initState() {
  super.initState();
  final now = DateTime.now();
  _startDate = DateTime(now.year, now.month, 1); // Start of month
  _endDate = now; // Today
}
```

### Date Range Selection
```dart
Future<void> _selectDateRange() async {
  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    initialDateRange: DateRange(_startDate!, _endDate!),
  );
  
  if (picked != null) {
    setState(() {
      _startDate = picked.start;
      _endDate = picked.end;
      _selectedCategoryId = null; // Reset filter
    });
  }
}
```

### Data Fetching
```dart
FutureBuilder<Map<String, double>>(
  future: expenseProvider.getExpensesByCategory(
    startDate: _startDate,
    endDate: _endDate,
  ),
  builder: (context, snapshot) {
    // Handle loading, empty, and data states
  },
)
```

### Pie Chart Generation
- Maps category totals to `PieChartSectionData`
- Calculates percentage for each category
- Assigns colors from predefined palette
- Creates sections with spacing

## Calculations

### Total Expenses
```dart
final total = categoryTotals.values.fold(0.0, (a, b) => a + b);
```

### Percentage Calculation
```dart
final percentage = (categoryEntry.value / total * 100);
```

### Category Totals
- Fetched via `ExpenseProvider.getExpensesByCategory()`
- Groups expenses by category name
- Sums amounts per category
- Returns map: `{categoryName: totalAmount}`

## UI Components

### Date Range Card
- Shows selected date range
- Calendar icon button
- Clear visual hierarchy

### Category Filter Dropdown
- Material dropdown with icon
- "All Categories" option
- Category icons and names

### Total Expenses Card
- Prominent blue card
- Large text for amount
- Clear label

### Pie Chart Widget
- Custom widget `_PieChartWidget`
- Uses fl_chart library
- Color-coded sections
- Percentage labels

### Category Breakdown Cards
- List of cards, one per category
- Progress bar visualization
- Amount and percentage display
- Sorted by amount (highest first)

## Color Palette
Used for pie chart sections (rotates if more categories than colors):
- Blue, Green, Orange, Purple, Red, Teal, Pink, Amber, Indigo, Cyan

## Error Handling
- Loading states shown with `CircularProgressIndicator`
- Empty states show helpful message when no expenses in period
- Error states handled by provider
- Pull-to-refresh for manual refresh

## Data Filtering Logic

### Date Range Filter
- Applied at database query level
- Filters expenses by `date` field
- Inclusive of both start and end dates

### Category Filter
- Applied at query level (if selected)
- Filters expenses by `category_id`
- Combined with date range filter

## Future Enhancements
- Bar chart for time-series analysis
- Line chart for spending trends over time
- Monthly/weekly/yearly comparison views
- Budget vs actual spending comparison
- Export analytics as PDF/image
- Share analytics reports
- Custom date presets (Last 7 days, Last 30 days, This Year, etc.)
- Multiple currency support
- Category-wise trend analysis
- Spending predictions based on history
- Budget recommendations based on patterns

