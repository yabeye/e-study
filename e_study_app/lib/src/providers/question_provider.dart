import 'package:e_study_app/src/models/answer.model.dart';
import 'package:e_study_app/src/models/file_model.dart';
import 'package:e_study_app/src/models/question.model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:http/http.dart' as http;

import '../api/api_provider.dart';

import 'package:http/http.dart' as http;

class QuestionProvider extends ChangeNotifier {
  final _provider = ApiProvider();
  List<Question> questions = [];
  List<FileModel> files = [
    // FileModel(
    //   name: "2012 Biology Model Exam for Bethelehem Secondary School",
    //   size: "22MB",
    //   category: categories[1],
    //   uploadedBy: User(
    //     id: "id",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     email: "email",
    //     phone: "phone",
    //     username: "liya",
    //     roles: "roles",
    //     question: [],
    //     answer: [],
    //     bookmarks: [],
    //   ),
    //   createdAt: DateTime.now(),
    // ),
    // FileModel(
    //   name: "Math Note on Trigonometry",
    //   size: "12MB",
    //   category: categories[3],
    //   uploadedBy: User(
    //     id: "id",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     email: "email",
    //     phone: "phone",
    //     username: "dimond",
    //     roles: "roles",
    //     question: [],
    //     answer: [],
    //     bookmarks: [],
    //   ),
    //   createdAt: DateTime.now(),
    // ),
    // FileModel(
    //   name: "2010 Mathematics Model Exam for Bethelehem Secondary School",
    //   size: "55MB",
    //   category: categories[3],
    //   uploadedBy: User(
    //     id: "id",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     email: "email",
    //     phone: "phone",
    //     username: "yeabsera",
    //     roles: "roles",
    //     question: [],
    //     answer: [],
    //     bookmarks: [],
    //   ),
    //   createdAt: DateTime.now(),
    // ),
    // FileModel(
    //   name: "2014 Grade 12 National Civics Exam Preparation test",
    //   size: "5MB",
    //   category: categories[2],
    //   uploadedBy: User(
    //     id: "id",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     email: "email",
    //     phone: "phone",
    //     username: "abel",
    //     roles: "roles",
    //     question: [],
    //     answer: [],
    //     bookmarks: [],
    //   ),
    //   createdAt: DateTime.now(),
    // ),
  ];

  Future<void> getQuestions() async {
    var response = await _provider.get("questions/all");
    var resQuestions = response['data']['questions'];
    clear();
    for (int i = 0; i < resQuestions.length; i++) {
      final q = Question.fromJson(resQuestions[i]);
      if (q.isActive == true) {
        questions.add(q);
      }
    }

    response = await _provider.get("files/all");
    resQuestions = response['data']['files'];

    for (int i = 0; i < resQuestions.length; i++) {
      files.add(FileModel.fromJson(resQuestions[i]));
    }
    files.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> addNewQuestions({
    required String title,
    required String description,
    required String category,
    required String subject,
    required String hashTags,
  }) async {
    await _provider.post("questions/ask", {
      "title": title,
      "description": description,
      "category": category,
      "subject": subject,
      "hashTags": hashTags,
    });
  }

  Future<void> deleteQuestion({
    required String id,
  }) async {
    await _provider.delete("questions/$id");
  }

  Future updateQuestion({
    String? id,
    String? title,
    String? description,
    String? category,
    String? subject,
    String? hashTags,
    String? comment,
  }) async {
    final response = await _provider.patch(
      "questions/$id",
      {
        "title": title,
        "description": description,
        "category": category,
        "subject": subject,
        "hashTags": hashTags,
        "comment": comment
      },
    );
    final resQuestions = response['data']['question'];
    await getQuestions();

    return Question.fromJson(resQuestions);
  }

  Future<void> uploadFile({
    required PlatformFile file,
    required String category,
    required String name,
  }) async {
    final String baseUrl = ApiProvider.baseUrl;
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
    String? token = (pref.getString('token'));
    String url = '$baseUrl/files/upload';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files
        .add(await http.MultipartFile.fromPath('file', file.path ?? ""));
    request.headers.addAll({'Authorization': 'Bearer ${token ?? ""}'});

    request.fields['category'] = category;
    request.fields['name'] = name;

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully!');
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  // // Function for downloading a file
  // Future<void> downloadFile(
  //     {Stri}) async {
  //   final httpClient = http.Client();
  //   final request = http.Request('GET', Uri.parse(url));
  //   final response = await httpClient.send(request);

  //   // Get the app's documents directory to store the downloaded file
  //   final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  //   final file = File('${appDocumentsDirectory.path}/downloaded_file');

  //   // Open a stream to write the file to the app's documents directory
  //   final fileStream = file.openWrite();

  //   // Stream the response body into the file stream
  //   await response.stream.forEach((chunk) {
  //     fileStream.write(chunk);
  //   });

  //   // Close the streams to free up resources
  //   await fileStream.flush();
  //   await fileStream.close();
  //   await response.stream.drain();

  //   print('File downloaded successfully!');
  // }

  Future<Answer> addAnswer({
    required String id,
    required String content,
  }) async {
    final response = await _provider.post("answers/$id", {
      "content": content,
    });
    final resQuestions = response['data']['answer'];

    return Answer.fromJson(resQuestions);
  }

  Future<Question> voteQuestion({required String id, bool? voting}) async {
    final response = await _provider.patch("questions/$id", {
      "voting": voting,
    });

    final resQuestions = response['data']['question'];

    await getQuestions();

    return Question.fromJson(resQuestions);
  }

  Future<Question> reportQuestion({
    required String id,
    required String byId,
    required String report,
  }) async {
    final response = await _provider.patch("questions/$id", {
      "reportedBy": {
        "by": byId,
        "report": report,
      },
    });

    final resQuestions = response['data']['question'];

    await getQuestions();

    return Question.fromJson(resQuestions);
  }

  void clear() {
    questions = [];
    files = [];
    notifyListeners();
  }
}
