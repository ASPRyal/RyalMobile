import 'package:flutter/material.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/services/storages/i_storage_service.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

class LanguageSelectorWidget extends StatefulWidget {
  const LanguageSelectorWidget({super.key});

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final locale = await getIt<IStorageService>().getLangCode();
    if (mounted) {
      setState(() {
        selectedLanguage = locale?.languageCode == 'ar' ? 'Arabic' : 'English';
      });
    }
  }

  Future<void> _toggleLanguage() async {
    // Toggle to the opposite language
    final newLanguage = selectedLanguage == 'English' ? 'Arabic' : 'English';
    final languageCode = newLanguage == 'Arabic' ? 'ar' : 'en';
    final countryCode = newLanguage == 'Arabic' ? 'SA' : 'US';
    final newLocale = Locale(languageCode, countryCode);

    // Save to storage
    await getIt<IStorageService>().changeLangCode(languageCode);

    // Update app locale
    final myAppState = MyApp.of(context);
    if (myAppState != null) {
      await myAppState.setLocale(newLocale);
    }

    // Update local state
    if (mounted) {
      setState(() {
        selectedLanguage = newLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border.all(
          color: Color(0xFFEBEBEB),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextButton(
        onPressed: _toggleLanguage,
        child: Text(
          selectedLanguage == 'English' ? 'العربية' : 'EN',
          style: AppTextStyles.primary.n16w500.primaryBlueText,
        ),
      ),
    );
  }
}