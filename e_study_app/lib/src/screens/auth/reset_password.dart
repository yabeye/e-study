import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../api/exceptions.dart';
import '../../common/constants.dart';
import '../../providers/auth_provider.dart';
import '../../theme/theme.dart';
import '../../widgets/common_ui.dart';
import '../splash_screeen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final AuthProvider _authProvider;
  late final TextEditingController _emailController;
  late final TextEditingController _newPassword;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    _emailController = TextEditingController();
    _newPassword = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  login() async {
    // _emailController.text = "someemail@gmail.com";
    // _newPassword.text = "";

    _isLoading = true;
    setState(() {});
    try {
      await _authProvider.resetPassword(
        email: _emailController.text,
        password: _newPassword.text,
      );

      // ignore: use_build_context_synchronously
      context.pop();
      toastLong("Check your email!\n${_emailController.text}");
    } on BadRequestException catch (e) {
      toasty(context, e.message);
    } on UnAuthorizedException catch (e) {
      toasty(context, e.message);
      _authProvider.clear();
      const SplashScreen().launch(context, isNewTask: true);
    } on FetchDataException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      toasty(context, e.toString());
    } finally {
      _isLoading = false;
      setState(() {});
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
                "Reset Password",
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
                  hintText: "Email",
                  hintStyle: secondaryTextStyle(),
                  prefixIcon: const Icon(Icons.email),
                ),
                onFieldSubmitted: (v) {
                  hideKeyboard(context);
                },
              ),
              10.height,
              TextFormField(
                controller: _newPassword,
                style: boldTextStyle(
                  weight: FontWeight.normal,
                ),
                decoration: inputDecoration(
                  context,
                  hintText: "New Password",
                  hintStyle: secondaryTextStyle(),
                  prefixIcon: const Icon(Icons.password),
                ),
                onFieldSubmitted: (v) {
                  hideKeyboard(context);
                },
              ),
              20.height,
              AppButton(
                onTap: _isLoading ? null : login,
                text: _isLoading ? '...' : 'Reset Password',
                disabledColor: loadingColor,
                textColor: whiteColor,
                color: primaryColor,
                width: context.width() * .9,
              ),
              20.height,
              const Divider(),
              20.height,
              const Text(
                "We will send you a password reset link to your email address!",
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
        ),
      ),
    );
  }
}
