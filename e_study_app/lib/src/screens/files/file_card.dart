import 'package:e_study_app/src/models/answer.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../../models/files.dart';
import '../../models/user.model.dart';
import '../../widgets/common_ui.dart';

class FileCard extends StatelessWidget {
  const FileCard({
    super.key,
    required this.currentFile,
  });
  final FileModel currentFile;

  @override
  Widget build(BuildContext context) {
    final uploadedBy = currentFile.uploadedBy;
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
                    child: uploadedBy.profilePic == null
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
                            url: uploadedBy.profilePic!,
                            height: 50,
                          ),
                  ).paddingSymmetric(horizontal: 4),
                  Text(
                    (uploadedBy.username ?? ""),
                    style: secondaryTextStyle(),
                  ).paddingSymmetric(vertical: 8),
                ],
              ),
              Text(
                currentFile.createdAt.timeAgo,
                style: secondaryTextStyle(),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              currentFile.name,
              style: primaryTextStyle(
                size: textSecondarySizeGlobal.toInt(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentFile.category,
                style: secondaryTextStyle(),
              ),
              TextButton.icon(
                onPressed: () {
                  toast("Downloading a file ...");
                },
                icon: const Icon(Icons.download),
                label: Text('Download (${currentFile.size})'),
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 8),
    );
  }
}
