import 'package:e_study_app/src/screens/files/file_card.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';

import '../../models/files.dart';
import '../../models/user.model.dart';
import '../../widgets/common_ui.dart';
import '../question/question_card.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final List<FileModel> allFiles = [
    FileModel(
      name: "2012 Biology Model Exam for Bethelehem Secondary School",
      size: "22MB",
      category: categories[1],
      uploadedBy: User(
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
      createdAt: DateTime.now(),
    ),
    FileModel(
      name: "Math Note on Trigonometry",
      size: "12MB",
      category: categories[3],
      uploadedBy: User(
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
      createdAt: DateTime.now(),
    ),
    FileModel(
      name: "2010 Mathematics Model Exam for Bethelehem Secondary School",
      size: "55MB",
      category: categories[3],
      uploadedBy: User(
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
      createdAt: DateTime.now(),
    ),
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
  List<FileModel> filteredFiles = [];
  String _filterKey = "All";

  @override
  void initState() {
    super.initState();
    filteredFiles = allFiles;
  }

  void filterQuestion() {
    filteredFiles = [];

    filteredFiles = allFiles
        .where((q) => (q.category == _filterKey) || _filterKey == "All")
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '${allFiles.length} Files',
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
              child: CommonDropDownComponent(
                items: categories,
                defaultValue: _filterKey,
                callback: (v) {
                  _filterKey = v ?? "All";
                  setState(() {});
                  filterQuestion();
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
          SliverToBoxAdapter(child: 10.height),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FileCard(
                  currentFile: allFiles[index],
                ),
              ),
              childCount: filteredFiles.length,
              // childCount: _availableHandyMen.length,
            ),
          ),
        ],
      ),
    );
  }
}
