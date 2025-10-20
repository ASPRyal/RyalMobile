import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/services/i_connection_service.dart';
import 'package:ryal_mobile/ui/components/buttons/bordered_button.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/colored_safearea.dart';
import 'package:ryal_mobile/ui/widgets/unfocuser.dart';


class ConnectivityComponent extends StatefulWidget {
  const ConnectivityComponent({
    required this.router,
    required this.child,
    super.key,
  });

  final Widget child;
  final AppRouter router;

  @override
  State<StatefulWidget> createState() => _ConnectivityComponent();
}

class _ConnectivityComponent extends State<ConnectivityComponent> {
  StreamSubscription<bool>? _connectivitySubscription;
  bool _hasConnection = true;
  Timer? _timer;
  bool _hasCheckedInitialConnection = false;
  bool _shouldShowOverlay = false; // New state to control overlay visibility
  Timer? _showOverlayTimer; // New timer for overlay delay

  @override
  void initState() {
    super.initState();
    _setupConnectivityListener();
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    // Start listening for connection changes immediately
    final connectionService = getIt<IConnectionService>();
    final hasConnection = await connectionService.hasConnection();

    if (mounted) {
      setState(() {
        _hasCheckedInitialConnection = true;
        // Only update _hasConnection if we actually don't have a connection
        if (!hasConnection) {
          _hasConnection = false;
        }
      });
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription ??=
        getIt<IConnectionService>().connection.listen((hasConnection) {
      if (hasConnection != _hasConnection) {
        if (hasConnection) {
          setState(() {
            _timer?.cancel();
            _timer = null;
            _showOverlayTimer?.cancel(); // Cancel overlay timer
            _showOverlayTimer = null;
            _hasConnection = hasConnection;
            _shouldShowOverlay =
                false; // Hide overlay immediately when connection restored
          });
        } else {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

          // Add delay before showing overlay
          _showOverlayTimer?.cancel();
          _showOverlayTimer = Timer(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _shouldShowOverlay = true;
              });
            }
          });

          setState(() {
            _hasConnection = hasConnection;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          if (!_hasConnection &&
              _hasCheckedInitialConnection &&
              _shouldShowOverlay) ...[
            Unfocuser(
              child: ColoredSafeArea.darkOverlay(
                color: AppColors.disablePurple,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const SvgIconComponent(
                        //   iconPath: AppAssets.icNoInternet,
                        //   size: 266,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 27),
                          child: Text(
                            "context.l10n.no_internet_title",
                            style: AppTextStyles.primary.n16w700.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 27),
                          child: Text(
                          "  context.l10n.no_internet_subtitle",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.primary.n16w700,
                          ),
                        ),
                        BorderedButton(
                          buttonWidth: 140.w,
                          borderColor: AppColors.white,
                          text: "context.l10n.global_ok",
                          buttonColor: AppColors.disablePurple,
                          textStyle: AppTextStyles.primary.n16w700.black,
                          onTap: () {
                            setState(() {
                              _hasConnection = true;
                            });
                            getIt<IConnectionService>().manualConnectionCheck();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      );

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
