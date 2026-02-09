# Fitola - AI-Powered Personal Fitness & Social Wellness

[![CI - Lint & Test](https://github.com/saanjaypatil78/fitola/actions/workflows/ci.yml/badge.svg)](https://github.com/saanjaypatil78/fitola/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![Flutter 3.24+](https://img.shields.io/badge/Flutter-3.24+-02569B.svg?logo=flutter)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=flat&logo=fastapi)](https://fastapi.tiangolo.com)

Fitola is a revolutionary AI-powered fitness and social wellness platform that combines personalized health coaching with community engagement. Connect with "FitBuddies," get AI-generated workout and nutrition plans, and achieve your fitness goals together!

## ✨ Unique Features

### 🤖 AI-Powered Personalization
- **Gemini 2.0 Flash Integration**: Personalized workout and nutrition plans
- **BMI Analysis**: WHO classification with health insights
- **Body Photo Analysis**: AI estimates body fat percentage (with consent)
- **Age-Appropriate Plans**: Customized for Baby/Teenager/Adult/Elder

### 🌍 Social Fitness Network
- **FitBuddy Map**: Find workout partners nearby (5km - 50km radius)
- **Ghost Mode**: Complete privacy - hide from map while still sharing via DM
- **Status System**: Available, Busy, or Ghost status
- **Real-time Chat**: Messaging with inline translation (30+ languages)
- **Live Location Sharing**: WhatsApp-style live location with time limits

### 🔒 Privacy-First Design
- **Granular Controls**: Choose exactly what to share
- **Location Accuracy**: Adjustable precision (±50m)
- **Time Limits**: Auto-expire location sharing
- **Safety Reminders**: Dialogs when enabling location
- **Block & Report**: Instant privacy protection

### 🏆 Gamification & Competition
- **Global Leaderboard**: Compete worldwide
- **National Rankings**: Country-specific leaderboards
- **Streak Tracking**: Consistency rewards
- **Achievement Badges**: Milestone celebrations

### 🎨 Multi-Language Support
- **30+ Languages**: Break language barriers
- **Inline Translation**: Chat in any language
- **Voice Activation**: "Ghost" command for instant privacy

## 🏗️ Architecture

```
┌─────────────────┐
│  Flutter App    │ ◄─── Mobile (Android/iOS/Web)
│  (Dart/Flutter) │
└────────┬────────┘
         │ HTTP/WebSocket
         ▼
┌─────────────────┐
│  FastAPI Backend│ ◄─── Python 3.10+
│  (REST + WS)    │
└────────┬────────┘
         │
         ├──► Supabase (PostgreSQL + Auth)
         ├──► Google Gemini AI (Plans & Chat)
         ├──► OpenStreetMap (Map Tiles)
         └──► Redis (Caching & Leaderboards)
```

## 🛠️ Tech Stack

- **Backend**: Python 3.10, FastAPI, Pydantic, Uvicorn
- **AI**: Google Generative AI (Gemini 2.5)
### Mobile App (Flutter)
- **Framework**: Flutter 3.24.5
- **Language**: Dart 3.0+
- **State Management**: Provider
- **UI**: Material Design 3, Google Fonts
- **Maps**: flutter_map (OpenStreetMap)
- **Location**: Geolocator, Permission Handler
- **Auth**: Supabase Auth + Google Sign-In
- **Real-time**: Socket.IO Client
- **Charts**: FL Chart
- **Animations**: Lottie, Shimmer

### Backend (FastAPI)
- **Framework**: FastAPI (Python 3.10+)
- **AI**: Google Generative AI (Gemini 2.0)
- **Database**: Supabase (PostgreSQL)
- **Caching**: Redis (Upstash)
- **Deployment**: Vercel (Serverless)

### Infrastructure
- **Auth**: Supabase Auth (Email, Google OAuth)
- **Storage**: Supabase Storage (Images, Files)
- **Real-time**: WebSocket (Chat, Live Location)
- **CI/CD**: GitHub Actions

## 📥 Installation

### Prerequisites
- **Flutter**: 3.24.5 or later
- **Python**: 3.10 or later
- **Git**: Latest version
- **Supabase Account**: For database and auth
- **Gemini API Key**: From Google AI Studio

### Backend Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/saanjaypatil78/fitola.git
   cd fitola/backend
   ```

2. **Create virtual environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # Windows: venv\Scripts\activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables**:
   ```bash
   cp .env.example .env
   # Add your GEMINI_API_KEY (and optional GEMINI_MODEL), SUPABASE keys, RUBE_MCP_JWT, RUBE_MCP_BASE_URL, and CLICKHOUSE_* settings to .env
   # Edit .env and add:
   # GEMINI_API_KEY=your_gemini_api_key
   # SUPABASE_URL=your_supabase_url
   # SUPABASE_KEY=your_supabase_key
   ```

5. **Run development server**:
   ```bash
   uvicorn main:app --reload
   ```

   API will be available at `http://localhost:8000`

### Mobile App Setup

1. **Navigate to mobile directory**:
   ```bash
   cd mobile
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up environment** (create `.env` file):
   ```env
   API_BASE_URL=http://localhost:8000/api/v1
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Run the app**:
   ```bash
   # For Android
   flutter run

   # For iOS
   flutter run -d ios

   # For Web
   flutter run -d chrome
   ```

### Database Setup

1. Create a Supabase project at https://supabase.com
2. Run the SQL migrations from `docs/TECHNICAL.md`
3. Enable Row Level Security (RLS) policies
4. Copy your project URL and anon key to `.env`

## 📱 App Screenshots

*Screenshots coming soon - app is ready to build!*

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest
```

### Flutter Tests
```bash
cd mobile
# Unit tests
flutter test

# Widget tests
flutter test test/widgets

# Integration tests
flutter test integration_test
```

## 📚 Documentation

- **[Product Requirements Document (PRD)](docs/PRD.md)**: Complete product specifications
- **[Technical Documentation](docs/TECHNICAL.md)**: Architecture, API docs, deployment
- **[Stitch MCP Setup](docs/STITCH_MCP_SETUP.md)**: Integrate Stitch MCP server for UI generation
- **[Backend Integration Guide](BACKEND_INTEGRATION.md)**: API integration, error handling, services documentation
- **[UX Wireframes](docs/UX_WIREFRAMES.md)**: Design specifications and screen flows
- **[API Documentation](http://localhost:8000/docs)**: Interactive Swagger UI (when backend is running)

## 🚀 Deployment

### Backend (Vercel)
```bash
cd backend
vercel --prod
```

### Mobile App
```bash
cd mobile

# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🎯 Roadmap

### Phase 1 (Current) - MVP ✅
- ✅ Complete Flutter app structure
- ✅ Onboarding flow
- ✅ Authentication (Email + Google)
- ✅ Chat system with translation
- ✅ FitBuddy map with Ghost Mode
- ✅ AI fitness & nutrition plans
- ✅ Competition leaderboard
- ✅ Status/Translate FAB
- ✅ Backend Integration with retry logic and error handling
- ✅ REST-based messaging with polling
- ✅ Comprehensive API client with timeout handling

### Phase 2 (Next 3 months)
- Live video consultations
- Advanced analytics dashboard
- Wearable device integration (Apple Watch, Fitbit)
- Recipe database expansion
- Social feed & post sharing
- 30-day challenge system

### Phase 3 (6 months)
- Premium subscription model
- In-app purchases
- Gym & trainer partnerships
- White-label solution
- International expansion (50+ languages)

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines first.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 👥 Team

- **Sanjay Santosh Patil** - *Creator & Lead Developer* - [@saanjaypatil78](https://github.com/saanjaypatil78)

## 🙏 Acknowledgments

- Google Gemini AI for powering our AI features
- Supabase for backend infrastructure
- OpenStreetMap contributors
- Flutter team for the amazing framework
- All open-source contributors

## 📞 Contact

- **Email**: your.email@example.com
- **Twitter**: [@fitolaapp](https://twitter.com/fitolaapp)
- **Website**: https://fitola.vercel.app

---
Developed with ❤️ by [Sanjay Santosh Patil](https://github.com/saanjaypatil78)

**Made with ❤️ for the fitness community**

*"Your AI Fitness Companion"*
