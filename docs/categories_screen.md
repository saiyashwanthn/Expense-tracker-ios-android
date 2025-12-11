# Categories Screen Documentation

## Overview
The Categories Screen allows users to view, create, edit, and delete expense categories. It displays both default system categories and user-created custom categories.

## Location
`lib/screens/categories_screen.dart`

## Functionality

### Screen Features
1. **Category List**: Displays all categories (default and custom)
2. **Add Category**: Floating action button to create new categories
3. **Edit Category**: Tap edit icon to modify custom categories
4. **Delete Category**: Tap delete icon to remove custom categories
5. **Pull-to-Refresh**: Refresh category list

### Category Display
Each category card shows:
- **Icon**: Emoji or icon identifier in colored circle avatar
- **Name**: Category name
- **Type Indicator**: "Default Category" subtitle for system categories
- **Actions**: Edit and Delete buttons (only for custom categories)

### Category Management Rules
- **Default Categories**: Cannot be edited or deleted
  - Groceries
  - Online Food
  - Mandatory Bills
  - Credit Card Bills
  - Transportation
  - Entertainment
  - Healthcare
  - Other
- **Custom Categories**: Can be edited and deleted by user

## State Management

### Providers Used
- `CategoryProvider`: Manages category data and operations

### Data Loading
On screen initialization:
1. Loads categories via `CategoryProvider.loadCategories()`
2. If no categories exist, initializes default categories
3. Displays loading indicator while fetching

## User Interactions

### Viewing Categories
- Categories are displayed in a scrollable list
- Default categories appear first (sorted by `isDefault`)
- Custom categories follow, sorted alphabetically

### Adding Category
1. User taps floating action button
2. Navigates to `AddEditCategoryScreen` (add mode)
3. On return, categories are refreshed

### Editing Category
1. User taps edit icon on custom category card
2. Navigates to `AddEditCategoryScreen` (edit mode) with category data
3. On return, categories are refreshed

### Deleting Category
1. User taps delete icon on custom category card
2. Confirmation dialog appears
3. On confirmation:
   - Category is deleted via `CategoryProvider`
   - Success message shown
   - List is refreshed

## Code Flow

### Initialization
```dart
@override
Widget build(BuildContext context) {
  return Consumer<CategoryProvider>(
    builder: (context, categoryProvider, _) {
      // Handle loading state
      if (categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      // Handle empty state
      if (categoryProvider.categories.isEmpty) {
        return Center(/* Empty state UI */);
      }
      // Display categories
      return RefreshIndicator(/* Category list */);
    },
  );
}
```

### Category Card Component
- `_CategoryCard`: Displays individual category
- Shows icon, name, and type
- Conditionally shows edit/delete buttons
- Handles delete confirmation dialog

### Delete Confirmation
```dart
void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Category'),
      content: Text('Are you sure...'),
      actions: [
        // Cancel and Delete buttons
      ],
    ),
  );
}
```

## UI Components

### Category List
- Uses `ListView.builder` for efficient rendering
- Card-based design with consistent spacing
- Color-coded avatars based on category color

### Empty State
- Large icon
- Helpful message
- Centered layout

### Floating Action Button
- Fixed position at bottom right
- Plus icon for adding categories

## Error Handling
- Loading states shown with `CircularProgressIndicator`
- Empty states show helpful messages
- Delete confirmation prevents accidental deletions
- Error states handled by provider

## Color Handling
- Category colors stored as hex strings (e.g., "#4CAF50")
- Converted to `Color` objects for display
- Used for avatar background and icon display

## Default Category Initialization
Default categories are created automatically when:
- User first opens the app
- No categories exist in database
- Categories are loaded for the first time

This happens in `CategoryService.initializeDefaultCategories()`.

## Future Enhancements
- Category usage statistics (how many expenses per category)
- Category icons from icon library (not just emojis)
- Category color themes/presets
- Category reordering (drag and drop)
- Category archiving (hide without deleting)
- Category groups/folders
- Import/export categories

