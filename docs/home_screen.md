# Home Screen Documentation

## Overview
The Home Screen is the main entry point of the Expense Tracker application. It provides users with quick access to their expenses, overview statistics, and navigation to other features.

## Location
`lib/screens/home_screen.dart`

## Functionality

### Screen Structure
The Home Screen consists of:
1. **App Bar**: Displays app title and analytics shortcut
2. **Bottom Navigation Bar**: Switches between "Expenses" and "Overview" tabs
3. **Floating Action Button**: Quick access to add new expenses
4. **Drawer Menu**: Navigation to Categories, Analytics, Settings, and future AI Assistant

### Tab 1: Expenses Tab
- **Purpose**: Displays a list of all user expenses in reverse chronological order (newest first)
- **Features**:
  - Pull-to-refresh functionality
  - Empty state with helpful message when no expenses exist
  - Each expense card shows:
    - Category icon/avatar
    - Description (or category name if no description)
    - Category name and formatted date
    - Amount in red
  - Tap on expense card to edit/delete

### Tab 2: Overview Tab
- **Purpose**: Provides quick statistics and access to main features
- **Features**:
  - **Monthly Total Card**: Displays total expenses for current month in a prominent blue card
  - **Quick Actions Grid**: Four action cards:
    - Add Expense (green)
    - Analytics (orange)
    - Categories (purple)
    - Settings (blue)

### Drawer Menu
- **Categories**: Navigate to category management
- **Analytics**: Navigate to analytics/reports screen
- **Settings**: Navigate to app settings
- **AI Assistant**: Placeholder for future feature (disabled)

## State Management

### Providers Used
- `ExpenseProvider`: Manages expense data and operations
- `CategoryProvider`: Manages category data (loaded for navigation)

### Data Loading
On screen initialization:
1. Loads all expenses via `ExpenseProvider.loadExpenses()`
2. Loads all categories via `CategoryProvider.loadCategories()`

### Refresh Mechanism
- Pull-to-refresh on Expenses tab reloads expense data
- Navigation from Add/Edit Expense screen triggers refresh

## User Interactions

### Adding Expense
1. User taps Floating Action Button
2. Navigates to `AddEditExpenseScreen`
3. On return, expenses are reloaded

### Editing Expense
1. User taps on expense card
2. Navigates to `AddEditExpenseScreen` with expense data
3. On return, expenses are reloaded

### Navigation
- Drawer menu items navigate to respective screens
- Analytics icon in app bar navigates to Analytics screen
- Quick action cards navigate to their respective screens

## Code Flow

### Initialization
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadData();
  });
}
```

### Data Loading
```dart
void _loadData() {
  final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
  final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
  
  expenseProvider.loadExpenses();
  categoryProvider.loadCategories();
}
```

### Expense Display
- Uses `Consumer<ExpenseProvider>` to listen to expense changes
- Maps expenses to `_ExpenseCard` widgets
- Handles loading and empty states

### Monthly Total Calculation
- Uses `FutureBuilder` with `getTotalExpenses()` method
- Filters expenses from start of current month to today
- Displays formatted total amount

## UI Components

### _ExpenseCard
- Displays individual expense information
- Shows category avatar, description, date, and amount
- Tappable to edit expense

### _QuickActionCard
- Grid item for quick navigation
- Shows icon, title, and color theme
- Tappable to navigate to respective screen

## Error Handling
- Loading states shown with `CircularProgressIndicator`
- Empty states show helpful messages
- Error states handled by provider (can be enhanced with error UI)

## Future Enhancements
- Search functionality for expenses
- Filter by date range on home screen
- Swipe actions (delete, edit) on expense cards
- Recent expenses widget
- Quick expense entry shortcuts

