import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';
import 'package:ryal_mobile/state/register/register_cubit.dart';
import 'package:ryal_mobile/ui/components/icons/svg_icon_component.dart';
import 'package:ryal_mobile/ui/enums/user_type_enum.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/kyc_icon_widget.dart';

@RoutePage()
class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() =>
      _KycVerificationScreenState();
}

enum VerificationStep { qidFront, qidBack, face }

class _KycVerificationScreenState
    extends State<KycVerificationScreen> {
  VerificationStep currentStep = VerificationStep.qidFront;
  String? qidFrontPath;
  String? qidBackPath;
  String? facePath;
  bool permissionGranted = false;
  List<CameraDescription>? cameras;
  bool isLoadingCameras = true;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  final ILocalStorageProvider _storageProvider = getIt<ILocalStorageProvider>();
  late final String userType;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
    _loadUserData();
  }
Future<void> _loadUserData() async {
    try {
      debugPrint("📖 Loading user data from storage...");
      
      final profile = await _storageProvider.getUserProfile();
      
      if (profile != null) {
        setState(() {
      userType = profile['user_type'] ?? 'User';
          // phoneNumber = profile['phone_number'] ?? '';
          // isBiometricStored = profile['is_biometric_verified'] ?? false;
          // _isLoadingData = false;
        });
        
        debugPrint("✅ User data loaded:");
        debugPrint("   UserType: $userType");
       
        
        // Now verify biometric status
      } else {
        debugPrint("⚠️ No profile found in storage - user needs to login");
        
        
        // Navigate to login if no profile
        if (mounted) {
          appRouter.replaceAll([const AuthSelectionRoute()]);
        }
      }
    } catch (e) {
      debugPrint("❌ Error loading user data: $e");
    
      
  
    }
  }
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      debugPrint('Available cameras: ${cameras?.length}');
      
      // Try to initialize camera directly first (this triggers iOS permission)
      await _initializeCamera();
      
      setState(() {
        permissionGranted = true;
      });
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
      
      // Only check permission_handler if camera fails
      final status = await Permission.camera.status;
      debugPrint('Permission status: $status');
      
      if (status.isPermanentlyDenied) {
        _showPermissionDialog();
      } else if (status.isDenied) {
        // Don't request again, just show dialog
        _showPermissionDialog();
      } else {
        // Permission might be granted but camera failed for another reason
        setState(() {
          permissionGranted = true;
        });
      }
    } finally {
      setState(() {
        isLoadingCameras = false;
      });
    }
  }

  Future<void> _initializeCamera() async {
    if (cameras == null || cameras!.isEmpty) return;

    try {
      setState(() {
        _isCameraInitialized = false;
      });

      // Dispose previous controller if exists
      final oldController = _cameraController;
      _cameraController = null;
      
      await oldController?.dispose();

      CameraDescription selectedCamera;
      
      if (currentStep == VerificationStep.face) {
        selectedCamera = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras!.first,
        );
      } else {
        selectedCamera = cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras!.first,
        );
      }

      debugPrint('Initializing camera: ${selectedCamera.name}');

      final newController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await newController.initialize();

      if (mounted) {
        setState(() {
          _cameraController = newController;
          _isCameraInitialized = true;
        });
      } else {
        await newController.dispose();
      }

      debugPrint('Camera initialized successfully');
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'This app needs camera access to verify your identity.\n\n'
          'Please follow these steps:\n'
          '1. Tap "Open Settings" below\n'
          '2. Find "Camera" in the list\n'
          '3. Enable camera access for this app\n'
          '4. Return to the app',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.router.pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              
              await Future.delayed(const Duration(seconds: 1));
              
              final status = await Permission.camera.status;
              if (status.isGranted) {
                setState(() {
                  permissionGranted = true;
                });
                await _initializeCamera();
              }
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Helper method to check if a step is completed
  bool _isStepCompleted(int stepIndex) {
    if (stepIndex == 0) {
      // First icon represents QID front and back
      return qidFrontPath != null && qidBackPath != null;
    } else if (stepIndex == 1) {
      // Second icon (if you want to track something separately)
      return false; // Adjust based on your requirements
    } else if (stepIndex == 2) {
      // Third icon (if you want to track something separately)
      return false; // Adjust based on your requirements
    }
    return false;
  }

  String get stepTitle {
    switch (currentStep) {
      case VerificationStep.qidFront:
        return 'Scan your QID';
      case VerificationStep.qidBack:
        return 'Scan your QID';
      case VerificationStep.face:
        return 'Scan your face';
    }
  }

  String get stepSubtitle {
    switch (currentStep) {
      case VerificationStep.qidFront:
        return 'For verification, please scan your Qatar ID.';
      case VerificationStep.qidBack:
        return 'For verification, please scan your Qatar ID.';
      case VerificationStep.face:
        return 'For verification, please scan your Qatar ID.';
    }
  }

  String get stepLabel {
    switch (currentStep) {
      case VerificationStep.qidFront:
        return 'Front side';
      case VerificationStep.qidBack:
        return 'Back side';
      case VerificationStep.face:
        return '';
    }
  }

  String get stepInstruction {
    switch (currentStep) {
      case VerificationStep.qidFront:
      case VerificationStep.qidBack:
        return 'Fit your ID within the guides';
      case VerificationStep.face:
        return 'Please look directly at the camera';
    }
  }

  String? get capturedImagePath {
    switch (currentStep) {
      case VerificationStep.qidFront:
        return qidFrontPath;
      case VerificationStep.qidBack:
        return qidBackPath;
      case VerificationStep.face:
        return facePath;
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      debugPrint('Camera not initialized');
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      debugPrint('Picture taken: ${image.path}');
      
      setState(() {
        switch (currentStep) {
          case VerificationStep.qidFront:
            qidFrontPath = image.path;
            break;
          case VerificationStep.qidBack:
            qidBackPath = image.path;
            break;
          case VerificationStep.face:
            facePath = image.path;
            break;
        }
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _nextStep() async {
    if (currentStep == VerificationStep.qidFront) {
      setState(() {
        currentStep = VerificationStep.qidBack;
      });
      await _initializeCamera();
    } else if (currentStep == VerificationStep.qidBack) {
      setState(() {
        currentStep = VerificationStep.face;
      });
      await _initializeCamera();
    } else {
      // Dispose camera before showing completion dialog
      await _cameraController?.dispose();
      setState(() {
        _cameraController = null;
        _isCameraInitialized = false;
      });
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KYC verification Complete'),
        content: const Text('Proceed to set your Mpin'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                currentStep = VerificationStep.qidFront;
                qidFrontPath = null;
                qidBackPath = null;
                facePath = null;
              });
              await _initializeCamera();
            },
            child: const Text('Start Over'),
          ),
          TextButton(
            onPressed: () {
              appRouter.pop(context);
              context.router.pop({
                'qidFront': qidFrontPath,
                'qidBack': qidBackPath,
                'face': facePath,
              });
              getIt<RegisterCubit>().updateStatus(is_kyc_verified: true);
              appRouter.push(SetMpinRoute(isFirstSetup: true));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildKycIconWithProgress({
    required String iconPath,
    required bool isCompleted,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: isCompleted
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                )
              : null,
          child: KycIconWidget(iconPath: iconPath),
        ),
        if (isCompleted)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingCameras) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final hasCapture = capturedImagePath != null;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if(userType == 'corporate')
                  _buildKycIconWithProgress(
                            iconPath: AppAssets.icKyc1,
                            isCompleted: _isStepCompleted(0),
                          ),
                          _buildKycIconWithProgress(
                            iconPath: AppAssets.icKyc1,
                            isCompleted: _isStepCompleted(0),
                          ),
                          _buildKycIconWithProgress(
                            iconPath: AppAssets.icKyc2,
                            isCompleted: _isStepCompleted(1),
                          ),

                          _buildKycIconWithProgress(
                            iconPath: AppAssets.icKyc3,
                            isCompleted: _isStepCompleted(2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        stepTitle,
                        style: AppTextStyles.primary.n24w600.blueText,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stepSubtitle,
                        style: AppTextStyles.primary.n14w400.blueText,
                      ),
                      const SizedBox(height: 32),
                      if (stepLabel.isNotEmpty)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            stepLabel,
                            style: AppTextStyles.primary.n18w600.primaryBlueText,
                          ),
                        ),
                      if (stepLabel.isNotEmpty) const SizedBox(height: 14),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryBlueButton,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: currentStep == VerificationStep.face
                                ? BorderRadius.circular(200)
                                : BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: currentStep == VerificationStep.face
                                ? BorderRadius.circular(198)
                                : BorderRadius.circular(10),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (hasCapture)
                                  Image.file(
                                    File(capturedImagePath!),
                                    fit: BoxFit.cover,
                                  )
                                else if (_isCameraInitialized && _cameraController != null)
                                  Transform.scale(
                                    scale: 1.7,
                                    child: Center(
                                      child: CameraPreview(_cameraController!),
                                    ),
                                  )
                                else
                                  Container(
                                    color: Colors.blue[50],
                                    child: Center(
                                      child: permissionGranted
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              'Camera permission required',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                if (hasCapture)
                                  Container(
                                    color: Colors.black.withOpacity(0.3),
                                    child: const Center(
                                      child: Text(
                                        'SUCCESS',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Center(
                        child: Text(
                          stepInstruction,
                          style: AppTextStyles.primary.n16w400.blueText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasCapture)
                      ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlueButton,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryBlueButton,
                            width: 2,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: permissionGranted ? _captureImage : _initializeCameras,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlueButton,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(17),
                          ),
                          child: SvgIconComponent(iconPath: AppAssets.icCamera, size: 32),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}