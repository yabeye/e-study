import 'package:e_study_app/src/common/extensions/string_extensions.dart';
import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/screens/question/answer_card.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../api/exceptions.dart';
import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/question_provider.dart';
import '../../theme/theme.dart';
import '../home/choose_auth.dart';

class QuestionDetail extends StatefulWidget {
  const QuestionDetail({super.key, required this.question});

  final Question question;

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  late final AuthProvider _authProvider;
  late final QuestionProvider _questionProvider;
  late final TextEditingController _answerController;
  FocusNode _answerFocus = FocusNode(); //create focus node
  bool _isAuth = false;
  late Question question;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _authProvider = context.read<AuthProvider>();
    _questionProvider = context.read<QuestionProvider>();
    _answerController = TextEditingController();
    _isAuth = _authProvider.isLoggedIn;
    question = widget.question;
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  _answerQuestion() async {
    if (_answerController.text.length < 10) {
      toasty(
        context,
        "Add a sufficient answer\n   (at least 10 words)",
        textColor: redColor,
      );

      return;
    }

    _isLoading = true;
    setState(() {});
    try {
      final answer = await _questionProvider.addAnswer(
        id: widget.question.id,
        content: _answerController.text,
      );

      // ignore: use_build_context_synchronously
      toasty(context, "Answer Successfully!");
      _answerController.text = "";
      widget.question.answers.add(answer);
      _answerFocus.unfocus();

      setState(() {});
    } on BadRequestException catch (e) {
      toasty(context, e.message);
    } on UnAuthorizedException catch (e) {
      toasty(context, e.message);
    } on FetchDataException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      print(e.toString());
      toasty(context, "We are unable to do that!");
    }

