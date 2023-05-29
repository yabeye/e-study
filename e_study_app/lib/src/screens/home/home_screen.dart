import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:provider/provider.dart';
import 'package:e_study_app/src/providers/question_provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/common_ui.dart';
import '../question/question_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final QuestionProvider _questionProvider;

  bool _isLoading = false;
  List<Question> allQuestions = [];
  List<Question> filteredQuestions = [];
  String _filterKey = "All";

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();

    afterBuildCreated(() async {
      await fetchAllQuestions();
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        await fetchAllQuestions();
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  Future<void> fetchAllQuestions() async {
    _isLoading = true;
    setState(() {});
    await context.read<QuestionProvider>().getQuestions();
    _isLoading = false;
    setState(() {});
    allQuestions = [..._questionProvider.questions];
    filterQuestion();
  }

  void filterQuestion() {
    filteredQuestions = [];

    filteredQuestions = allQuestions
        .where((q) => (q.category == _filterKey) || _filterKey == "All")
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '',
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '${allQuestions.length} Questions',
              style: primaryTextStyle(color: white),
            ),
            CustomChips(
              name:
                  "${Question.filterQuestions(allQuestions, "Natural Science").length} Natural",
            ).paddingSymmetric(horizontal: 5),
            CustomChips(
              name:
                  "${Question.filterQuestions(allQuestions, "Social Science").length} Social",
            ).paddingSymmetric(horizontal: 5),
            CustomChips(
              name:
                  "${Question.filterQuestions(allQuestions, "Others").length} Others",
            ).paddingSymmetric(horizontal: 5),
          ],
        ),
        color: primaryColor,
        showBack: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20),
          child: Container(
            color: primaryColor,
            child: Column(
              children: [
                Container(
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
                const LinearProgressIndicator().visible(
                  allQuestions.isEmpty && _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchAllQuestions,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: 15.height,
            ),
            SliverToBoxAdapter(child: 10.height),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: QuestionCard(
                    question: filteredQuestions[index],
                  ),
                ),
                childCount: filteredQuestions.length,
                // childCount: _availableHandyMen.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
