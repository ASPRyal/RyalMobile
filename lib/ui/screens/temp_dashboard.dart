import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/appbar.dart';
import 'package:ryal_mobile/ui/widgets/language_selection.dart';

@RoutePage()
class TempDashboardScreen extends StatefulWidget {
  const TempDashboardScreen({super.key});

  @override
  State<TempDashboardScreen> createState() => _TempDashboardScreenState();
}

class _TempDashboardScreenState extends State<TempDashboardScreen> {

  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TransparentAppBar(
        showBackButton: false,
        preferredSize: const Size.fromHeight(60),
        action: LanguageSelectorWidget(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 22.0,right: 22,bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your other widgets here
              Text("WELCOME TO TEMPORARY DASHBOARD",
                  style: AppTextStyles.primary.n32w500.black),
                      SizedBox(height: 44.h),
                        
         
                     
            ],
          ),
        ),
      ),
    );
  }
}