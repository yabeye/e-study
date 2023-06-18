import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_study_app/src/api/api_provider.dart';
import 'package:e_study_app/src/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../common/asset_locations.dart';
import '../../common/constants.dart';
import '../../helpers/ui_helpers.dart';
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

  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();
  }

  Future<bool> saveVideo(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/E Study";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File("${directory.path}/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        // await dio.download(url, saveFile.path,
        //     onReceiveProgress: (value1, value2) {
        //   setState(() {
        //     progress = value1 / value2;
        //   });
        // });
        final File file = await _questionProvider.downloadFile(
          fileName: widget.currentFile.path,
          path: saveFile.path,
        );
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }

        // try {
        //   await OpenFile.open(saveFile.path);
        // } catch (e) {
        //   toasty(context, "Unable to opena file!");
        // }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadFile() async {
    setState(() {
      loading = true;
      progress = 0;
    });
    // String url =
    //     "https://e-study-api.vercel.app/api/files/allFiles/sodapdf-converted.pdf%201687074314943";
    // await appLaunchUrl(url);

    bool downloaded = await saveVideo(
      "${ApiProvider.baseUrl}/allFiles/${widget.currentFile.path}",
      widget.currentFile.path
          .split(" ")
          .sublist(0, widget.currentFile.path.split(" ").length - 1)
          .join(""),
    );

    toasty(context, "File Downloaded");
    // if (downloaded) {
    // } else {
    //   toasty(context, "Problem Downloading File");
    // }
    setState(() {
      loading = false;
    });
  }

  void _downloadFile() async {
    _isLoading = true;
    setState(() {});
    try {
      await downloadFile();
      // final File file = await _questionProvider.downloadFile(
      //   fileName: widget.currentFile.path,
      // );

      // await openFile();
      // toasty(context, 'File downloaded to $filePath');
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



  // downloadFile(String url, String name) async {
  //   try {
  //     final appStorage = await getApplicationDocumentsDirectory();
  //     final file = File('/${appStorage.path}/$name');

  //     final response = await Dio().get(url,
  //         options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           // receiveTimeout: Duration(seconds: 0),
  //         ));

  //     final raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(response.data);
  //     await raf.close();
  //     print("Print path is ${file.absolute}");
  //     return file;
  //   } catch (e) {
  //     toast("HERE!");
  //   }
  // }

  // Future<void> openFile() async {
  //   String url = "https://web.stanford.edu/group/csp/cs21/htmlcheatsheet.pdf";
  //   String name = "Cell-part.pdf";
  //   final File? file = await downloadFile(url, name);
  //   if (file == null) return;
  //   debugPrint("File path ${file.path}");
  //   await OpenFile.open(file.path, type: "pdf");
  // }