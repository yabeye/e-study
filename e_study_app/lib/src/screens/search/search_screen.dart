import 'package:e_study_app/src/screens/files/file_card.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:provider/provider.dart';

import '../../models/files.dart';
import '../../models/user.model.dart';
import '../../providers/question_provider.dart';
import '../../theme/theme.dart';
import '../../widgets/common_ui.dart';
import '../question/question_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final QuestionProvider _questionProvider;
  List<Question> searchedQuestions = [];
  List<FileModel> searchedFiles = [];

  late final TextEditingController _searchController;

  bool _isFilesTab = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _questionProvider = context.read<QuestionProvider>();

    searchedQuestions = _questionProvider.questions;
    searchedFiles = _questionProvider.files;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchFiles() {
    print("Searching files ...${_searchController.text}");
    searchedQuestions = [];
    searchedFiles = [];

    searchedQuestions = _questionProvider.questions
        .where((q) => (q.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            q.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase())))
        .toList();

    searchedFiles = _questionProvider.files
        .where((q) => (q.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())))
        .toList();

    setState(() {});
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
              child: TextFormField(
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
                onFieldSubmitted: (v) {
                  hideKeyboard(context);
                },
                onChanged: (_) => _searchFiles(),
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
