// import 'dart:io';

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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final AuthProvider _authProvider;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    final user = _authProvider.currentUser!;
    _firstNameController.text = user.firstName!;
    _lastNameController.text = user.lastName!;
    _usernameController.text = user.username!;
  }

  _updateProfile() async {
    try {
      await _authProvider.updateUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
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
              "Edit Profile",
              style: boldTextStyle(size: 18),
            ),
            20.height,
            TextFormField(
              autofocus: true,
              controller: _firstNameController,
              style: boldTextStyle(
                weight: FontWeight.normal,
              ),
              decoration: inputDecoration(
                context,
                labelText: "Firstname",
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
                labelText: "LastName",
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
                labelText: "Username",
                hintStyle: secondaryTextStyle(),
                prefixIcon: const Icon(Icons.search),
              ),
              onFieldSubmitted: (v) {
                hideKeyboard(context);
              },
            ),
            20.height,
            AppButton(
              onTap: _updateProfile,
              text: 'Update',
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
