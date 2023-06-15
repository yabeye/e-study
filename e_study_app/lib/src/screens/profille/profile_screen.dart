import 'package:e_study_app/src/common/extensions/string_extensions.dart';
import 'package:e_study_app/src/helpers/ui_helpers.dart';
import 'package:e_study_app/src/providers/auth_provider.dart';
import 'package:e_study_app/src/screens/profille/edit_profile_screen.dart';
import 'package:e_study_app/src/screens/splash_screeen.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../home/choose_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tabIndex = 0;
  late final AuthProvider _authProvider;
  bool _isAuth = false;

  @override
  void initState() {
    _authProvider = context.read<AuthProvider>();
    _isAuth = _authProvider.isLoggedIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          title: "Profile",
          actions: !_isAuth
              ? []
              : [
                  IconButton(
                    onPressed: () => confirm(context,
                        message:
                            "Are you sure you want to delete your account ?",
                        () async {
                      try {
                        await _authProvider.deleteUser(
                            id: _authProvider.currentUser!.id ?? "");
                        toast("Your account has been deleted!");

                        await _authProvider.clear();
                        // ignore: use_build_context_synchronously
                        const SplashScreen().launch(context, isNewTask: true);
                      } catch (e) {
                        toast("Unable to delete your account at the moment!");
                        print(e.toString());
                      }
                    }),
                    icon: const Icon(
                      Icons.delete_outlined,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox().paddingSymmetric(horizontal: 8),
                  GestureDetector(
                      onTap: () => confirm(
                            context,
                            message: "Are you sure you want to logout ?",
                            () async {
                              await _authProvider.clear();
                              // ignore: use_build_context_synchronously
                              const SplashScreen()
                                  .launch(context, isNewTask: true);
                            },
                          ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      )),
                ]),
      body: !_isAuth
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgEStudyLogo.svgImage(size: 72, color: gray),
                  10.height,
                  Text(
                    "Hello Student,\nFor full capability, please login",
                    style: secondaryTextStyle(
                      size: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  50.height,
                  AppButton(
                    onTap: () {
                      const ChooseAuth().launch(context, isNewTask: true);
                    },
                    text: 'Login',
                    textColor: white,
                    color: primaryColor,
                    width: context.width() * .9,
                  ),
                  25.height,
                  SizedBox(
                    width: context.width() * .7,
                    child: const Divider(
                      thickness: 4,
                    ),
                  ),
                  25.height,
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: 10.height),
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Text(
                      "Badge(s) Awarded",
                      style: primaryTextStyle(),
                    ),
                    5.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        svgBasic.svgImage(size: 32, color: Colors.grey).visible(
                            (_authProvider.currentUser!.awards ?? [])
                                .contains("B")),
                        svgSilver
                            .svgImage(
                              size: 32,
                              color: Colors.grey,
                            )
                            .visible((_authProvider.currentUser!.awards ?? [])
                                .contains("S")),
                        svgGold
                            .svgImage(
                              size: 32,
                            )
                            .visible((_authProvider.currentUser!.awards ?? [])
                                .contains("G")),
                      ],
                    ),
                  ],
                )),
                SliverToBoxAdapter(child: 20.height),
                SliverToBoxAdapter(
                  child: SizedBox(
                    child: _authProvider.currentUser!.profilePic == null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: radius(100),
                            ),
                            child: SvgPicture.asset(
                              svgAvatar,
                              color: primaryColor,
                              width: 100,
                              height: 100,
                            ),
                          )
                        : CachedImageWidget(
                            url: _authProvider.currentUser!.profilePic!,
                            height: 50,
                          ),
                  ),
                ),
                SliverToBoxAdapter(child: 10.height),
                SliverToBoxAdapter(
                  child: Text(
                    "${_authProvider.currentUser!.firstName} ${_authProvider.currentUser!.lastName}",
                    style: boldTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    "@${_authProvider.currentUser!.username}",
                    style: secondaryTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: Text(
                //     "Bio: Grade 10 Student from Addis Ababa",
                //     style: secondaryTextStyle(),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: TextButton.icon(
                    onPressed: () {
                      const EditProfileScreen().launch(
                        context,
                        isNewTask: false,
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      _buildLabelContainer(
                        "Question (${_authProvider.currentUser!.question.length})",
                        _tabIndex == 0,
                        () {
                          _tabIndex = 0;
                          setState(() {});
                        },
                      ).expand(),
                      _buildLabelContainer(
                        "Answers (${_authProvider.currentUser!.answer.length})",
                        _tabIndex == 1,
                        () {
                          _tabIndex = 1;
                          setState(() {});
                        },
                      ).expand(),
                      _buildLabelContainer(
                        "Files (0)",
                        _tabIndex == 2,
                        () {
                          _tabIndex = 2;
                          setState(() {});
                        },
                      ).expand(),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (_, index) => Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //       child: QuestionCard(
                //         question: _authProvider.currentUser.question,
                //         withCategoryTag: false,
                //       ),
                //     ),
                //     childCount: [question].length,
                //     // childCount: _availableHandyMen.length,
                //   ),
                // ),
              ],
            ),
    );
  }

  InkWell _buildLabelContainer(
      String title, bool isSelected, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : secondaryColor,
          borderRadius: radius(),
        ),
        child: Center(
          child: Text(
            title,
            style: secondaryTextStyle(color: isSelected ? white : primaryColor),
          ),
        ),
      ),
    );
  }

  // void _openLogin() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return const LoginDialog();
  //     },
  //   );
  // }
}
