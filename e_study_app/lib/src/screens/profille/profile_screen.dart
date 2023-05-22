import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/models/user.model.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../../models/answer.model.dart';
import '../question/question_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = User(
    id: "id",
    firstName: "Abel",
    lastName: "Mulugeta",
    email: "email",
    phone: "phone",
    username: "abelo",
    roles: "user",
    question: [],
    answer: [],
    bookmarks: [],
  );
  int _tabIndex = 0;

  final question = Question(
    id: "id",
    title: "What is mitochondria ?",
    description:
        "Can you explain in detail what mitochondria is in human cell, and also the difference between human and animal mitochondria ? ",
    category: categories[1],
    isOpen: true,
    askedBy: User(
      id: "id",
      firstName: "firstName",
      lastName: "lastName",
      email: "email",
      phone: "phone",
      username: "abelo",
      roles: "roles",
      question: [],
      answer: [],
      bookmarks: [],
    ),
    answers: [],
    createdAt: DateTime.now(),
    hashTags: ["biology", "cell"],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Profile"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: 10.height),
          SliverToBoxAdapter(
            child: SizedBox(
              child: currentUser.profilePic == null
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
                      url: currentUser.profilePic!,
                      height: 50,
                    ),
            ),
          ),
          SliverToBoxAdapter(child: 10.height),
          SliverToBoxAdapter(
            child: Text(
              "${currentUser.firstName} ${currentUser.lastName}",
              style: boldTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              "@${currentUser.username}",
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          SliverToBoxAdapter(
            child: Text(
              "Bio: Grade 10 Student from Addis Ababa",
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          SliverToBoxAdapter(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                _buildLabelContainer(
                  "Question (1)",
                  _tabIndex == 0,
                  () {
                    _tabIndex = 0;
                    setState(() {});
                  },
                ).expand(),
                _buildLabelContainer(
                  "Answers (0)",
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: QuestionCard(
                  question: question,
                  withCategoryTag: false,
                ),
              ),
              childCount: [question].length,
              // childCount: _availableHandyMen.length,
            ),
          ),
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
}
