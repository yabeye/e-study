import 'dart:async';

import 'package:e_study_app/src/providers/auth_provider.dart';
import 'package:e_study_app/src/providers/question_provider.dart';
import 'package:e_study_app/src/screens/files/file_card.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:provider/provider.dart';

import '../../models/file_model.dart';
import '../../models/user.model.dart';
import '../../widgets/common_ui.dart';
import '../question/question_card.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  late final QuestionProvider _questionProvider;
  late final AuthProvider _authProvider;

  List<FileModel> allFiles = [];
  List<FileModel> filteredFiles = [];
  String _filterKey = "All";

  Timer? _timer;

  Timer? _timer2;

  @override
  void dispose() {
    _timer!.cancel();
    _timer2!.cancel();
    _questionProvider.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();
    _authProvider = context.read<AuthProvider>();

    allFiles = _questionProvider.files;
    filteredFiles = allFiles;
    afterBuildCreated(() async {
      await fetchAllQuestions();
      _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
        await fetchAllQuestions();
      });
      _timer2 = Timer.periodic(const Duration(seconds: 30), (timer) async {
        await _authProvider.refreshUser();
      });
    });
  }

  Future<void> fetchAllQuestions() async {
    await context.read<QuestionProvider>().getQuestions();

    allFiles = [..._questionProvider.files];
    filterQuestion();
  }

  void filterQuestion() {
    filteredFiles = [];

    filteredFiles = allFiles
        .where((q) =>
            (q.category.toLowerCase() == _filterKey.toLowerCase()) ||
            _filterKey == "All")
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
      body: RefreshIndicator(
        onRefresh: fetchAllQuestions,
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(
            //   child: filteredFiles.isNotEmpty
            //       ? Container()
            //       : const LinearProgressIndicator(),
            // ),
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
      ),
    );
  }
}
