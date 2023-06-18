import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/constants.dart';

Future<void> confirm(
  BuildContext context,
  Function action, {
  String message = "Confirm",
}) async {
  return showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (p0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          32.height,
          Text(
            message,
            textAlign: TextAlign.center,
            style: boldTextStyle(size: 20),
          ),
          28.height,
          Row(
            children: [
              AppButton(
                elevation: 0,
                onTap: () {
                  action();
                  context.pop();
                },
                child: Text(
                  "Yes",
                  style: boldTextStyle(
                    size: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).expand(),
              16.width,
              AppButton(
                color: primaryColor,
                elevation: 0,
                onTap: () async {
                  context.pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.white),
                ),
              ).expand(),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24);
    },
  );
}

Future<void> appLaunchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    // throw Exception('Could not launch $url');
    toast("Unable to launch $url");
  }
}