    _isLoading = false;
    setState(() {});
  }

  void _voteQuestion(bool voting) async {
    try {
      question = await _questionProvider.voteQuestion(
        id: question.id,
        voting: voting,
      );

      setState(() {});
    } on BadRequestException catch (e) {
      toasty(context, e.message);
    } on UnAuthorizedException catch (e) {
      toasty(context, e.message);
    } on FetchDataException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      toasty(context, "We are unable to do that!");
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.question.answers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final askedBy = question.askedBy;
    return Scaffold(
      appBar: appBar(
        title: "Question",
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.category,
                  style: boldTextStyle(color: white),
                ),
                Text(
                  question.createdAt.timeAgo,
                  style: secondaryTextStyle(
                    size: 11,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: _showReport,
              icon: const Icon(
                Icons.report,
                color: whiteColor,
                size: 22,
              ),
              label: const Text(
                "Report",
                style: TextStyle(color: whiteColor, fontSize: 12),
              ),
            )
          ],
        ),
        showBack: true,
      ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: 15.height,
        ),
        SliverToBoxAdapter(
          child: Text(
            question.title,
            style: primaryTextStyle(size: 22),
          ),
        ),
        SliverToBoxAdapter(
          child: 15.height,
        ),
        SliverToBoxAdapter(
          child: Text(
            question.description,
            style: secondaryTextStyle(),
          ),
        ),
        SliverToBoxAdapter(
          child: 15.height,
        ),
        SliverToBoxAdapter(
          child: question.hashTags.isNotEmpty
              ? TextScroll(
                  question.hashTags.map((e) => "#$e").toList().join(" "),
                  velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                  style: secondaryTextStyle(),
                )
              : Container(),
        ),
        SliverToBoxAdapter(
          child: 15.height,
        ),
        SliverToBoxAdapter(
          child: askedBy.id != _authProvider.currentUser!.id
              ? null
              : Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      toast("Editngg...");
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Question"),
                  ),
                ),
        ),
        SliverToBoxAdapter(
          child: 15.height,
        ),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    child: askedBy.profilePic == null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: radius(100),
                            ),
                            child: SvgPicture.asset(
                              svgAvatar,
                              color: primaryColor,
                              width: 20,
                              height: 20,
                            ),
                          )
                        : CachedImageWidget(
                            url: askedBy.profilePic!,
                            height: 50,
                          ),
                  ).paddingSymmetric(horizontal: 4),
                  Text(
                    (askedBy.username ?? ""),
                    style: secondaryTextStyle(),
                  ).paddingSymmetric(vertical: 8),
                ],
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () async {
                        _voteQuestion(true);
                      },
                      child: (question.voteCount.contains(
                                  _authProvider.currentUser?.id.toString())
                              ? svgUpVoteSelected
                              : svgUpVote)
                          .svgImage(
                        size: 32,
                        color: black,
                      )),
                  const SizedBox().paddingSymmetric(horizontal: 2),
                  Text(
                    "${question.voteCount.length}",
                    style: secondaryTextStyle(),
                  ),
                  const SizedBox().paddingSymmetric(horizontal: 16),
                  GestureDetector(
                    onTap: () async {
                      _voteQuestion(false);
                    },
                    child: ((question.voteCountDown.contains(
                                _authProvider.currentUser?.id.toString())
                            ? svgDownVoteSelected
                            : svgDownVote)
                        .svgImage(size: 32, color: black)),
                  ),
                  const SizedBox().paddingSymmetric(horizontal: 2),
                  Text(
                    question.voteCountDown.length.toString(),
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: 5.height,
        ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverToBoxAdapter(
          child: !_isAuth
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      10.height,
                      Text(
                        "Please Login to write an answer!",
                        style: secondaryTextStyle(
                          size: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppButton(
                        onTap: () {
                          const ChooseAuth().launch(context, isNewTask: false);
                        },
                        text: 'Login',
                        textColor: white,
                        color: primaryColor,
                        width: context.width() * .9,
                      ),
                      10.height,
                      const Divider(),
                      20.height,
                    ],
                  ),
                )
              : Column(
                  children: [
                    TextField(
                      focusNode: _answerFocus,
                      controller: _answerController,
                      // minLines: 4,
                      style: boldTextStyle(
                        weight: FontWeight.normal,
                      ),
                      decoration: inputDecoration(
                        context,
                        hintText: "Add your answer ... ",
                        hintStyle: secondaryTextStyle(),
                      ),
                      maxLines: 3, //or null
                      onSubmitted: (v) {
                        hideKeyboard(context);
                      },
                    ),
                    5.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          onTap: _answerQuestion,
                          text: 'Add Answer',
                          textColor: whiteColor,
                          color: primaryColor,
                          width: context.width() * .1,
                        ),
                      ],
                    ),
                    5.height,
                    Text(
                      "Answers (${question.answers.length})",
                      style: primaryTextStyle(),
                    ),
                    15.height,
                  ],
                ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => AnswerCard(
              answer: question.answers[index] as Answer,
            ),
            childCount: question.answers.length,
            // childCount: _availableHandyMen.length,
          ),
        ),
      ]).paddingSymmetric(horizontal: 12),
    );
  }

  _showReport() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // height: 200,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text("Non Educational"),
                onTap: () async {
                  try {
                    await _questionProvider.reportQuestion(
                      id: question.id,
                      byId: _authProvider.currentUser!.id!,
                      report: "Non Educational",
                    );
                  } catch (e) {
                    toast("Unabe to report!");
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_calls),
                title: const Text("Spam"),
                onTap: () async {
                  try {
                    await _questionProvider.reportQuestion(
                      id: question.id,
                      byId: _authProvider.currentUser!.id!,
                      report: "Spam",
                    );
                  } catch (e) {
                    toast("Unabe to report!");
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sports_martial_arts),
                title: const Text("Violence"),
                onTap: () async {
                  try {
                    await _questionProvider.reportQuestion(
                      id: question.id,
                      byId: _authProvider.currentUser!.id!,
                      report: "Violence",
                    );
                  } catch (e) {
                    toast("Unabe to report!");
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_box_sharp),
                title: const Text("Adult Content"),
                onTap: () async {
                  try {
                    await _questionProvider.reportQuestion(
                      id: question.id,
                      byId: _authProvider.currentUser!.id!,
                      report: "Adult Content",
                    );
                  } catch (e) {
                    toast("Unabe to report!");
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_with_rounded),
                title: const Text("Others"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
