
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
class PosBarCode extends StatelessWidget {

  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final double width;
  final bool fromPopUp;

  const PosBarCode({
    super.key,

    required this.textEditingController,
    required this.hintText,
    required this.icon,
    required this.width,
    this.fromPopUp=false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: width,
          child: TextFormField(
            style: textFieldStyle(),
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon,color: AppColors.textFieldTextColor,),
              hintStyle: textFieldStyle(),
              fillColor: AppColors.textFieldFill,
              labelStyle: textFieldStyle(),
              contentPadding: const EdgeInsets.only(left: 20.0),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AppColors.textFieldBorder,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AppColors.textFieldBorder,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: AppColors.textFieldBorder,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 1,
           
           
          ),
        );
  }
}