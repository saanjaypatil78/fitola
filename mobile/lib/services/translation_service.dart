import 'package:translator/translator.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();
  
  final _translator = GoogleTranslator();
  
  String _preferredLanguage = 'en';
  bool _isTranslationEnabled = false;
  
  String get preferredLanguage => _preferredLanguage;
  bool get isTranslationEnabled => _isTranslationEnabled;
  
  void setPreferredLanguage(String languageCode) {
    _preferredLanguage = languageCode;
  }
  
  void toggleTranslation(bool enabled) {
    _isTranslationEnabled = enabled;
  }
  
  Future<String> translate(String text, {String? targetLanguage}) async {
    try {
      if (!_isTranslationEnabled) return text;
      
      final target = targetLanguage ?? _preferredLanguage;
      
      // Don't translate if already in target language
      if (target == 'en') return text;
      
      final translation = await _translator.translate(
        text,
        to: target,
      );
      
      return translation.text;
    } catch (e) {
      // If translation fails, return original text
      return text;
    }
  }
  
  Future<String> translateWithSource(
    String text,
    String sourceLanguage,
    String targetLanguage,
  ) async {
    try {
      final translation = await _translator.translate(
        text,
        from: sourceLanguage,
        to: targetLanguage,
      );
      
      return translation.text;
    } catch (e) {
      return text;
    }
  }
  
  Future<String> detectLanguage(String text) async {
    try {
      final translation = await _translator.translate(text, to: 'en');
      return translation.sourceLanguage.code;
    } catch (e) {
      return 'unknown';
    }
  }
  
  // Supported languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'zh-cn': 'Chinese (Simplified)',
    'zh-tw': 'Chinese (Traditional)',
    'ar': 'Arabic',
    'hi': 'Hindi',
    'bn': 'Bengali',
    'pa': 'Punjabi',
    'te': 'Telugu',
    'mr': 'Marathi',
    'ta': 'Tamil',
    'ur': 'Urdu',
    'gu': 'Gujarati',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'tr': 'Turkish',
    'vi': 'Vietnamese',
    'th': 'Thai',
    'id': 'Indonesian',
    'ms': 'Malay',
    'nl': 'Dutch',
    'pl': 'Polish',
    'uk': 'Ukrainian',
    'ro': 'Romanian',
    'sv': 'Swedish',
    'da': 'Danish',
    'fi': 'Finnish',
    'no': 'Norwegian',
    'el': 'Greek',
    'he': 'Hebrew',
  };
}
