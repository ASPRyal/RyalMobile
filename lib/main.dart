import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/l10n/app_localizations.dart';
import 'package:ryal_mobile/network_service.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/services/storages/i_storage_service.dart';
import 'package:ryal_mobile/ui/components/connectivity_component.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred device orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  configureInjection('dev');
  final Locale? locale = await getIt<IStorageService>().getLangCode();

  if (kReleaseMode == true) {
    await SentryFlutter.init(
      (options) {
        options.dsn = 'https://3ef584fb396ce0a60bddcc978d84eafb@o4509954090270720.ingest.de.sentry.io/4509954091515984';
        options.sendDefaultPii = true;
        options.enableLogs = true;
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
        options.replay.sessionSampleRate = 0.1;
        options.replay.onErrorSampleRate = 1.0;
      },
      appRunner: () => runApp(SentryWidget(child: MyApp(locale: locale,))),
    );
  } else {
    runApp(MyApp(locale: locale,));
  }
}

// Create app router instance
final appRouter = AppRouter();

class MyApp extends StatefulWidget {
  const MyApp({
    required this.locale,
    super.key,
  });

  final Locale? locale;

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? mLocale;

  @override
  void initState() {
    super.initState();
    mLocale = widget.locale;
  }

  Future<void> setLocale(Locale locale) async {
    if (mLocale?.languageCode != locale.languageCode) {
      setState(() {
        mLocale = locale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      ensureScreenSize: true,
      enableScaleText: () {
        return true;
      },
      useInheritedMediaQuery: true,
      builder: (ctx, child) => AppWithInactivityHandler(
        child: MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          
          // Router configuration
          routerDelegate: appRouter.delegate(
            navigatorObservers: () => [
              SentryNavigatorObserver(),
            ],
          ),
          routeInformationParser: appRouter.defaultRouteParser(),
          
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          
          // Builder with connectivity and theme
          builder: (ctx, child) {
            final lang = Localizations.localeOf(ctx).languageCode;
            if (child != null) {
              return Directionality(
                textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                child: ConnectivityComponent(
                  router: appRouter,
                  child: child,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },

          // Localization delegates
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // Supported locales
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'SA'),
          ],
          
          localeResolutionCallback: (locale, supported) {
            if (mLocale == null) {
              Locale? locale4Save;
              for (final supportedLocale in supported) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  locale4Save = supportedLocale;
                  break;
                }
              }
              locale4Save ??= supported.first;
              return locale4Save;
            } else {
              return mLocale;
            }
          },
          locale: mLocale,
        ),
      ),
    );
  }
}

// ============================================
// Inactivity Handler Widget
// ============================================

class AppWithInactivityHandler extends StatefulWidget {
  final Widget child;
  
  const AppWithInactivityHandler({
    super.key,
    required this.child,
  });

  @override
  State<AppWithInactivityHandler> createState() => _AppWithInactivityHandlerState();
}

class _AppWithInactivityHandlerState extends State<AppWithInactivityHandler> 
    with WidgetsBindingObserver {
  final NetworkService _networkService = getIt<NetworkService>();
  final ILocalStorageProvider _storageProvider = getIt<ILocalStorageProvider>();
  DateTime? _backgroundStartTime;
  bool _isHandlingLogout = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Listen for inactivity logout events
    _networkService.onLogout.listen((_) {
      if (!_isHandlingLogout) {
        _handleInactivityLogout();
      }
    });
    
    debugPrint('🔒 Inactivity handler initialized');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
        // App went to background
        _backgroundStartTime = DateTime.now();
        _networkService.pauseInactivityMonitoring();
        debugPrint('📱 App went to background at ${_backgroundStartTime!.toIso8601String()}');
        break;
        
      case AppLifecycleState.resumed:
        // App came back to foreground
        if (_backgroundStartTime != null) {
          final timeInBackground = DateTime.now().difference(_backgroundStartTime!);
          debugPrint('📱 App resumed after ${timeInBackground.inMinutes} minutes in background');
          
          // Check if we should logout due to background timeout
          _networkService.checkBackgroundTimeout(_backgroundStartTime!);
        }
        
        _networkService.resumeInactivityMonitoring();
        _backgroundStartTime = null;
        break;
        
      case AppLifecycleState.inactive:
        debugPrint('📱 App is inactive (transitioning)');
        break;
        
      case AppLifecycleState.detached:
        debugPrint('📱 App is detached');
        break;
        
      case AppLifecycleState.hidden:
        debugPrint('📱 App is hidden');
        break;
    }
  }

  Future<void> _handleInactivityLogout() async {
    if (_isHandlingLogout) {
      debugPrint('⚠️ Already handling logout, skipping...');
      return;
    }
    
    _isHandlingLogout = true;
    debugPrint('⏰ Inactivity timeout reached - redirecting to mPIN screen');
    
    try {
      // Get user profile to check if user is logged in
      final profile = await _storageProvider.getUserProfile();
      
      if (profile != null && mounted) {
        final name = profile['name'] ?? 'User';
        final isBiometric = profile['is_biometric_verified'] ?? false;
        
        debugPrint('   User: $name');
        debugPrint('   Biometric enabled: $isBiometric');
        
        // Navigate to mPIN screen
        // This keeps tokens intact so user can re-authenticate
        appRouter.replaceAll([
          const SplashRoute()
        ]);
        
        // Show a message to user
        if (mounted) {
          // Wait a bit for navigation to complete
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              final context = appRouter.navigatorKey.currentContext;
              if (context != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session expired due to inactivity. Please login again.'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            }
          });
        }
      } else {
        debugPrint('⚠️ No profile found - navigating to auth selection');
        // No profile means we should go to login
        if (mounted) {
          appRouter.replaceAll([const SplashRoute()]);
        }
      }
    } catch (e) {
      debugPrint('❌ Error handling inactivity logout: $e');
      // On error, go to auth selection as fallback
      if (mounted) {
        appRouter.replaceAll([const SplashRoute()]);
      }
    } finally {
      // Reset flag after a delay to prevent multiple triggers
      Future.delayed(const Duration(seconds: 2), () {
        _isHandlingLogout = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}