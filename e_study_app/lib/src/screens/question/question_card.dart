import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/common/extensions/string_extensions.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/screens/question/question_detail.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../common/asset_locations.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    this.withCategoryTag = true,
  });

  final Question question;
  final bool withCategoryTag;

  @override
  Widget build(BuildContext context) {
    final askedBy = question.askedBy;
    return InkWell(
      onTap: () {
        QuestionDetail(
          question: question,
        ).launch(context, isNewTask: false);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryColorLight,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(defaultRadius),
              ),
            ),
            child: Text(
              question.category,
              style: boldTextStyle(color: white),
            ).paddingSymmetric(horizontal: 8),
          ).visible(withCategoryTag),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: radius(),
              color: secondaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    question.createdAt.timeAgo,
                    style: secondaryTextStyle(size: 10),
                  ),
                ),
                Text(
                  question.title.length > 60
                      ? "${question.title.substring(0, 60)} ..."
                      : question.title,
                  style: primaryTextStyle(size: 20),
                ),
                10.height,
                if (question.hashTags.isNotEmpty) ...[
                  TextScroll(
                    question.hashTags.map((e) => "#" + e).toList().join(" "),
                    velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                    style: secondaryTextStyle(),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          child: askedBy.profilePic == null
                              ? Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
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
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            svgComment.svgImage(size: 12, color: black),
                            const SizedBox().paddingSymmetric(horizontal: 2),
                            Text(
                              "${question.answers.length} Ans",
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                        const SizedBox().paddingSymmetric(horizontal: 16),
                        Row(
                          children: [
                            svgUpVote.svgImage(size: 12, color: black),
                            Text(
                              question.voteCount.length.toString(),
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                        const SizedBox().paddingSymmetric(horizontal: 4),
                        Row(
                          children: [
                            svgDownVote.svgImage(size: 12, color: black),
                            Text(
                              question.voteCountDown.length.toString(),
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ).paddingLeft(12),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
