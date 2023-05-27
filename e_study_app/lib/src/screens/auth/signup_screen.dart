import 'dart:io';

import 'package:e_study_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../api/exceptions.dart';
import '../../common/constants.dart';
import '../../theme/theme.dart';
import '../../widgets/common_ui.dart';
import '../splash_screeen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final AuthProvider _authProvider;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
  }

  sinUp() async {
    // if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    //   toasty(
    //     context,
    //     "Enter both email and password!",
    //     textColor: Colors.red,
    //   );
    //   return;
    // }

    try {
      await _authProvider.signUp(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      // ignore: use_build_context_synchronously
      const SplashScreen().launch(context, isNewTask: true);
    } on BadRequestException catch (e) {
      toasty(context, e.message);
    } on UnAuthorizedException catch (e) {
      toasty(context, e.message);
    } on SocketException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      toasty(context, e.toString());
      print("ERR SIGUP: ${e.toString()}");
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
        child: Column(
          children: [
            20.height,
            Text(
              "Sing Up",
              style: boldTextStyle(size: 18),
            ),
            20.height,
            TextFormField(
              autofocus: true,
              controller: _emailController,
              style: boldTextStyle(
                weight: FontWeight.normal,
              ),
              decoration: inputDecoration(
                context,
                hintText: "Firstname",
                hintStyle: secondaryTextStyle(),
                prefixIcon: const Icon(Icons.search),
              ),
              onFieldSubmitted: (v) {
                hideKeyboard(context);
              },
            ),
            20.height,
            TextFormField(
              autofocus: true,
              controller: _lastNameController,
              style: boldTextStyle(
                weight: FontWeight.normal,
              ),
              decoration: inputDecoration(
                context,
                hintText: "LastName",
                hintStyle: secondaryTextStyle(),
                prefixIcon: const Icon(Icons.search),
              ),
              onFieldSubmitted: (v) {
                hideKeyboard(context);
              },
            ),
            20.height,
            TextFormField(
              autofocus: true,
              controller: _emailController,
              style: boldTextStyle(
                weight: FontWeight.normal,
              ),
              decoration: inputDecoration(
                context,
                hintText: "Email",
                hintStyle: secondaryTextStyle(),
                prefixIcon: const Icon(Icons.search),
              ),
              onFieldSubmitted: (v) {
                hideKeyboard(context);
              },
            ),
            20.height,
            TextFormField(
              autofocus: true,
              controller: _usernameController,
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
            20.height,
            TextFormField(
              autofocus: true,
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
              onTap: sinUp,
              text: 'Signup',
              textColor: whiteColor,
              color: primaryColor,
              width: context.width() * .9,
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}
