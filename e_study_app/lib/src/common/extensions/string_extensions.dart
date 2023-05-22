import 'package:e_study_app/src/common/asset_locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

extension stringExtensions on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? white,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(svgNoResult, height: size ?? 24, width: size ?? 24);
      },
    );
  }

  Widget svgImage({double? size, Color? color}) {
    return SvgPicture.asset(
      this,
      color: color ?? whiteColor,
      width: size ?? 20,
      height: size ?? 20,
    );
  }
}
