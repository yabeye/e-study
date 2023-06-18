import 'package:e_study_app/src/common/extensions/string_extensions.dart';
import 'package:e_study_app/src/helpers/ui_helpers.dart';
import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/screens/question/answer_card.dart';
import 'package:e_study_app/src/screens/question/update_questions.dart';
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
import '../search/hashtag_result.dart';
import '../splash_screeen.dart';

class QuestionDetail extends StatefulWidget {
  QuestionDetail({super.key, required this.question});

  Question question;

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  late final AuthProvider _authProvider;
  late final QuestionProvider _questionProvider;
  late final TextEditingController _answerController;
  final TextEditingController _commentController = TextEditingController();

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
    _commentController.dispose();
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
      _authProvider.clear();
      const SplashScreen().launch(context, isNewTask: true);
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
      _authProvider.clear();
      const SplashScreen().launch(context, isNewTask: true);
      toasty(context, e.message);
    } on FetchDataException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      toasty(context, "We are unable to do that!");
    }
  }

  addComment() async {
    try {
      final updatedQn = await _questionProvider.updateQuestion(
        id: question.id,
        comment: _commentController.text,
      );

      _commentController.text = "";

      question = updatedQn;
      setState(() {});
    } on BadRequestException catch (e) {
      toasty(context, e.message);
    } on UnAuthorizedException catch (e) {
      _authProvider.clear();
      const SplashScreen().launch(context, isNewTask: true);
      toasty(context, e.message);
    } on FetchDataException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      toasty(context, "We are unable to do that!");
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.question.answers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final askedBy = question.askedBy;
    bool isOwner = askedBy.id ==
        (_authProvider.currentUser == null
            ? 'abc'
            : _authProvider.currentUser!.id);

    bool isAuth = _authProvider.currentUser != null;

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
            ).visible(isAuth),
            IconButton(
              onPressed: () => confirm(
                context,
                message: "Are you sure you want to delete this question?",
                () async {
                  try {
                    await _questionProvider.deleteQuestion(id: question.id);
                    // ignore: use_build_context_synchronously
                    context.pop();
                    toast("Question deleted successfully!");
                  } catch (e) {
                    toast("Unable to delete the question!");
                    print(e.toString());
                  }
                },
              ),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ).visible(isOwner)
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
        // SliverToBoxAdapter(
        //   child: question.hashTags.isNotEmpty
        //       ? TextScroll(
        //           question.hashTags.map((e) => "#$e").toList().join(" "),
        //           velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
        //           style: secondaryTextStyle(
        //             backgroundColor: Colors.grey.shade200,
        //             color: Colors.black,
        //           ),
        //           fadedBorderWidth: .5,
        //         )
        //       : Container(),
        // ),
        SliverToBoxAdapter(
          child: question.hashTags.isNotEmpty
              ? SizedBox(
                  height: 40,
                  width: context.width() * .9,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: question.hashTags.length,
                      itemBuilder: (c, i) {
                        return InkWell(
                          onTap: () {
                            HashTagResult(
                              hashKey: question.hashTags[i],
                            ).launch(context, isNewTask: false);
                          },
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                ),
                                child: Text("#${question.hashTags[i]}")),
                          ).paddingSymmetric(horizontal: 8),
                        );
                      }),
                )
              : Container(),
        ),
        SliverToBoxAdapter(
          child: 15.height,
        ),
        SliverToBoxAdapter(
          child: !(isAuth && isOwner)
              ? null
              : Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      UpdateQuestion(question: question)
                          .launch(context, isNewTask: false);
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
              ).visible(isAuth),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: 5.height,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => Text("- ${question.comments[index]}"),
            childCount: question.comments.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              5.height,
              TextField(
                controller: _commentController,
                // minLines: 4,
                style: boldTextStyle(
                  weight: FontWeight.normal,
                ),
                decoration: inputDecoration(
                  context,
                  hintText: "Add clarification comment  ... ",
                  hintStyle: secondaryTextStyle(),
                ),
                // maxLines: 3, //or null
                onSubmitted: (v) {
                  hideKeyboard(context);
                },
              ),
              10.height,
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  onTap: _isLoading ? null : addComment,
                  text: _isLoading ? "..." : "Add Comment",
                  textStyle: const TextStyle(),
                ),
              ),
              5.height,
            ],
          ).visible(isAuth),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const Divider(),
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
              answer: question.answers[index],
            ),
            childCount: question.answers.length,
            // childCount: _availableHandyMen.length,
          ),
        ),
        SliverToBoxAdapter(
          child: !isAuth
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
                          onTap: _isLoading ? null : _answerQuestion,
                          disabledColor: loadingColor,
                          text: 'Add Answer',
                          textColor: whiteColor,
                          color: primaryColor,
                          width: context.width() * .1,
                        ),
                      ],
                    ),
                    5.height,
                  ],
                ),
        ),
      ]).paddingSymmetric(horizontal: 12),
    );
  }

  reported(String report) async {
    try {
      await _questionProvider.reportQuestion(
        id: question.id,
        byId: _authProvider.currentUser!.id!,
        report: report,
      );
      toasty(context, "Question Reported! ");
    } catch (e) {
      toast("Unable to report!");
    }
    Navigator.pop(context);
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
                  await reported("Non Educational");
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_calls),
                title: const Text("Spam"),
                onTap: () async {
                  await reported("Spam");
                },
              ),
              ListTile(
                leading: const Icon(Icons.sports_martial_arts),
                title: const Text("Violence"),
                onTap: () async {
                  await reported("Violence");
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_box_sharp),
                title: const Text("Adult Content"),
                onTap: () async {
                  await reported("Adult Content");
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_with_rounded),
                title: const Text("Others"),
                onTap: () async {
                  await reported("Others");
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
