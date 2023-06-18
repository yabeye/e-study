import 'package:e_study_app/src/api/api_provider.dart';
import 'package:e_study_app/src/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../../models/file_model.dart';
import '../../widgets/common_ui.dart';

class FileCard extends StatefulWidget {
  const FileCard({
    super.key,
    required this.currentFile,
  });
  final FileModel currentFile;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  late final QuestionProvider _questionProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();
  }

  void _downloadFile() async {
    _isLoading = true;
    setState(() {});
    try {
      final filePath = await _questionProvider.downloadFile(
          fileName: widget.currentFile.path);
      toasty(context, 'File downloaded to $filePath');
    } catch (e) {
      toasty(context, 'Unable to download a file!');
      print(e.toString());
    }
    _isLoading = false;
    setState(() {});
    // FileDownloader.downloadFile(
    //     url:
    //         "https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Npm-logo.svg/1200px-Npm-logo.svg.png",
    //     // url: "${ApiProvider.publicUrl}uploads/images/logo.png",
    //     onProgress: (name, progress) {
    //       _isLoading = true;
    //       setState(() {});
    //     },
    //     onDownloadCompleted: (value) {
    //       _isLoading = false;
    //       setState(() {});
    //       // toast("File has been downloaded!");
    //       toasty(context, "File has been downloaded!");
    //       print('path  $value ');
    //       // setState(() {
    //       //   _progress = null;
    //       // });
    //     },
    //     onDownloadError: (errorMessage) {
    //       _isLoading = false;
    //       setState(() {});
    //       toast(errorMessage);
    //     });

    // try {
    //   await _questionProvider.downloadFile();
    // } catch (e) {
    //   toast(e.toString());
    //   print("Error: ${e.toString()}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    final uploadedBy = widget.currentFile.uploadedBy;
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
                widget.currentFile.createdAt.timeAgo,
                style: secondaryTextStyle(),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.currentFile.name,
              style: primaryTextStyle(
                size: textSecondarySizeGlobal.toInt(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.currentFile.category,
                style: secondaryTextStyle(),
              ),
              TextButton.icon(
                onPressed: _isLoading ? null : _downloadFile,
                icon: const Icon(Icons.download),
                label: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Download'),
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 8),
    );
  }
}
