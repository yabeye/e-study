import 'dart:math';

import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/providers/question_provider.dart';
import 'package:e_study_app/src/theme/theme.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class NewFileScreen extends StatefulWidget {
  const NewFileScreen({super.key});

  @override
  State<NewFileScreen> createState() => _NewFileScreenState();
}

class _NewFileScreenState extends State<NewFileScreen> {
  String? _fileName;
  late final QuestionProvider _questionProvider;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _isCategoryError = false;

  String _selectedCategory = "Natural";
  PlatformFile? file;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _descriptionController.dispose();
  //   super.dispose();
  // }

  void _openFileExplorer() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      if (result.files.isNotEmpty) {
        file = result.files[0];
        setState(() {
          _fileName = result.files.single.name;
          _nameController.text =
              _fileName ?? "unnamed (${Random().nextInt(1000000)})";
        });
      }
    }
  }

  _uploadFile() async {
    try {
      if (file == null) {
        toast("Select a file!");
        return;
      }
      await _questionProvider.uploadFile(
        file: file!,
        category: _selectedCategory,
        name: _nameController.text,
      );
      context.pop();
      toasty(context, "File uploaded successfully!");
    } catch (e) {}
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
                _selectedCategory = v ?? "Natural";
                setState(() {});
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
              onTap: _uploadFile,
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
