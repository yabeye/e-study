import 'package:e_study_app/src/models/answer.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../../models/user.model.dart';
import '../../widgets/common_ui.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({super.key, required this.answer, required this.askedBy});
  final Answer answer;
  final User askedBy;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: radius(),
        color: secondaryColor,
      ),
      child: Column(
        children: [
          Row(
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
                    ("yeabsera" ?? askedBy.username ?? ""),
                    style: secondaryTextStyle(),
                  ).paddingSymmetric(vertical: 8),
                ],
              ),
              Text(
                answer.createdAt.timeAgo,
                style: secondaryTextStyle(),
              )
            ],
          ),
          Text(
            answer.content,
            style: primaryTextStyle(
              size: textSecondarySizeGlobal.toInt(),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 8),
    );
  }
}
