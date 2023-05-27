import 'package:e_study_app/src/common/asset_locations.dart';
import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/common/extensions/string_extensions.dart';
import 'package:e_study_app/src/providers/auth_provider.dart';
import 'package:e_study_app/src/screens/home/choose_auth.dart';
import 'package:e_study_app/src/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../models/user.model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    afterBuildCreated(() async {
      // await 3.seconds.delay;

      // Checking wherether user logged in or not!
      // ignore: use_build_context_synchronously
      final isLoggedIn = _authProvider.isLoggedIn;
      await _authProvider.checkAuth();

      User? currentUser = _authProvider.currentUser;
      print(
        "Current user: $currentUser",
      );

      if (!_authProvider.isLoggedIn) {
        // go to choose
        const ChooseAuth().launch(context, isNewTask: true);
      } else {
        // go to home
        print("Go to just home");
        // ignore: use_build_context_synchronously
        const MainScreen().launch(context, isNewTask: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width(),
        height: context.height(),
        color: primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              svgEStudyLogo.svgImage(size: 72, color: whiteColor),
              10.height,
              Text(
                "E-Study APP",
                style: boldTextStyle(color: whiteColor),
              ),
              50.height,
              const CircularProgressIndicator(color: whiteColor),
            ],
          ),
        ),
      ),
    );
  }
}
