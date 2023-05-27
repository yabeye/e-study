import 'package:e_study_app/src/screens/files/files_screen.dart';
import 'package:e_study_app/src/screens/home/home_screen.dart';
import 'package:e_study_app/src/screens/profille/profile_screen.dart';
import 'package:e_study_app/src/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/common_ui.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final AuthProvider _authProvider;
  int _page = 0;
  late final ValueNotifier<bool> _isDialOpen;

  @override
  void initState() {
    _isDialOpen = ValueNotifier<bool>(false);
    _authProvider = context.read<AuthProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _isDialOpen.dispose();
    super.dispose();
  }

  void _onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  _onCreate() {}

  @override
  Widget build(BuildContext context) {
    print("CHECCK___ ${_authProvider.isLoggedIn}");
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: AppBottomNavBar(
        page: _page,
        onPageChange: (x) => _onPageChange(x),
      ),
      floatingActionButton: _authProvider.token == null || _page == 3
          ? null
          : AppFloatingButton(
              isDialOpen: _isDialOpen,
              onCreatePost: _onCreate,
            ),
    );
  }

  Widget _getBody() {
    switch (_page) {
      case 0:
        return const HomeScreen();
      case 1:
        return const FilesScreen();
      case 2:
        return const SearchScreen();
      case 3:
        return const ProfileScreen();

      default:
        return Center(
            child: Text(
          "Unknown Page!",
          style: boldTextStyle(size: 22, color: Colors.white),
        ));
    }
  }
}
