import 'package:e_study_app/src/models/answer.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../../models/user.model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_ui.dart';

class AnswerCard extends StatefulWidget {
  const AnswerCard({super.key, required this.answer});
  final Answer answer;

  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  late final _authProvider;
  User? askedBy;

  @override
  void initState() {
    super.initState();

    _authProvider = context.read<AuthProvider>();
    getUser();
  }

  getUser() async {
    try {
      askedBy = await _authProvider.getUser(widget.answer.answeredBy);
      print("Asked by is ${askedBy!.username}");
      setState(() {});
    } catch (e) {
      toasty(context, "User not found!");
      // context.pop();
      print("ERR $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: radius(),
        color: secondaryColor,
      ),
      child: askedBy == null
          ? Loader()
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          child: askedBy!.profilePic == null
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
                                  url: askedBy!.profilePic!,
                                  height: 50,
                                ),
                        ).paddingSymmetric(horizontal: 4),
                        Text(
                          (askedBy!.username ?? ""),
                          style: secondaryTextStyle(),
                        ).paddingSymmetric(vertical: 8),
                      ],
                    ),
                    Text(
                      widget.answer.createdAt.timeAgo,
                      style: secondaryTextStyle(),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.answer.content,
                    style: primaryTextStyle(
                      size: textSecondarySizeGlobal.toInt(),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 4),
                20.height,
              ],
            ).paddingSymmetric(horizontal: 8),
    );
  }
}
