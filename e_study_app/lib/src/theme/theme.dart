import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../common/constants.dart';

InputDecoration inputDecoration(
  BuildContext context, {
  Widget? prefixIcon,
  String? labelText,
  double? borderRadius,
  String? hintText,
  TextStyle? hintStyle,
}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: primaryColor, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: true,
    counterText: "",
    fillColor: context.cardColor,
    hintText: hintText,
    hintStyle: hintStyle,
  );
}

class AppTheme {
  //
  AppTheme._();

  static ThemeData lightTheme({Color? color}) => ThemeData(
        useMaterial3: true,
        primarySwatch: createMaterialColor(color ?? primaryColor),
        primaryColor: color ?? primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: color ?? primaryColor,
          outlineVariant: borderColor,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.workSans().fontFamily,
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: Colors.white),
        iconTheme: const IconThemeData(color: secondaryColor),
        textTheme: GoogleFonts.workSansTextTheme(),
        dialogBackgroundColor: Colors.white,
        unselectedWidgetColor: Colors.black,
        dividerColor: borderColor,
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius:
                  radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
          backgroundColor: Colors.white,
        ),
        cardColor: cardColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: color ?? primaryColor),
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light)),
        dialogTheme: DialogTheme(shape: dialogShape()),
        navigationBarTheme: NavigationBarThemeData(
            labelTextStyle:
                MaterialStateProperty.all(primaryTextStyle(size: 10))),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  static ThemeData darkTheme({Color? color}) => ThemeData(
        useMaterial3: true,
        primarySwatch: createMaterialColor(color ?? primaryColor),
        primaryColor: color ?? primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: color ?? primaryColor,
          outlineVariant: borderColor,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        ),
        scaffoldBackgroundColor: scaffoldColorDark,
        fontFamily: GoogleFonts.workSans().fontFamily,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: scaffoldSecondaryDark),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: GoogleFonts.workSansTextTheme(),
        dialogBackgroundColor: scaffoldSecondaryDark,
        unselectedWidgetColor: Colors.white60,
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius:
                  radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
          backgroundColor: scaffoldSecondaryDark,
        ),
        dividerColor: dividerDarkColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: color ?? primaryColor),
        cardColor: scaffoldSecondaryDark,
        dialogTheme: DialogTheme(shape: dialogShape()),
        navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
                primaryTextStyle(size: 10, color: Colors.white))),
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}
