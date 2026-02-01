import 'package:flutter/material.dart';
import 'package:fitola/screens/onboarding/splash_screen.dart';
import 'package:fitola/screens/onboarding/language_selection_screen.dart';
import 'package:fitola/screens/onboarding/user_info_screen.dart';
import 'package:fitola/screens/onboarding/body_type_screen.dart';
import 'package:fitola/screens/onboarding/goals_screen.dart';
import 'package:fitola/screens/auth/login_screen.dart';
import 'package:fitola/screens/auth/register_screen.dart';
import 'package:fitola/screens/home/home_screen.dart';
import 'package:fitola/screens/home/dashboard_screen.dart';
import 'package:fitola/screens/home/profile_screen.dart';
import 'package:fitola/screens/chat/chat_list_screen.dart';
import 'package:fitola/screens/chat/chat_detail_screen.dart';
import 'package:fitola/screens/chat/voice_video_call_screen.dart';
import 'package:fitola/screens/map/fitbuddy_map_screen.dart';
import 'package:fitola/screens/map/location_share_screen.dart';
import 'package:fitola/screens/fitness/ai_trainer_screen.dart';
import 'package:fitola/screens/fitness/workout_plan_screen.dart';
import 'package:fitola/screens/fitness/nutrition_plan_screen.dart';
import 'package:fitola/screens/competition/leaderboard_screen.dart';
import 'package:fitola/screens/competition/ranking_screen.dart';

class AppRoutes {
  // Onboarding Routes
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String userInfo = '/user-info';
  static const String bodyType = '/body-type';
  static const String goals = '/goals';
  
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  
  // Home Routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  
  // Chat Routes
  static const String chatList = '/chat-list';
  static const String chatDetail = '/chat-detail';
  static const String voiceVideoCall = '/voice-video-call';
  
  // Map Routes
  static const String fitbuddyMap = '/fitbuddy-map';
  static const String locationShare = '/location-share';
  
  // Fitness Routes
  static const String aiTrainer = '/ai-trainer';
  static const String workoutPlan = '/workout-plan';
  static const String nutritionPlan = '/nutrition-plan';
  
  // Competition Routes
  static const String leaderboard = '/leaderboard';
  static const String ranking = '/ranking';
  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      languageSelection: (context) => const LanguageSelectionScreen(),
      userInfo: (context) => const UserInfoScreen(),
      bodyType: (context) => const BodyTypeScreen(),
      goals: (context) => const GoalsScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      dashboard: (context) => const DashboardScreen(),
      profile: (context) => const ProfileScreen(),
      chatList: (context) => const ChatListScreen(),
      chatDetail: (context) => const ChatDetailScreen(),
      voiceVideoCall: (context) => const VoiceVideoCallScreen(),
      fitbuddyMap: (context) => const FitbuddyMapScreen(),
      locationShare: (context) => const LocationShareScreen(),
      aiTrainer: (context) => const AITrainerScreen(),
      workoutPlan: (context) => const WorkoutPlanScreen(),
      nutritionPlan: (context) => const NutritionPlanScreen(),
      leaderboard: (context) => const LeaderboardScreen(),
      ranking: (context) => const RankingScreen(),
    };
  }
}
