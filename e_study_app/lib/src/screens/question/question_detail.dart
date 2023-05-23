import 'dart:io';

import 'package:e_study_app/src/common/extensions/string_extensions.dart';
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
import '../../providers/question_provider.dart';
import '../../theme/theme.dart';

class QuestionDetail extends StatefulWidget {
  const QuestionDetail({super.key, required this.question});

  final Question question;

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  late final QuestionProvider _questionProvider;
  late final TextEditingController _answerController;
  FocusNode _answerFocus = FocusNode(); //create focus node

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();
    _answerController = TextEditingController();
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
    } on SocketException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      print(e.toString());
      toasty(context, "We are unable to do that!");
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.question.answers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final question = widget.question;
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
            const Icon(
              Icons.more_vert,
              color: whiteColor,
            ),
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
                  question.hashTags.map((e) => "#" + e).toList().join(" "),
                  velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                  style: secondaryTextStyle(),
                )
              : Container(),
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
                  svgUpVote.svgImage(size: 32, color: black),
                  const SizedBox().paddingSymmetric(horizontal: 2),
                  Text(
                    "0",
                    style: secondaryTextStyle(),
                  ),
                  const SizedBox().paddingSymmetric(horizontal: 16),
                  svgDownVote.svgImage(size: 32, color: black),
                  const SizedBox().paddingSymmetric(horizontal: 2),
                  Text(
                    "0",
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
          child: 5.height,
        ),
        SliverToBoxAdapter(
          child: TextField(
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
        ),
        SliverToBoxAdapter(
          child: 5.height,
        ),
        SliverToBoxAdapter(
          child: Row(
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
        ),
        SliverToBoxAdapter(
          child: 5.height,
        ),
        SliverToBoxAdapter(
          child: Text(
            "Answers (${question.answers.length})",
            style: primaryTextStyle(),
          ),
        ),
        SliverToBoxAdapter(
          child: 15.height,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => AnswerCard(
              answer: question.answers[index],
              askedBy: askedBy,
            ),
            childCount: question.answers.length,
            // childCount: _availableHandyMen.length,
          ),
        ),
      ]).paddingSymmetric(horizontal: 12),
    );
  }
}