# Add/Edit Expense Screen Documentation

## Overview
The Add/Edit Expense Screen allows users to create new expense entries or modify existing ones. It provides a comprehensive form with validation and category selection.

## Location
`lib/screens/add_edit_expense_screen.dart`

## Functionality

### Screen Modes
1. **Add Mode**: Creating a new expense (no expense passed to constructor)
2. **Edit Mode**: Modifying an existing expense (expense object passed to constructor)

### Form Fields

#### 1. Category Selection
- **Type**: Dropdown with icon and name
- **Validation**: Required field
- **Behavior**: 
  - Loads all available categories from `CategoryProvider`
  - In edit mode, pre-selects the expense's current category
  - In add mode, selects first category by default
  - Displays category icon and name

#### 2. Amount Input
- **Type**: Text field with numeric keyboard
- **Validation**: 
  - Required field
  - Must be a valid number
  - Must be greater than 0
- **Format**: Decimal number (e.g., 25.50)
- **Icon**: Dollar sign icon

#### 3. Description Input
- **Type**: Multi-line text field (3 lines)
- **Validation**: Optional field
- **Purpose**: Additional details about the expense
- **Icon**: Description icon

#### 4. Date Selection
- **Type**: Date picker
- **Default**: Current date (in add mode) or expense date (in edit mode)
- **Constraints**: 
  - Earliest date: January 1, 2020
  - Latest date: Today
- **Display**: Formatted as "MMM dd, yyyy" (e.g., "Jan 15, 2024")
- **Icon**: Calendar icon

### Actions

#### Save/Update Expense
1. Validates all required fields
2. Checks category selection
3. Creates/updates expense via `ExpenseProvider`
4. Shows success message
5. Navigates back to previous screen
6. Triggers expense list refresh

#### Delete Expense (Edit Mode Only)
1. Shows confirmation dialog
2. Deletes expense via `ExpenseProvider`
3. Shows success message
4. Navigates back to previous screen
5. Triggers expense list refresh

## State Management

### Providers Used
- `ExpenseProvider`: For saving/updating/deleting expenses
- `CategoryProvider`: For loading and displaying categories

### Local State
- `_amountController`: Text editing controller for amount
- `_descriptionController`: Text editing controller for description
- `_selectedCategory`: Currently selected category object
- `_selectedDate`: Selected date for expense
- `_isLoading`: Loading state during save/delete operations

## Code Flow

### Initialization
```dart
@override
void initState() {
  super.initState();
  // Pre-fill form if editing
  if (widget.expense != null) {
    _amountController.text = widget.expense!.amount.toString();
    _descriptionController.text = widget.expense!.description;
    _selectedDate = widget.expense!.date;
  }
  // Load categories after build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadCategories();
  });
}
```

### Category Loading
```dart
void _loadCategories() {
  final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
  categoryProvider.loadCategories().then((_) {
    // Pre-select category in edit mode
    if (widget.expense != null && categoryProvider.categories.isNotEmpty) {
      setState(() {
        _selectedCategory = categoryProvider.getCategoryById(
          widget.expense!.categoryId,
        );
      });
    } else if (categoryProvider.categories.isNotEmpty) {
      // Select first category in add mode
      setState(() {
        _selectedCategory = categoryProvider.categories.first;
      });
    }
  });
}
```

### Date Selection
```dart
Future<void> _selectDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
  );
  if (picked != null) {
    setState(() {
      _selectedDate = picked;
    });
  }
}
```

### Saving Expense
1. Validate form
2. Check category selection
3. Get current user ID
4. Create Expense model
5. Call provider method (add or update)
6. Handle success/error
7. Navigate back

### Deleting Expense
1. Show confirmation dialog
2. Call provider delete method
3. Handle success/error
4. Navigate back

## Validation Rules

### Amount
- Cannot be empty
- Must be a valid decimal number
- Must be greater than 0

### Category
- Must be selected (not null)

### Description
- Optional (no validation)

### Date
- Automatically validated by date picker constraints

## Error Handling
- Form validation errors shown inline
- API errors shown via SnackBar
- Loading states prevent multiple submissions
- User authentication errors handled

## UI Components

### Form Fields
- Material Design text fields with outlined borders
- Icons for visual clarity
- Clear validation error messages

### Date Picker
- Material date picker dialog
- Custom input decorator for consistent styling

### Action Buttons
- Elevated button for save/update
- Delete button in app bar (edit mode only)
- Disabled during loading states

## User Experience Features
- Pre-filled form in edit mode
- Default category selection in add mode
- Default date is today
- Clear visual feedback for validation errors
- Loading indicators during operations
- Success/error messages via SnackBar

## Future Enhancements
- Recurring expense option
- Photo attachment for receipts
- Location tagging
- Multiple currency support
- Expense templates/quick entries
- Voice input for description
- Barcode scanning for automatic entry

