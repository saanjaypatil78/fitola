# Backend Integration Guide

This document describes the backend integration implemented in the Fitola mobile app.

## Overview

The Fitola mobile app now has full integration with the FastAPI backend, including:
- Enhanced API client with retry logic and error handling
- Complete service layer for all backend endpoints
- Proper state management in providers
- Environment configuration support

## API Client Enhancements

### Features
- **Automatic Retry Logic**: Up to 3 retries with exponential backoff (2s, 4s, 8s)
- **Timeout Handling**: 30-second timeout for all requests
- **Comprehensive Error Types**: 
  - Network errors (connectivity issues)
  - Timeout errors
  - Authentication errors (401, 403)
  - Not Found errors (404)
  - Server errors (5xx)
- **Bearer Token Authentication**: Automatic token injection in headers

### Usage
```dart
final apiClient = ApiClient();
apiClient.setAuthToken('your-token-here');

try {
  final data = await apiClient.get('/user/profile/123');
  // Handle success
} on ApiException catch (e) {
  if (e.isNetworkError) {
    // Handle network/timeout errors
  } else if (e.isAuthError) {
    // Handle authentication errors
  } else if (e.isServerError) {
    // Handle server errors
  }
}
```

## Services

### 1. AuthService
Handles user authentication using Supabase and backend API.

**Features:**
- Email/password authentication
- Google OAuth
- Token management with secure storage
- Auto-login on app restart

**Endpoints:**
- POST `/api/v1/auth/register` - Register new user
- POST `/api/v1/auth/login` - User login
- GET `/api/v1/user/profile/{user_id}` - Fetch user profile
- PUT `/api/v1/user/profile` - Update user profile

