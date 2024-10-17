import 'package:flutter/material.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';

class Themes {
  static showSnackBar(
      { var msg, BuildContext? context}) {
    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      backgroundColor: AppColors.posScreenSelectedTextColor,
      content: Center(
        child: Text(
          msg,
          style: mainSubHeadingStyle().copyWith(color: Colors.white),
        ),
      ),
      duration: const Duration(seconds: 1),
    ));
  }
}
