import 'package:e_study_app/src/common/extensions/string_extensions.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/screens/question/answer_card.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';

class QuestionDetail extends StatefulWidget {
  const QuestionDetail({super.key, required this.question});

  final Question question;

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  @override
  Widget build(BuildContext context) {
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
                  svgUpVoteSelected.svgImage(size: 32, color: black),
                  const SizedBox().paddingSymmetric(horizontal: 2),
                  Text(
                    "1",
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
