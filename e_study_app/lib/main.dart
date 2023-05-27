import 'package:e_study_app/src/providers/auth_provider.dart';
import 'package:e_study_app/src/providers/question_provider.dart';
import 'package:e_study_app/src/screens/splash_screeen.dart';
import 'package:e_study_app/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:e_study_app/src/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  // Initialize stuff
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthProvider>(create: (_) => AuthProvider()),
        Provider<QuestionProvider>(create: (_) => QuestionProvider()),
      ],
      child: MaterialApp(
        title: 'EStudy App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}
