class AppConstants {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://fitola.vercel.app/api/v1',
  );
  
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key-here',
  );
  
  // Map Configuration
  static const List<int> radiusFilters = [5, 10, 25, 50]; // in kilometers
  static const double defaultMapZoom = 13.0;
  static const int ghostModeTimeLimit = 3600; // 1 hour in seconds
  
  // Chat Configuration
  static const int maxFileSize = 10485760; // 10 MB
  static const List<String> supportedFileTypes = [
    'jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'
  ];
  
  // Onboarding
  static const List<String> ageGroups = ['Baby', 'Teenager', 'Adult', 'Elder'];
  static const List<String> bodyTypes = ['Ectomorph', 'Mesomorph', 'Endomorph'];
  static const List<String> goals = [
    'Weight Loss',
    'Muscle Gain',
    'Maintain Health',
    'Improve Flexibility',
    'Increase Stamina'
  ];
  
  // BMI Classification (WHO)
  static const double bmiUnderweight = 18.5;
  static const double bmiNormal = 24.9;
  static const double bmiOverweight = 29.9;
  // Above 29.9 is Obese
  
  // App Info
  static const String appName = 'Fitola';
  static const String appVersion = '1.0.0';
}
