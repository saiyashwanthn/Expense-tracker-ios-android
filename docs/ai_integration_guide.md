# AI Assistant Integration Guide

## Overview
This document outlines the architecture and integration points for adding an AI chatbot/assistant feature to the Expense Tracker app. The current codebase is designed with this feature in mind, making integration straightforward.

## Current Architecture Support

### Placeholder Locations
1. **Home Screen Drawer**: Disabled menu item "AI Assistant" with "Coming Soon" subtitle
2. **Settings Screen**: "AI Assistant" card with "Coming Soon" badge
3. **App Structure**: Modular design allows easy addition of AI components

### Reserved Components (To Be Created)

#### 1. AI Service (`lib/services/ai_service.dart`)
```dart
class AIService {
  // API calls to AI backend (OpenAI, Anthropic, etc.)
  Future<String> getResponse(String userMessage, String userId);
  Future<List<ExpenseInsight>> getExpenseInsights(String userId);
  Future<BudgetRecommendation> getBudgetRecommendation(String userId);
}
```

#### 2. AI Provider (`lib/providers/ai_provider.dart`)
```dart
class AIProvider with ChangeNotifier {
  List<ChatMessage> messages = [];
  bool isLoading = false;
  
  Future<void> sendMessage(String text);
  Future<void> getExpenseInsights();
  Future<void> getBudgetAdvice();
}
```

#### 3. AI Chat Screen (`lib/screens/ai_chat_screen.dart`)
- Chat interface similar to Duolingo's AI tutor
- Message bubbles (user and AI)
- Quick action buttons
- Context-aware suggestions

#### 4. AI Models (`lib/models/`)
- `chat_message.dart`: Message model
- `expense_insight.dart`: AI-generated insights
- `budget_recommendation.dart`: Budget suggestions

## Integration Points

### 1. Home Screen Integration
**Location**: `lib/screens/home_screen.dart`

**Current State**:
```dart
ListTile(
  leading: const Icon(Icons.smart_toy_outlined),
  title: const Text('AI Assistant'),
  subtitle: const Text('Coming Soon', style: TextStyle(fontSize: 12)),
  enabled: false,
  onTap: null,
),
```

**Future Implementation**:
```dart
ListTile(
  leading: const Icon(Icons.smart_toy_outlined),
  title: const Text('AI Assistant'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AIChatScreen()),
    );
  },
),
```

### 2. Floating Action Button Option
Add AI assistant as an alternative FAB or integrate into existing FAB menu:
```dart
FloatingActionButton(
  onPressed: () => _showActionMenu(context),
  child: const Icon(Icons.add),
)
```

### 3. Quick Access from Analytics
Add "Ask AI" button in Analytics screen for context-aware insights.

## AI Features to Implement

### 1. Conversational Expense Entry
- **Example**: "I spent $25 on groceries today"
- **AI Action**: Parse intent, extract amount and category, create expense
- **Benefit**: Faster expense entry, natural language processing

### 2. Expense Insights
- **Example**: "What am I spending most on?"
- **AI Action**: Analyze expenses, provide category breakdown
- **Benefit**: Quick insights without navigating analytics

### 3. Budget Recommendations
- **Example**: "Should I reduce my food spending?"
- **AI Action**: Analyze spending patterns, compare to averages, suggest budget
- **Benefit**: Personalized financial advice

### 4. Spending Pattern Analysis
- **Example**: "Why did I spend more this month?"
- **AI Action**: Compare months, identify trends, explain differences
- **Benefit**: Understanding spending behavior

### 5. Financial Tips
- **Example**: "How can I save money?"
- **AI Action**: Provide personalized tips based on spending history
- **Benefit**: Actionable financial advice

### 6. Expense Categorization Help
- **Example**: "What category should I use for Netflix?"
- **AI Action**: Suggest appropriate category
- **Benefit**: Consistent categorization

## Technical Implementation

### Backend Options

#### Option 1: OpenAI GPT-4
```dart
// Example API call structure
Future<String> getAIResponse(String prompt, String userId) async {
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': 'gpt-4',
      'messages': [
        {'role': 'system', 'content': 'You are a financial advisor...'},
        {'role': 'user', 'content': prompt},
      ],
      'user': userId, // For personalization
    }),
  );
  // Parse and return response
}
```

#### Option 2: Anthropic Claude
Similar structure, different API endpoint and format.

