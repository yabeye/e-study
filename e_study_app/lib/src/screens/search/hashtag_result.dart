import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/providers/question_provider.dart';
import 'package:e_study_app/src/screens/question/question_card.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../widgets/common_ui.dart';

class HashTagResult extends StatefulWidget {
  const HashTagResult({super.key, required this.hashKey});
  final String hashKey;

  @override
  State<HashTagResult> createState() => _HashTagResultState();
}

class _HashTagResultState extends State<HashTagResult> {
  String hashKey = "";
  late final QuestionProvider _questionProvider;

  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    hashKey = widget.hashKey;
    _questionProvider = context.read<QuestionProvider>();
    questions = _questionProvider.questions
        .where((q) => q.hashTags.contains(hashKey))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '#$hashKey',
        backWidget: const BackWidget(iconColor: Colors.white),
        shadowColor: whiteColor,
        elevation: 0,
        color: primaryColor,
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (c, i) {
            return QuestionCard(question: questions[i]);
          },
        ),
      ),
    );
  }
}
