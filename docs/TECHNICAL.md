# Fitola - Technical Documentation

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Database Schema](#database-schema)
5. [API Documentation](#api-documentation)
6. [Development Setup](#development-setup)
7. [Deployment Instructions](#deployment-instructions)
8. [Testing Strategy](#testing-strategy)
9. [Performance Optimization](#performance-optimization)
10. [Security Considerations](#security-considerations)

## Architecture Overview

Fitola follows a modern client-server architecture with the following components:

```
┌─────────────────┐
│  Flutter App    │ ◄─── User Interface Layer
│  (Dart/Flutter) │
└────────┬────────┘
         │ HTTP/WebSocket
         ▼
┌─────────────────┐
│  FastAPI Backend│ ◄─── API Layer
│  (Python 3.10+) │
└────────┬────────┘
         │
         ├──► Supabase (PostgreSQL) ◄─── Data Layer
         ├──► Google Gemini AI      ◄─── AI Layer
         ├──► OpenStreetMap        ◄─── Map Layer
         └──► Redis (Caching)       ◄─── Cache Layer
```

### Design Patterns

#### Frontend (Flutter)
- **MVVM Pattern**: Separation of UI, business logic, and data
- **Provider Pattern**: State management across the app
- **Repository Pattern**: Abstraction over data sources
- **Singleton Pattern**: Service classes (AuthService, ChatService)

#### Backend (FastAPI)
- **RESTful API**: Resource-based endpoints
- **Dependency Injection**: FastAPI's built-in DI system
- **Async/Await**: Non-blocking I/O operations
- **Repository Pattern**: Database abstraction

## Technology Stack

### Mobile Application (Flutter)

#### Core Framework
- **Flutter**: 3.24.5 (stable)
- **Dart**: 3.0+
- **Target Platforms**: Android, iOS, Web

#### State Management
- **provider**: ^6.1.0 - Reactive state management

#### Backend Integration
- **supabase_flutter**: ^2.0.0 - Supabase client
- **http**: ^1.1.0 - HTTP requests
- **dio**: ^5.4.0 - Advanced HTTP client
- **socket_io_client**: ^2.0.3 - Real-time communication

#### Maps & Location
- **flutter_map**: ^6.0.0 - OpenStreetMap rendering
- **latlong2**: ^0.9.0 - Latitude/longitude utilities
- **geolocator**: ^10.1.0 - GPS location
- **permission_handler**: ^11.0.1 - Runtime permissions
- **location**: ^5.0.3 - Location services

#### File Handling
- **file_picker**: ^6.1.1 - File selection
- **image_picker**: ^1.0.5 - Camera/gallery access

#### Translation
- **translator**: ^1.0.0 - Google Translate integration

#### UI/UX
- **google_fonts**: ^6.1.0 - Typography
- **flutter_svg**: ^2.0.9 - SVG rendering
- **lottie**: ^2.7.0 - Animations
- **shimmer**: ^3.0.0 - Loading placeholders

#### Authentication
- **google_sign_in**: ^6.1.6 - Google OAuth
- **flutter_secure_storage**: ^9.0.0 - Secure token storage

#### Charts & Visualization
- **fl_chart**: ^0.65.0 - Data charts

#### Health Integration
- **health**: ^10.0.0 - Apple Health / Google Fit

#### Utilities
- **intl**: ^0.18.1 - Internationalization
- **shared_preferences**: ^2.2.2 - Local storage
- **uuid**: ^4.2.2 - UUID generation

### Backend (FastAPI)

#### Core Framework
- **FastAPI**: Latest - Web framework
- **Uvicorn**: Latest - ASGI server
- **Pydantic**: Latest - Data validation

#### Database
- **Supabase**: PostgreSQL-based backend
- **asyncpg**: Async PostgreSQL driver

#### AI/ML
- **google-genai**: Latest - Gemini AI integration

#### Utilities
- **python-dotenv**: Environment variables

### Infrastructure

#### Database
- **Supabase (PostgreSQL)**: Primary database
- **Redis**: Caching and leaderboards

#### Hosting
- **Vercel**: Backend hosting (serverless)
- **Supabase Cloud**: Database and storage

#### CI/CD
- **GitHub Actions**: Automated testing and deployment

#### Monitoring
- **Sentry**: Error tracking (future)
- **Google Analytics**: User analytics (future)

## Project Structure

### Flutter App Structure

```
mobile/
├── android/                  # Android-specific files
│   ├── app/
│   │   ├── build.gradle     # App-level Gradle config
│   │   └── src/main/
│   │       └── AndroidManifest.xml
│   └── build.gradle         # Project-level Gradle config
├── ios/                     # iOS-specific files
│   └── Runner/
│       └── Info.plist
├── lib/                     # Main Dart code
│   ├── config/              # App configuration
│   │   ├── constants.dart   # Constants and environment vars
│   │   ├── routes.dart      # Route definitions
│   │   └── theme.dart       # Theme configuration
│   ├── models/              # Data models
│   │   ├── user_model.dart
│   │   ├── chat_message.dart
│   │   ├── fitbuddy.dart
│   │   ├── fitness_plan.dart
│   │   └── nutrition_plan.dart
│   ├── services/            # Business logic layer
│   │   ├── api_client.dart
│   │   ├── auth_service.dart
│   │   ├── chat_service.dart
│   │   ├── location_service.dart
│   │   ├── translation_service.dart
│   │   └── ai_service.dart
│   ├── providers/           # State management
│   │   ├── auth_provider.dart
│   │   ├── chat_provider.dart
│   │   ├── status_provider.dart
│   │   └── map_provider.dart
│   ├── screens/             # UI screens
│   │   ├── onboarding/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── chat/
│   │   ├── map/
│   │   ├── fitness/
│   │   └── competition/
│   ├── widgets/             # Reusable widgets
│   │   ├── status_translate_fab.dart
│   │   ├── custom_markers.dart
│   │   ├── chat_bubble.dart
│   │   ├── fitness_card.dart
│   │   └── safety_reminder_dialog.dart
│   └── main.dart            # App entry point
├── test/                    # Unit and widget tests
├── pubspec.yaml            # Dependencies
└── README.md               # Project documentation
```

### Backend Structure

```
backend/
├── main.py                 # FastAPI app entry point
├── models/                 # Data models (future)
├── services/               # Business logic (future)
├── routes/                 # API routes (future)
└── utils/                  # Utility functions (future)
```

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255),
    age_group VARCHAR(50),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    gender VARCHAR(50),
    city VARCHAR(255),
    body_type VARCHAR(50),
    goals TEXT[],
    duration_months INTEGER,
    interested_in_competition BOOLEAN DEFAULT FALSE,
    allergies TEXT[],
    dietary_preferences TEXT[],
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Fitness Plans Table
```sql
CREATE TABLE fitness_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50),
    difficulty VARCHAR(50),
    duration_days INTEGER,
    workout_days JSONB,
    ai_generated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    start_date TIMESTAMP,
    current_day INTEGER DEFAULT 0
);
```

### Nutrition Plans Table
```sql
CREATE TABLE nutrition_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    daily_calories INTEGER,
    macros JSONB,
    meals JSONB,
    dietary_restrictions TEXT[],
    ai_generated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    duration_days INTEGER DEFAULT 7
);
```

### Chat Messages Table
```sql
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES users(id) ON DELETE CASCADE,
    conversation_id UUID,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'text',
    file_url TEXT,
    file_name VARCHAR(255),
    is_translated BOOLEAN DEFAULT FALSE,
    translated_message TEXT,
    timestamp TIMESTAMP DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE
);
```

### User Locations Table
```sql
CREATE TABLE user_locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    status VARCHAR(50) DEFAULT 'available',
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Leaderboard Table
```sql
CREATE TABLE leaderboard (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    score INTEGER DEFAULT 0,
    rank INTEGER,
    country VARCHAR(255),
    streak_days INTEGER DEFAULT 0,
    last_activity TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Indexes
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_chat_messages_conversation ON chat_messages(conversation_id);
CREATE INDEX idx_chat_messages_timestamp ON chat_messages(timestamp DESC);
CREATE INDEX idx_user_locations_user_id ON user_locations(user_id);
CREATE INDEX idx_leaderboard_score ON leaderboard(score DESC);
CREATE INDEX idx_leaderboard_country ON leaderboard(country);
```

## API Documentation

### Base URL
- **Production**: `https://fitola.vercel.app/api/v1`
- **Development**: `http://localhost:8000/api/v1`

### Authentication

All authenticated endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <token>
```

### Endpoints

#### Authentication

##### POST /auth/register
Register a new user.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "name": "John Doe"
}
```

**Response:**
```json
{
  "user": { ... },
  "token": "jwt_token_here"
}
```

##### POST /auth/login
Login with email and password.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "user": { ... },
  "token": "jwt_token_here"
}
```

#### User Profile

##### GET /user/profile/:id
Get user profile by ID.

**Response:**
```json
{
  "id": "uuid",
  "name": "John Doe",
  "email": "user@example.com",
  // ... other user fields
}
```

##### PUT /user/profile
Update user profile.

**Request Body:**
```json
{
  "name": "John Doe",
  "weight": 75.5,
  "height": 180,
  // ... other updatable fields
}
```

##### POST /user/bmi
Calculate BMI.

**Request Body:**
```json
{
  "weight": 75.5,
  "height": 180
}
```

**Response:**
```json
{
  "bmi": 23.3,
  "category": "Normal",
  "healthy_range": {
    "min": 18.5,
    "max": 24.9
  }
}
```

#### Chat

##### POST /chat/message
Send a chat message.

**Request Body:**
```json
{
  "sender_id": "uuid",
  "receiver_id": "uuid",
  "message": "Hello!",
  "type": "text"
}
```

##### GET /chat/conversation/:userId/:otherUserId
Get conversation between two users.

**Query Parameters:**
- `limit` (optional): Number of messages to return (default: 50)
- `offset` (optional): Pagination offset

**Response:**
```json
{
  "messages": [
    {
      "id": "uuid",
      "sender_id": "uuid",
      "receiver_id": "uuid",
      "message": "Hello!",
      "timestamp": "2026-02-01T12:00:00Z",
      "is_read": false
    }
  ]
}
```

##### POST /chat/translate
Translate a message.

**Request Body:**
```json
{
  "message": "Hello!",
  "target_language": "es"
}
```

**Response:**
```json
{
  "original_message": "Hello!",
  "translated_message": "¡Hola!",
  "target_language": "es"
}
```

#### AI Plans

##### POST /plans/ai/fitness
Generate AI fitness plan.

**Request Body:**
```json
{
  "user_id": "uuid",
  "age_group": "Adult",
  "weight": 75.5,
  "height": 180,
  "body_type": "Mesomorph",
  "goals": ["Weight Loss", "Muscle Gain"],
  "duration_days": 30
}
```

**Response:**
```json
{
  "id": "uuid",
  "title": "30-Day Muscle Building Plan",
  "description": "...",
  "workout_days": [ ... ],
  // ... other plan fields
}
```

##### POST /plans/ai/nutrition
Generate AI nutrition plan.

**Request Body:**
```json
{
  "user_id": "uuid",
  "age_group": "Adult",
  "weight": 75.5,
  "height": 180,
  "body_type": "Mesomorph",
  "goals": ["Weight Loss"],
  "city": "New York",
  "allergies": ["Peanuts"],
  "duration_days": 7
}
```

#### Map & Location

##### GET /map/nearby
Get nearby FitBuddies.

**Query Parameters:**
- `latitude`: Current latitude
- `longitude`: Current longitude
- `radius`: Search radius in kilometers (5, 10, 25, 50)
- `status` (optional): Filter by status (available, busy)

**Response:**
```json
{
  "users": [
    {
      "id": "uuid",
      "name": "Jane Doe",
      "gender": "Female",
      "latitude": 40.7128,
      "longitude": -74.0060,
      "distance": 2.5,
      "status": "available"
    }
  ]
}
```

##### POST /location/update
Update user location.

**Request Body:**
```json
{
  "user_id": "uuid",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "status": "available"
}
```

##### POST /location/share
Share live location with another user.

**Request Body:**
```json
{
  "user_id": "uuid",
  "target_user_id": "uuid",
  "duration_seconds": 3600
}
```

#### Leaderboard

##### GET /leaderboard/global
Get global leaderboard.

**Query Parameters:**
- `limit` (optional): Number of results (default: 100)
- `offset` (optional): Pagination offset

**Response:**
```json
{
  "leaderboard": [
    {
      "rank": 1,
      "user_id": "uuid",
      "name": "John Doe",
      "score": 1500,
      "streak_days": 30
    }
  ]
}
```

## Development Setup

### Prerequisites
- **Flutter**: 3.24.5 or later
- **Dart**: 3.0 or later
- **Python**: 3.10 or later
- **Node.js**: 18 or later (for Vercel CLI)
- **Git**: Latest version

### Frontend Setup

1. **Clone the repository:**
```bash
git clone https://github.com/saanjaypatil78/fitola.git
cd fitola/mobile
```

2. **Install Flutter dependencies:**
```bash
flutter pub get
```

3. **Set up environment variables:**
Create a `.env` file in the mobile directory:
```env
API_BASE_URL=http://localhost:8000/api/v1
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. **Run the app:**
```bash
flutter run
```

### Backend Setup

1. **Navigate to backend directory:**
```bash
cd backend
```

2. **Create virtual environment:**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\\Scripts\\activate
```

3. **Install dependencies:**
```bash
pip install -r requirements.txt
```

4. **Set up environment variables:**
Create a `.env` file:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
GEMINI_API_KEY=your_gemini_api_key
FASTAPI_ENV=development
```

5. **Run the development server:**
```bash
uvicorn main:app --reload
```

The API will be available at `http://localhost:8000`.

### Database Setup

1. **Create a Supabase project:**
- Visit https://supabase.com
- Create a new project
- Copy the URL and anon key

2. **Run migrations:**
Execute the SQL schema from the Database Schema section in the Supabase SQL editor.

3. **Enable Row Level Security (RLS):**
```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE fitness_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE nutrition_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaderboard ENABLE ROW LEVEL SECURITY;
```

4. **Create RLS policies:**
```sql
-- Users can read their own data
CREATE POLICY "Users can read own data" ON users
    FOR SELECT USING (auth.uid() = id);

-- Users can update their own data
CREATE POLICY "Users can update own data" ON users
    FOR UPDATE USING (auth.uid() = id);
```

## Deployment Instructions

### Backend Deployment (Vercel)

1. **Install Vercel CLI:**
```bash
npm install -g vercel
```

2. **Login to Vercel:**
```bash
vercel login
```

3. **Deploy:**
```bash
cd backend
vercel
```

4. **Set environment variables in Vercel:**
Go to Vercel dashboard → Project Settings → Environment Variables

### Mobile App Deployment

#### Android

1. **Build APK:**
```bash
cd mobile
flutter build apk --release
```

2. **Build App Bundle (for Play Store):**
```bash
cd mobile
flutter build appbundle --release
```

3. **Upload to Google Play Console:**
Follow the Google Play Console submission process.

#### iOS

1. **Build iOS app:**
```bash
cd mobile
flutter build ios --release
```

2. **Open in Xcode:**
```bash
open ios/Runner.xcworkspace
```

3. **Archive and upload to App Store Connect**

### CI/CD Setup

Create `.github/workflows/flutter_build.yml`:
```yaml
name: Flutter Build & Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.5'

    - name: Install dependencies
      run: flutter pub get
      working-directory: mobile

    - name: Run tests
      run: flutter test
      working-directory: mobile

    - name: Build APK
      run: flutter build apk --release
      working-directory: mobile
```

### GitHub Packages (NuGet) Publishing (Open Source)

If you publish any .NET tooling or supporting libraries, GitHub Packages supports free publishing for public NuGet packages. Use GitHub Actions for CI publishing and `GITHUB_TOKEN` for authentication.

**Best practices:**
- Publish **public** packages to stay within free limits.
- Use `GITHUB_TOKEN` in CI for publishing.
- Use a PAT only for local/manual publishing.
- Set `RepositoryUrl` in your `.csproj` so packages link back to the repo.

**NuGet source setup (CI or local):**
```bash
dotnet nuget add source \
  --username USERNAME \
  --password ${{ secrets.GITHUB_TOKEN }} \
  --store-password-in-clear-text \
  --name github \
  "https://nuget.pkg.github.com/NAMESPACE/index.json"
```

**Minimal GitHub Actions publish step:**
```yaml
- name: Publish NuGet package
  run: dotnet nuget push "./nupkg/*.nupkg" \
    --api-key ${{ secrets.GITHUB_TOKEN }} \
    --source "https://nuget.pkg.github.com/NAMESPACE/index.json"
```

## Testing Strategy

### Unit Tests
Test individual functions and classes in isolation.

**Example:**
```dart
// test/models/user_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fitola/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should calculate BMI correctly', () {
      final user = UserModel(
        id: '1',
        name: 'Test User',
        email: 'test@example.com',
        weight: 70.0,
        height: 170.0,
      );

      expect(user.bmi, closeTo(24.2, 0.1));
    });

    test('should return correct BMI category', () {
      final user = UserModel(
        id: '1',
        name: 'Test User',
        email: 'test@example.com',
        weight: 70.0,
        height: 170.0,
      );

      expect(user.bmiCategory, 'Normal');
    });
  });
}
```

### Widget Tests
Test individual widgets and their interactions.

**Example:**
```dart
// test/widgets/chat_bubble_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitola/widgets/chat_bubble.dart';

void main() {
  testWidgets('ChatBubble displays message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatBubble(
            message: 'Test message',
            isSent: true,
            timestamp: DateTime.now(),
          ),
        ),
      ),
    );

    expect(find.text('Test message'), findsOneWidget);
  });
}
```

### Integration Tests
Test complete user flows.

**Example:**
```dart
// integration_test/onboarding_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fitola/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete onboarding flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Splash screen
    expect(find.text('Fitola'), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 3));

    // Language selection
    expect(find.text('Select Language'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // ... test other screens
  });
}
```

### Running Tests
```bash
# Unit and widget tests
flutter test

# Integration tests
flutter test integration_test

# With coverage
flutter test --coverage
```

## Performance Optimization

### Flutter App

1. **Code Splitting**: Use deferred loading for large features
2. **Image Optimization**: Use cached_network_image for remote images
3. **List Performance**: Use ListView.builder for long lists
4. **State Management**: Use Provider selectively to minimize rebuilds
5. **Build Methods**: Keep build methods pure and fast

### Backend

1. **Database Indexing**: Index frequently queried columns
2. **Query Optimization**: Use eager loading to prevent N+1 queries
3. **Caching**: Use Redis for leaderboards and frequent queries
4. **Async Operations**: Use async/await for I/O operations
5. **Rate Limiting**: Implement rate limiting for API endpoints

### Network

1. **API Response Size**: Paginate large responses
2. **Compression**: Enable gzip compression
3. **CDN**: Use CDN for static assets
4. **WebSocket**: Use for real-time features (chat)

## Security Considerations

### Authentication
- **Password Hashing**: Use bcrypt with high cost factor
- **JWT Tokens**: Short expiration (1 hour), refresh tokens
- **OAuth**: Use industry-standard OAuth 2.0
- **Session Management**: Revoke tokens on logout

### Data Protection
- **HTTPS Only**: All traffic over TLS 1.3
- **Input Validation**: Validate all user inputs
- **SQL Injection**: Use parameterized queries
- **XSS Prevention**: Sanitize user-generated content
- **CSRF Protection**: Use CSRF tokens for state-changing operations

### Location Privacy
- **Consent**: Explicit user consent for location sharing
- **Precision Control**: Adjustable location accuracy
- **Time Limits**: Automatic expiration of location shares
- **Ghost Mode**: Complete location hiding

### Mobile App Security
- **Secure Storage**: Use flutter_secure_storage for tokens
- **Certificate Pinning**: Pin SSL certificates
- **Jailbreak/Root Detection**: Warn users on compromised devices
- **Code Obfuscation**: Obfuscate release builds

---

**Document Version**: 1.0  
**Last Updated**: 2026-02-02 14:48:31  
**Maintainer**: Fitola Development Team