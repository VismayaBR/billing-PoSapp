import 'package:flutter/material.dart';
import 'package:saloon_pos/helper/app_colors.dart';

TextStyle mainHeadingStyle() {
  return const TextStyle(
      fontFamily: '.SF UI Text',
      fontWeight: FontWeight.bold,
      fontSize: 30,
      color: AppColors.textFieldTextColor);
}

TextStyle mainSubHeadingStyle() {
  return const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Colors.black);
}

TextStyle viewAllStyle() {
  return const TextStyle(
      fontFamily: '.SF UI Text',
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: AppColors.textFieldTextColor);
}

TextStyle textFieldStyle() {
  return const TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      color: AppColors.textFieldTextColor,
      overflow: TextOverflow.ellipsis);
}

TextStyle descriptionStyle() {
  return const TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
}

TextStyle boxText() {
  return const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}
