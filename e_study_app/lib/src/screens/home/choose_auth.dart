import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/common/extensions/string_extensions.dart';
import 'package:e_study_app/src/providers/auth_provider.dart';
import 'package:e_study_app/src/screens/auth/reset_password.dart';
import 'package:e_study_app/src/screens/auth/signup_screen.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../api/exceptions.dart';
import '../../common/asset_locations.dart';
import '../../theme/theme.dart';
import '../main_screen.dart';
import '../splash_screeen.dart';

class ChooseAuth extends StatefulWidget {
  const ChooseAuth({super.key});

  @override
  State<ChooseAuth> createState() => _ChooseAuthState();
}

class _ChooseAuthState extends State<ChooseAuth> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '',
        backWidget: const BackWidget(iconColor: primaryColor),
        shadowColor: whiteColor,
        elevation: 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              30.height,
              svgEStudyLogo.svgImage(size: 144, color: primaryColor),
              60.height,
              AppButton(
                onTap: () {
                  const MainScreen().launch(context, isNewTask: true);
                },
                text: "Continue as guest",
                textColor: primaryColor,
                color: secondaryColor,
                width: context.width() * .9,
              ),
              20.height,
              AppButton(
                onTap: () {
                  const LoginScreen().launch(context);
                },
                text: "Login",
                textColor: whiteColor,
                color: primaryColor,
                width: context.width() * .9,
              ),
              30.height,
              const Divider(),
              30.height,
              Text(
                "Don't have an account ?",
                style: secondaryTextStyle(color: primaryColor),
                textAlign: TextAlign.center,
              ),
              10.height,
              AppButton(
                onTap: () {
                  const SignUpScreen().launch(context, isNewTask: false);
                },
                text: 'Sign Up',
                textColor: primaryColor,
                color: secondaryColor,
                width: context.width() * .9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthProvider _authProvider;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    _emailController = TextEditingController(text: _authProvider.emailStore);
    _passwordController =
        TextEditingController(text: _authProvider.passwordStore);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  login() async {
    // _emailController.text = "someemail@gmail.com";
    // _passwordController.text = "123456";

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      toasty(
        context,
        "Enter both email and password!",
        textColor: Colors.red,
      );
      return;
    }

    try {
      await _authProvider.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // ignore: use_build_context_synchronously
      const SplashScreen().launch(context, isNewTask: true);
    } on BadRequestException catch (e) {
      toasty(context, e.message);
    } on UnAuthorizedException catch (e) {
      toasty(context, e.message);
    } on FetchDataException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      toasty(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '',
        backWidget: const BackWidget(iconColor: primaryColor),
        shadowColor: whiteColor,
        elevation: 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.height() * 0.9,
          child: Column(
            children: [
              20.height,
              Text(
                "Login",
                style: boldTextStyle(size: 18),
              ),
              50.height,
              TextFormField(
                autofocus: true,
                controller: _emailController,
                style: boldTextStyle(
                  weight: FontWeight.normal,
                ),
                decoration: inputDecoration(
                  context,
                  hintText: "Username",
                  hintStyle: secondaryTextStyle(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onFieldSubmitted: (v) {
                  hideKeyboard(context);
                },
              ),
              10.height,
              TextFormField(
                controller: _passwordController,
                style: boldTextStyle(
                  weight: FontWeight.normal,
                ),
                decoration: inputDecoration(
                  context,
                  hintText: "Password",
                  hintStyle: secondaryTextStyle(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onFieldSubmitted: (v) {
                  hideKeyboard(context);
                },
              ),
              20.height,
              AppButton(
                onTap: login,
                text: 'Login',
                textColor: whiteColor,
                color: primaryColor,
                width: context.width() * .9,
              ),
              20.height,
              const Divider(),
              20.height,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    const ResetPasswordScreen()
                        .launch(context, isNewTask: false);
                  },
                  child: const Text("forgot password?"),
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 16),
        ),
      ),
    );
  }
}
