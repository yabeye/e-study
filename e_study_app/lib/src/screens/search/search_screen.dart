import 'package:e_study_app/src/screens/files/file_card.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';

import '../../models/files.dart';
import '../../models/user.model.dart';
import '../../theme/theme.dart';
import '../../widgets/common_ui.dart';
import '../question/question_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Question> searchedQuestions = [
    Question(
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
        username: "liya",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      answers: [
        Answer(
          id: "id",
          question: "id",
          answeredBy: User(
            id: "id",
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
            phone: "phone",
            username: "yeabsera",
            roles: "roles",
            question: [],
            answer: [],
            bookmarks: [],
          ),
          content:
              "an organelle found in large numbers in most cells, in which the biochemical processes of respiration and energy production occur. It has a double membrane, the inner part being folded inwards to form layers (cristae).",
          createdAt: DateTime.now(),
          voteCount: [],
          isActive: false,
          reportedBy: [],
        ),
      ],
      createdAt: DateTime.now(),
      hashTags: ["biology", "cell"],
    ),
    Question(
      id: "id",
      title: "Explain in detail a quadratic equation in math",
      description: "description",
      category: categories[3],
      isOpen: true,
      askedBy: User(
        id: "id",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        phone: "phone",
        username: "dimond",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      answers: [],
      createdAt: DateTime.now(),
      hashTags: ["math", "equations"],
    ),
    Question(
      id: "id",
      title:
          "How much energy does a bullet has if it leaves the muzzle at 300Km/hr at time t",
      description: "description",
      category: categories[1],
      isOpen: true,
      askedBy: User(
        id: "id",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        phone: "phone",
        username: "liya",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      answers: [],
      createdAt: DateTime.now(),
      hashTags: ["physics"],
    ),
  ];
  final List<FileModel> searchedFiles = [
    FileModel(
      name: "2014 Grade 12 National Civics Exam Preparation test",
      size: "5MB",
      category: categories[2],
      uploadedBy: User(
        id: "id",
        firstName: "firstName",
        lastName: "lastName",
        email: "email",
        phone: "phone",
        username: "abel",
        roles: "roles",
        question: [],
        answer: [],
        bookmarks: [],
      ),
      createdAt: DateTime.now(),
    ),
  ];

  late final TextEditingController _searchController;

  bool _isFilesTab = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchFiles() {
    toast("Searching files ...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Search',
        titleTextStyle: primaryTextStyle(color: white),
        color: primaryColor,
        showBack: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20),
          child: Container(
            color: primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: TextField(
                autofocus: true,
                controller: _searchController,
                style: boldTextStyle(
                  weight: FontWeight.normal,
                ),
                decoration: inputDecoration(
                  context,
                  hintText: "Search Question ... ",
                  hintStyle: secondaryTextStyle(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onSubmitted: (v) {
                  hideKeyboard(context);
                },
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: 15.height,
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomChips(
                  name: "Questions",
                  onTap: () {
                    _isFilesTab = true;
                    setState(() {});
                  },
                  isSelected: _isFilesTab,
                ),
                CustomChips(
                  name: "Files",
                  onTap: () {
                    _isFilesTab = false;
                    setState(() {});
                  },
                  isSelected: !_isFilesTab,
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: Divider(color: secondaryColor)),
          SliverToBoxAdapter(child: 10.height),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: QuestionCard(
                  question: searchedQuestions[index],
                ),
              ),
              childCount: !_isFilesTab ? 0 : searchedQuestions.length,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FileCard(
                  currentFile: searchedFiles[index],
                ),
              ),
              childCount: _isFilesTab ? 0 : searchedFiles.length,
            ),
          ),
        ],
      ),
    );
  }
}
