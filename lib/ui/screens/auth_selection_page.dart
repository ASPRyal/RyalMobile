import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/services/storages/i_storage_service.dart';
import 'package:ryal_mobile/ui/components/buttons/two_actions_button_component.dart';
import 'package:ryal_mobile/ui/widgets/appbar.dart';
import 'package:ryal_mobile/ui/widgets/language_selection.dart';

@RoutePage()
class AuthSelectionScreen extends StatefulWidget {
  const AuthSelectionScreen({super.key});

  @override
  State<AuthSelectionScreen> createState() => _AuthSelectionScreenState();
}

class _AuthSelectionScreenState extends State<AuthSelectionScreen> {
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final locale = await getIt<IStorageService>().getLangCode();
    setState(() {
      selectedLanguage = locale?.languageCode == 'ar' ? 'Arabic' : 'English';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return PopScope(
       canPop: false,
      child: Scaffold(
  //        floatingActionButton: FloatingActionButton(
  //   onPressed: () {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const DebugStorageTestScreen(),
  //       ),
  //     );
  //   },
  //   backgroundColor: Colors.orange,
  //   child: const Icon(Icons.bug_report),
  // ),
        backgroundColor: Colors.white,
        appBar: TransparentAppBar(
          showBackButton: false,
          preferredSize: const Size.fromHeight(60),
          action: LanguageSelectorWidget(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Add your other widgets here
                      Text("Some content goes here"),
                    ],
                  ),
                ),
              ),
      
              // Bottom buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TwoActionRowButtonsComponent(
                  leftButtonTap: () {
                    appRouter.push(const RegistrationRoute());

                  },
                  rightButtonTap: () {
                   // appRouter.push(MpinBioLoginRoute());
                    appRouter.push(const LoginRoute());

                  //  appRouter.push(const ChooseAccountTypeRoute());

                  },
                  isWhiteButton: true,
                  leftButtonTitle: context.l10n.signup,
                  rightButtonTitle: context.l10n.login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}