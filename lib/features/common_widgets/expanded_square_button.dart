import 'package:flutter/material.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';

class ExpandedSquareButton extends StatelessWidget {
  const ExpandedSquareButton(
      {Key? key,
        required this.onTap,
        required this.title,
        this.color = AppColors.posScreenSelectedTextColor,
        required this.textColor,
        this.height = 50.0,
        this.isLoading = false,
        this.progressIndicatorColor = Colors.white})
      : super(key: key);
  final VoidCallback onTap;
  final String title;
  final Color color;
  final double height;
  final Color textColor;
  final bool isLoading;
  final Color progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10.0)),
          child: isLoading
              ? Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: CircularProgressIndicator(
                color: progressIndicatorColor,
              ))
              : Text(
            title,
            style: mainSubHeadingStyle().copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}
