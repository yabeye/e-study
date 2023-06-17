import 'package:e_study_app/src/common/asset_locations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../common/constants.dart';

class AppBottomNavBar extends StatelessWidget {
  final int page;
  final void Function(int) onPageChange;

  const AppBottomNavBar({
    super.key,
    required this.page,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: grey,
            width: 0.3,
          ),
        ),
      ),
      child: CupertinoTabBar(
        currentIndex: page,
        onTap: (pg) {
          onPageChange(pg);
        },
        backgroundColor: backgroundColor,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.question_answer_outlined,
              color: white,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.question_answer,
              color: white,
              size: 30,
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.file_copy_outlined,
              color: white,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.file_copy,
              color: white,
              size: 30,
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: white,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.search,
              color: white,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              svgUser,
              color: whiteColor,
              width: 30,
              height: 30,
            ),
            activeIcon: SvgPicture.asset(
              svgUserSelected,
              color: whiteColor,
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
