import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/network_service.dart';

class LifecycleComponent extends StatefulWidget {
  const LifecycleComponent({
    super.key,
    required this.softLogOut,
    required this.currentRouteName,
    required this.child,
  });

  final Widget child;
  final VoidCallback softLogOut;
  final String currentRouteName;

  @override
  State<StatefulWidget> createState() => _LifecycleComponent();
}

class _LifecycleComponent extends State<LifecycleComponent>
    with WidgetsBindingObserver {
  DateTime? _startInBackgroundTime;
  late final NetworkService _networkService;
  StreamSubscription<void>? _logoutSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Get NetworkService instance from dependency injection
    _networkService = getIt<NetworkService>();
    
    // Listen to logout events from NetworkService
    _logoutSubscription = _networkService.onLogout.listen((_) {
      _handleNetworkServiceLogout();
    });
    
    // Resume monitoring if user is logged in
    _checkAndResumeMonitoring();
  }

  Future<void> _checkAndResumeMonitoring() async {
    final isLoggedIn = await _networkService.isLoggedIn();
    if (isLoggedIn) {
      _networkService.resumeInactivityMonitoring();
    }
  }

  @override
  void didUpdateWidget(covariant LifecycleComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _startInBackgroundTime = null;
  }

  void _handleNetworkServiceLogout() {
    // Trigger the soft logout callback
    widget.softLogOut();
    
    setState(() {
      _startInBackgroundTime = null;
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    
    // Check if user is logged in before processing lifecycle events
    final isLoggedIn = await _networkService.isLoggedIn();
    if (!isLoggedIn) return;
    
    if (state == AppLifecycleState.paused) {
      // App going to background
      setState(() {
        _startInBackgroundTime = DateTime.now();
      });
      _networkService.pauseInactivityMonitoring();
      
    } else if (state == AppLifecycleState.resumed) {
      // App coming to foreground
      _networkService.resumeInactivityMonitoring();
      
      await _checkTimeDifference(DateTime.now());
      
    } else if (state == AppLifecycleState.inactive) {
      // Optional: Handle inactive state (e.g., lock screen detection)
    }
  }

  Future<void> _checkTimeDifference(DateTime time) async {
    if (_startInBackgroundTime != null) {
      // Check background timeout via NetworkService
      await _networkService.checkBackgroundTimeout(_startInBackgroundTime!);
      
      setState(() {
        _startInBackgroundTime = null;
      });
    }
  }

  void _recordInteractionIfLoggedIn() async {
    final isLoggedIn = await _networkService.isLoggedIn();
    if (isLoggedIn) {
      _networkService.recordUserInteraction();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragDown: (details) {
          _recordInteractionIfLoggedIn();
        },
        onPanUpdate: (details) {
          _recordInteractionIfLoggedIn();
        },
        onLongPress: () {
          _recordInteractionIfLoggedIn();
        },
        onTap: () {
          _recordInteractionIfLoggedIn();
        },
        onHorizontalDragDown: (details) {
          _recordInteractionIfLoggedIn();
        },
        child: widget.child,
      );

  @override
  void dispose() {
    _logoutSubscription?.cancel();
    _startInBackgroundTime = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}