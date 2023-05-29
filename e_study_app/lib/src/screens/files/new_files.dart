import 'dart:math';

import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/theme/theme.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NewFileScreen extends StatefulWidget {
  const NewFileScreen({super.key});

  @override
  State<NewFileScreen> createState() => _NewFileScreenState();
}

class _NewFileScreenState extends State<NewFileScreen> {
  String? _fileName;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _isCategoryError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _openFileExplorer() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _nameController.text =
            _fileName ?? "unnamed (${Random().nextInt(1000000)})";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Upload File", showBack: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.height,
            Text(
              "Upload a new File",
              style: boldTextStyle(),
            ),
            10.height,
            Text(
              "Please make sure that files are less than 50MB\nFormats(.pdf, .doc, .xsl, .ppts, and images)",
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            30.height,
            CommonDropDownComponent(
              items: categories.skip(1).toList(),
              defaultValue: "Natural",
              placeholder: "Select Category",
              callback: (v) {
                toast(v);
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Category",
                style: secondaryTextStyle(color: redColor),
              ),
            ).visible(_isCategoryError),
            10.height,
            TextField(
              // autofocus: true,
              controller: _nameController,
              style: boldTextStyle(
                weight: FontWeight.normal,
                color: blackColor,
              ),
              decoration: inputDecoration(
                context,
                hintText: "File name (Optional)",
                hintStyle: secondaryTextStyle(),
              ),
              maxLines: 3,
              onSubmitted: (v) {
                hideKeyboard(context);
              },
            ),
            20.height,
            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                border: Border.all(
                  color: primaryColor,
                ),
              ),
              child: AppButton(
                onTap: _openFileExplorer,
                text: "Select File",
                textColor: primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.file_present_outlined,
                      color: gray,
                    ),
                    Text(
                      "Select File",
                      style: secondaryTextStyle(),
                    )
                  ],
                ),
              ),
            ),
            50.height,
            AppButton(
              onTap: () {
                toasty(
                  context,
                  "File has been uploaded!, it will be live once it has been reviewed! ",
                  length: Toast.LENGTH_LONG,
                );
              },
              text: "Upload",
              textColor: whiteColor,
              color: primaryColor,
              width: context.width(),
            ),
          ],
        ).paddingSymmetric(horizontal: 12),
      ),
    );
  }
}
