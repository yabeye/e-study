import 'package:e_study_app/src/api/exceptions.dart';
import 'package:e_study_app/src/common/constants.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:e_study_app/src/providers/auth_provider.dart';
import 'package:e_study_app/src/providers/question_provider.dart';
import 'package:e_study_app/src/theme/theme.dart';
import 'package:e_study_app/src/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../splash_screeen.dart';

class UpdateQuestion extends StatefulWidget {
  const UpdateQuestion({super.key, required this.question});
  final Question question;

  @override
  State<UpdateQuestion> createState() => _UpdateQuestionState();
}

class _UpdateQuestionState extends State<UpdateQuestion> {
  late final QuestionProvider _questionProvider;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _hashTagController = TextEditingController();
  String _selectedCategory = categories[1];
  String _selectedSubject = "";
  bool _isLoading = false;

  List<String> _subjects = naturalCategories;

  bool _isCategoryError = false;
  late Question question;

  @override
  void initState() {
    super.initState();
    _questionProvider = context.read<QuestionProvider>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    question = widget.question;
    afterBuildCreated(() {
      _selectedCategory = question.category;
      _selectedSubject = question.subject;
      _titleController.text = question.title;
      _descriptionController.text = question.description;
      _hashTagController.text = (question.hashTags).join(",");
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hashTagController.dispose();
    super.dispose();
  }

  updateQuestion() async {
    _isLoading = true;
    setState(() {});
    try {
      await _questionProvider.updateQuestion(
        id: question.id,
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        subject: _selectedSubject,
        hashTags: _hashTagController.text,
      );
      // ignore: use_build_context_synchronously
      context.pop();
      context.pop();
      // ignore: use_build_context_synchronously
      toasty(context, "Updated Successfully!");
    } on BadRequestException catch (e) {
      toasty(context, e.message);
    } on UnAuthorizedException catch (e) {
      final _authProvider = Provider.of<AuthProvider>(context);
      _authProvider.clear();
      const SplashScreen().launch(context, isNewTask: true);
      toasty(context, e.message);
    } on FetchDataException catch (e) {
      toasty(context, e.message);
    } catch (e) {
      toasty(context, "We are unable to do that!");
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Ask Question", showBack: true),
      body: ListView(
        children: [
          20.height,
          Text(
            "Update Question",
            style: boldTextStyle(),
          ),
          10.height,
          // CommonDropDownComponent(
          //   defaultValue: _selectedCategory,
          //   items: categories.skip(1).toList(),
          //   placeholder: "Select Category",
          //   callback: (v) {
          //     toast(v);
          //     _selectedCategory = v!;
          //     // Filtering out the subject based on the current selected subject

          //     switch (_selectedCategory) {
          //       case "Natural":
          //         _subjects = naturalCategories;
          //         break;
          //       case "Social":
          //         _subjects = socialCategories;
          //         break;
          //       case "Others":
          //         _subjects = otherCategories;
          //         break;
          //       default:
          //         _subjects = naturalCategories;
          //         break;
          //     }
          //     setState(() {});
          //   },
          // ),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select Category",
              style: secondaryTextStyle(color: redColor),
            ),
          ).visible(_isCategoryError),
          10.height,
          // CommonDropDownComponent(
          //   defaultValue: _selectedSubject,
          //   items: naturalCategories,
          //   placeholder: "Select Subject",
          //   callback: (v) {
          //     _selectedSubject = v!;

          //     setState(() {});
          //   },
          // ).visible(_selectedCategory == "Natural"),
          // CommonDropDownComponent(
          //   defaultValue: _selectedSubject,
          //   items: socialCategories,
          //   placeholder: "Select Subject",
          //   callback: (v) {
          //     _selectedSubject = v!;
          //     setState(() {});
          //   },
          // ).visible(_selectedCategory == "Social"),
          // CommonDropDownComponent(
          //   defaultValue: _selectedSubject,
          //   items: otherCategories,
          //   placeholder: "Select Subject",
          //   callback: (v) {
          //     _selectedSubject = v!;

          //     setState(() {});
          //   },
          // ).visible(_selectedCategory == "Others"),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select Subject",
              style: secondaryTextStyle(color: redColor),
            ),
          ).visible(_isCategoryError),
          10.height,
          Form(
            child: Column(
              children: [
                TextFormField(
                  // autofocus: true,
                  controller: _titleController,
                  style: boldTextStyle(
                    weight: FontWeight.normal,
                  ),
                  decoration: inputDecoration(
                    context,
                    hintText: "Title",
                    hintStyle: secondaryTextStyle(),
                  ),
                  maxLines: 3,
                  onFieldSubmitted: (v) {
                    hideKeyboard(context);
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "Add a title";
                    }
                    return null;
                  },
                ),
                10.height,
                TextFormField(
                  // autofocus: true,
                  controller: _descriptionController,
                  style: boldTextStyle(
                    weight: FontWeight.normal,
                  ),
                  decoration: inputDecoration(
                    context,
                    hintText: "Description",
                    hintStyle: secondaryTextStyle(),
                  ),
                  maxLines: 3,
                  onFieldSubmitted: (v) {
                    hideKeyboard(context);
                  },
                  validator: (v) {
                    if (v!.isEmpty || v.length < 10) {
                      return "Add 10 words for description";
                    }
                    return null;
                  },
                ),
                20.height,
                TextFormField(
                  // autofocus: true,
                  controller: _hashTagController,
                  style: boldTextStyle(
                    weight: FontWeight.normal,
                  ),
                  decoration: inputDecoration(
                    context,
                    hintText: "Hash Tags Comma Septate",
                    hintStyle: secondaryTextStyle(),
                  ),
                  onFieldSubmitted: (v) {
                    hideKeyboard(context);
                  },
                ),
                20.height,
                AppButton(
                  onTap: _isLoading ? null : updateQuestion,
                  text: "Update Question",
                  textColor: whiteColor,
                  color: primaryColor,
                  width: context.width(),
                )
              ],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 12),
    );
  }
}