#### Option 3: Supabase Edge Functions
Create serverless functions in Supabase:
```sql
-- Edge function: ai-chat
-- Handles AI API calls server-side
-- Keeps API keys secure
```

### Data Flow

```
User Message
  ↓
AIChatScreen
  ↓
AIProvider.sendMessage()
  ↓
AIService.getResponse()
  ↓
AI API (OpenAI/Claude/etc.)
  ↓
Response Processing
  ↓
UI Update
```

### Context Building

The AI should have access to:
1. **User's Expense History**: Recent expenses, totals, trends
2. **Category Information**: Available categories, spending per category
3. **User Settings**: Currency, notification preferences
4. **Conversation History**: Previous messages in session

### Prompt Engineering

#### System Prompt Example
```
You are a friendly and helpful personal financial assistant for an expense tracking app. 
Your role is to:
- Help users understand their spending patterns
- Provide actionable financial advice
- Assist with expense categorization
- Answer questions about their financial data
- Be conversational and encouraging (like Duolingo's AI tutor)

User's current spending summary:
- Total this month: $X
- Top category: Y
- Recent expenses: [list]

Be concise, friendly, and helpful. Use emojis sparingly.
```

## UI/UX Design

### Chat Interface
- **Layout**: Full-screen chat with message bubbles
- **User Messages**: Right-aligned, blue background
- **AI Messages**: Left-aligned, gray background
- **Typing Indicator**: Show when AI is processing
- **Quick Actions**: Buttons for common queries

### Personality
- **Tone**: Friendly, encouraging, non-judgmental
- **Style**: Conversational, like Duolingo's AI tutor
- **Emojis**: Use sparingly for emphasis
- **Encouragement**: Celebrate milestones, provide positive reinforcement

### Example Interactions

**User**: "I spent $50 on groceries today"
**AI**: "Got it! I've added that to your Groceries category. You've spent $200 on groceries this month. That's 15% of your total expenses. Keep tracking! 📊"

**User**: "What should I spend less on?"
**AI**: "Based on your spending, Online Food is your biggest category at $300 this month. That's 30% of your expenses. Consider meal prepping to reduce this! Would you like some meal prep tips?"

## Security & Privacy

### Considerations
1. **API Keys**: Store securely, never in client code
2. **User Data**: Only send necessary data to AI API
3. **Data Retention**: Clear conversation history periodically
4. **PII**: Don't send sensitive personal information
5. **Rate Limiting**: Implement to prevent abuse

### Implementation
- Use Supabase Edge Functions for API calls
- Encrypt sensitive data before sending
- Implement user consent for AI features
- Allow users to disable AI features

## Testing Strategy

### Unit Tests
- Test AI service methods
- Test prompt building
- Test response parsing

### Integration Tests
- Test full conversation flow
- Test expense creation from AI
- Test error handling

### User Testing
- Gather feedback on AI personality
- Test conversation quality
- Measure user engagement

## Future Enhancements

### Phase 2 Features
1. **Voice Input**: Speak expenses instead of typing
2. **Proactive Suggestions**: AI suggests adding expenses based on patterns
3. **Smart Categorization**: AI automatically categorizes expenses
4. **Budget Alerts**: AI warns when approaching budget limits
5. **Goal Setting**: AI helps set and track financial goals

### Advanced Features
1. **Multi-language Support**: AI responds in user's language
2. **Expense Predictions**: Predict future expenses based on history
3. **Receipt Analysis**: AI reads receipts and creates expenses
4. **Integration**: Connect with banks for automatic expense import

## Migration Path

### Step 1: Basic Chat
1. Create AI service and provider
2. Create chat screen
3. Integrate with home screen
4. Test basic conversations

### Step 2: Expense Integration
1. Add expense creation from chat
2. Add expense querying
3. Test end-to-end flow

### Step 3: Advanced Features
1. Add insights and recommendations
2. Add proactive suggestions
3. Refine AI personality

## Resources

- OpenAI API Documentation: https://platform.openai.com/docs
- Anthropic Claude API: https://docs.anthropic.com
- Supabase Edge Functions: https://supabase.com/docs/guides/functions
- Duolingo AI Tutor (Inspiration): https://blog.duolingo.com/duolingo-max/

## Notes

- Keep AI responses concise (2-3 sentences max)
- Always provide actionable advice
- Use user's name for personalization
- Celebrate achievements and milestones
- Be encouraging, not preachy

