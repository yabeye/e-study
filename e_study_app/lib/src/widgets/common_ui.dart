import 'package:e_study_app/src/screens/files/new_files.dart';
import 'package:e_study_app/src/screens/question/new_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:e_study_app/src/common/asset_locations.dart';
import '../common/constants.dart';
import '../theme/theme.dart';

class BackWidget extends StatelessWidget {
  final Function()? onPressed;
  final Color? iconColor;

  const BackWidget({super.key, this.onPressed, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => finish(context),
      child: Icon(
        Icons.arrow_back_ios,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final String? placeHolderImage;
  final AlignmentGeometry? alignment;
  final bool usePlaceholderIfUrlEmpty;
  final bool circle;
  final double? radius;

  const CachedImageWidget({
    super.key,
    required this.url,
    required this.height,
    this.width,
    this.fit,
    this.color,
    this.placeHolderImage,
    this.alignment,
    this.radius,
    this.usePlaceholderIfUrlEmpty = true,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (url.validate().isEmpty) {
      return Container(
        height: height,
        width: width ?? height,
        color: color ?? grey.withOpacity(0.1),
        alignment: alignment,
        //padding: EdgeInsets.all(10),
        //child: Image.asset(ic_no_photo, color: appStore.isDarkMode ? Colors.white : Colors.black),
        child: PlaceHolderWidget(
          height: height,
          width: width,
          alignment: alignment ?? Alignment.center,
        ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    } else if (url.validate().startsWith('http')) {
      return CachedNetworkImage(
        placeholder: (_, __) {
          return PlaceHolderWidget(
            height: height,
            width: width,
            alignment: alignment ?? Alignment.center,
          ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
        },
        imageUrl: url,
        height: height,
        width: width ?? height,
        fit: fit,
        color: color,
        alignment: alignment as Alignment? ?? Alignment.center,
        errorWidget: (_, s, d) {
          return PlaceHolderWidget(
            height: height,
            width: width,
            alignment: alignment ?? Alignment.center,
          ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
        },
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    } else {
      return Image.asset(
        url,
        height: height,
        width: width ?? height,
        fit: fit,
        color: color,
        alignment: alignment ?? Alignment.center,
        errorBuilder: (_, s, d) {
          return PlaceHolderWidget(
            height: height,
            width: width,
            alignment: alignment ?? Alignment.center,
          ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
        },
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    }
  }
}

class CommonDropDownComponent extends StatefulWidget {
  const CommonDropDownComponent({
    Key? key,
    required this.items,
    this.defaultValue,
    this.placeholder,
    required this.callback,
  }) : super(key: key);

  final List<String> items;
  final String? defaultValue;
  final String? placeholder;
  final void Function(String?) callback;

  @override
  State<CommonDropDownComponent> createState() =>
      _CommonDropDownComponentState();
}

class _CommonDropDownComponentState extends State<CommonDropDownComponent> {
  List<String> _items = [];
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    assert(widget.items.isNotEmpty);
    _items = widget.items;
    if (!widget.defaultValue.isEmptyOrNull) {
      _selectedValue = widget.defaultValue;
    }
    if (_items.length == 1) {
      _selectedValue = _items[0]; // Since we have only one option!
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
          // isExpanded: true,
          value: _selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: inputDecoration(context, labelText: widget.placeholder),
          dropdownColor: context.cardColor,
          alignment: Alignment.bottomCenter,
          items: _items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: SizedBox(
                width: context.width() * .5,
                child: Text(
                  item,
                  style: boldTextStyle(
                    weight: FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            widget.callback(newValue);
          },
        ),
      ],
    );
  }
}

class AppFloatingButton extends StatelessWidget {
  final ValueNotifier<bool> isDialOpen;
  final VoidCallback onCreatePost;

  const AppFloatingButton({
    super.key,
    required this.isDialOpen,
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      activeChild: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      activeIcon: Icons.close,
      spacing: 3,
      openCloseDial: isDialOpen,
      spaceBetweenChildren: 4,
      iconTheme: const IconThemeData(size: 32, color: Colors.white),
      labelTransitionBuilder: (widget, animation) =>
          ScaleTransition(scale: animation, child: widget),
      // childrenButtonSize: const Size(40.0, 70.0),
      visible: true,
      overlayColor: backgroundColor,
      overlayOpacity: 0.8,
      onOpen: () => debugPrint('Open new post'),
      onClose: () => debugPrint('Close new post'),
      useRotationAnimation: true,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      shape: const StadiumBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.file_open_sharp),
          backgroundColor: whiteColor,
          foregroundColor: primaryColor,
          label: 'Upload Files',
          onTap: () {
            const NewFileScreen().launch(context);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.question_answer),
          backgroundColor: whiteColor,
          foregroundColor: primaryColor,
          label: 'Ask Questions',
          onTap: () {
            const NewQuestionScreen().launch(context);
          },
        ),
      ],
      child: const Icon(Icons.add, color: whiteColor),
    );
  }
}

class CustomChips extends StatelessWidget {
  const CustomChips({
    super.key,
    required this.name,
    this.onTap,
    this.isSelected = false,
  });

  final String name;
  final Function? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null
          ? () {}
          : () {
              onTap!();
            },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : cardColor,
          borderRadius: radius(6),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? white : textPrimaryColorGlobal,
              ),
            ),
          ),
        ).paddingAll(6),
      ),
    );
  }
}

AppBar appBar({
  required String title,
  bool isLoading = false,
  Widget? leading,
  Widget? titleWidget,
  withNotification = true,
  Widget? backWidget,
  bool showBack = false,
  bool isCenterTitle = false,
}) {
  return appBarWidget(
    title,
    titleTextStyle: boldTextStyle(color: whiteColor),
    titleWidget: titleWidget,
    color: backgroundColor,
    showBack: showBack,
    center: isCenterTitle,
    backWidget: backWidget ?? const BackWidget(),
  );
}
