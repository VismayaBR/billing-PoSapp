import 'package:flutter/material.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';

class SquareButton extends StatelessWidget {
  const SquareButton(
      {Key? key,
      required this.onTap,
      required this.title,
      this.color = AppColors.posScreenSelectedTextColor,
        this.textColor = Colors.white,
      this.height = 48.0,
      this.width = 220.0,
        this.textSize=18.0,
      this.isLoading = false,
      this.progressIndicatorColor = Colors.white})
      : super(key: key);
  final VoidCallback onTap;
  final String title;
  final Color color;
  final double height;
  final double width;
  final bool isLoading;
  final Color progressIndicatorColor;
  final Color textColor;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppColors.posScreenContainerBackground,
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 5  horizontally
                5.0, // Move to bottom 5 Vertically
              ),
            )
          ],
            color: color, borderRadius: BorderRadius.circular(10.0),

        ),
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
                    fontSize: textSize),
              ),
      ),
    );
  }
}