### 2. ChatService
REST-based messaging service (Socket.IO removed as backend doesn't support it).

**Features:**
- Send and receive messages
- Get conversation history
- Message translation
- File uploads
- Chat requests

**Endpoints:**
- POST `/api/v1/chat/message` - Send message
- GET `/api/v1/chat/conversation/{user_id}/{other_user_id}` - Get conversation
- GET `/api/v1/chat/conversations/{user_id}` - List all conversations
- POST `/api/v1/chat/translate` - Translate message
- POST `/api/v1/chat/request` - Send chat request
- PUT `/api/v1/chat/request/{request_id}/accept` - Accept request

**Note:** Real-time messaging replaced with polling (5-second interval) in ChatProvider.

### 3. LocationService
GPS and location sharing service.

**Features:**
- Get current position
- Update user location
- Share location with specific users
- Stop location sharing

**Endpoints:**
- POST `/api/v1/location/update` - Update location
- POST `/api/v1/location/share` - Start sharing
- DELETE `/api/v1/location/share/{user_id}/{target_user_id}` - Stop sharing

### 4. AIService
AI-powered fitness and nutrition planning.

**Features:**
- Chat with AI for fitness advice
- Generate personalized fitness plans
- Generate nutrition plans
- BMI calculation

**Endpoints:**
- POST `/api/v1/chat` - Chat with AI
- POST `/api/v1/plans/ai/fitness` - Generate fitness plan
- POST `/api/v1/plans/ai/nutrition` - Generate nutrition plan
- POST `/api/v1/user/bmi` - Calculate BMI

### 5. LeaderboardService (NEW)
Competition and ranking features.

**Features:**
- Global leaderboard
- National leaderboard by country
- Friends leaderboard
- Pagination support

**Endpoints:**
- GET `/api/v1/leaderboard/global` - Global rankings
- GET `/api/v1/leaderboard/national/{country}` - Country rankings
- GET `/api/v1/leaderboard/friends/{user_id}` - Friends rankings

## Providers

### 1. AuthProvider
State management for authentication.

**Features:**
- Loading states during auth operations
- Error handling with user-friendly messages
- Auto-login support
- Profile updates

### 2. ChatProvider
State management for messaging.

**Features:**
- Conversation management
- Automatic polling for new messages (5s interval)
- Translation toggle
- Loading and error states

**Important:** Replaced Socket.IO with REST polling since backend doesn't support WebSockets.

### 3. MapProvider
State management for FitBuddy discovery.

**Features:**
- Nearby FitBuddy discovery
- Radius filtering (5, 10, 25, 50 km)
- Live location tracking
- Auto-retry on network errors

### 4. StatusProvider
User availability status management.

**Features:**
- Available/Busy/Ghost mode
- Call preferences

## Environment Configuration

### Mobile App Configuration

The Flutter app uses compile-time environment variables via `String.fromEnvironment` and `--dart-define` flags. Configuration values are defined in `mobile/lib/config/constants.dart` with default values.

#### Setting Environment Variables

**During Development:**
```bash
# Run with custom API endpoint
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api/v1

# Run with all custom values
flutter run \
  --dart-define=API_BASE_URL=https://fitola.vercel.app/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key-here
```

**For Production Builds:**
```bash
# Android
flutter build apk \
  --dart-define=API_BASE_URL=https://fitola.vercel.app/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key-here

# iOS
flutter build ios \
  --dart-define=API_BASE_URL=https://fitola.vercel.app/api/v1 \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key-here
```

**Using --dart-define-from-file (Flutter 3.7+):**

Create a `mobile/dart_defines.json` file:
```json
{
  "API_BASE_URL": "https://fitola.vercel.app/api/v1",
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key-here"
}
```

Then run:
```bash
flutter run --dart-define-from-file=dart_defines.json
flutter build apk --dart-define-from-file=dart_defines.json
```

**Note:** Add `dart_defines.json` to `.gitignore` to avoid committing sensitive credentials.

#### Available Configuration Variables

- `API_BASE_URL` - Backend API base URL (default: `https://fitola.vercel.app/api/v1`)
- `SUPABASE_URL` - Supabase project URL (default: `https://your-project.supabase.co`)
- `SUPABASE_ANON_KEY` - Supabase anonymous key (default: `your-anon-key-here`)

#### Hard-coded Configuration

Some configuration values are hard-coded in `ApiClient`:
- `timeout` - 30 seconds (line 17)
- `maxRetries` - 3 attempts (line 16)

To make these configurable, modify `mobile/lib/services/api_client.dart` to use `int.fromEnvironment`.

### Backend (.env)
See `/backend/.env.example` for backend configuration.

## Error Handling Strategy

### API Client Level
- Automatic retry for network/timeout errors (up to 3 times)
- Exponential backoff between retries
- Typed exceptions for better error handling

### Service Level
- Catch and wrap API exceptions
- Provide context-specific error messages
- Throw custom service exceptions

### Provider Level
- Set loading states during operations
- Store error messages in state
- Notify listeners on state changes
- Auto-retry for specific error types (network errors)

## Testing

### Manual Testing Checklist
1. **Authentication Flow**
   - [ ] Email/password login
   - [ ] Email/password signup
   - [ ] Google OAuth
   - [ ] Auto-login
   - [ ] Logout

2. **User Profile**
   - [ ] Fetch profile
   - [ ] Update profile
   - [ ] BMI calculation

3. **Chat & Messaging**
   - [ ] Send message
   - [ ] Receive message (polling)
   - [ ] View conversation history
   - [ ] Translate message
   - [ ] Send chat request
   - [ ] Accept chat request

4. **FitBuddy Discovery**
   - [ ] Find nearby users
   - [ ] Filter by radius
   - [ ] Share location
   - [ ] Stop sharing

5. **AI Features**
   - [ ] Chat with AI
   - [ ] Generate fitness plan
   - [ ] Generate nutrition plan

6. **Leaderboard**
   - [ ] View global leaderboard
   - [ ] View national leaderboard
   - [ ] View friends leaderboard

## Known Limitations

1. **No Socket.IO Support**: Backend doesn't have WebSocket/Socket.IO implemented. Chat uses REST polling instead (5-second interval).

2. **Polling Overhead**: Message polling every 5 seconds may increase battery usage and data consumption.

3. **Limited Real-time Features**: Location sharing updates rely on periodic updates rather than true real-time streaming.

## Future Improvements

1. **WebSocket Support**: Add Socket.IO or WebSocket support in backend for true real-time messaging.

2. **Push Notifications**: Implement FCM for instant message notifications.

3. **Optimistic Updates**: Add optimistic UI updates for better user experience.

4. **Offline Support**: Implement local caching and sync when connection is restored.

5. **Request Queuing**: Queue failed requests and retry when connection is restored.

## API Endpoints Summary

### Base URL
```
https://fitola.vercel.app/api/v1
```

### Authentication
- POST `/auth/register` - Register user
- POST `/auth/login` - Login user

### User Profile
- GET `/user/profile/{user_id}` - Get profile
- PUT `/user/profile` - Update profile
- POST `/user/bmi` - Calculate BMI

### Chat & Messaging
- POST `/chat/message` - Send message
- GET `/chat/conversation/{user_id}/{other_user_id}` - Get conversation
- GET `/chat/conversations/{user_id}` - List conversations
- POST `/chat/translate` - Translate message
- POST `/chat/request` - Send chat request
- PUT `/chat/request/{request_id}/accept` - Accept request

### Location & Map
- GET `/map/nearby` - Find nearby FitBuddies
- POST `/location/update` - Update location
- POST `/location/share` - Share location
- DELETE `/location/share/{user_id}/{target_user_id}` - Stop sharing

### AI Features
- POST `/chat` - Chat with AI
- POST `/plans/ai/fitness` - Generate fitness plan
- POST `/plans/ai/nutrition` - Generate nutrition plan

### Leaderboard
- GET `/leaderboard/global` - Global leaderboard
- GET `/leaderboard/national/{country}` - National leaderboard
- GET `/leaderboard/friends/{user_id}` - Friends leaderboard

## Troubleshooting

### Connection Errors
- Check API_BASE_URL in constants
- Verify backend is running
- Check network connectivity
- Review API client timeout settings

### Authentication Errors
- Verify Supabase credentials
- Check token storage
- Ensure backend /auth endpoints are accessible

### Polling Issues
- Verify ChatProvider.initialize() is called
- Check polling interval (default 5s)
- Monitor network usage

### Location Errors
- Verify location permissions
- Check GPS availability
- Ensure location services are enabled
