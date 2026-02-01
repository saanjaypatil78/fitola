import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/services/translation_service.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'en';
  final _translationService = TranslationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Choose Your Preferred Language',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You can change this later in settings',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FitolaTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView.builder(
                  itemCount: TranslationService.supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final entry = TranslationService.supportedLanguages.entries.elementAt(index);
                    final code = entry.key;
                    final name = entry.value;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: RadioListTile<String>(
                        title: Text(name),
                        subtitle: Text(code.toUpperCase()),
                        value: code,
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                        activeColor: FitolaTheme.primaryColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _translationService.setPreferredLanguage(_selectedLanguage);
                  Navigator.of(context).pushReplacementNamed(AppRoutes.userInfo);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
