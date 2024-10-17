import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class PriceDetailsWidget extends StatelessWidget {
  final double size;
  final double discountWidth;
  const PriceDetailsWidget({
    super.key,
    required this.size,
    required this.discountWidth
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sub Total',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: size),),
                  Text('${pos.subTotal}',style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontSize: size))
                ],
              ),
            ),
            verticalSpaceSmall,
            // Container(
            //   padding: const EdgeInsets.only(left: 20,right: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       // Text('Discount',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: size),),
            //       // DiscountTextField( textEditingController: pos.discountController,size: size,discountWidth: discountWidth,)
            //     ],
            //   ),
            // ),
            verticalSpaceSmall,
            Container(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: size),),
                  Text('${pos.total-pos.discount}',style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontSize: size))
                ],
              ),
            ),
          ],
        );
      },

    );
  }
}

class DiscountTextField extends StatefulWidget {

  final TextEditingController textEditingController;
  final double size;
  final double discountWidth;

  const DiscountTextField({
    super.key,
    required this.textEditingController,
    required this.size,
    required this.discountWidth
  });

  @override
  State<DiscountTextField> createState() => _DiscountTextFieldState();
}

class _DiscountTextFieldState extends State<DiscountTextField> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.discountWidth,
              height: 30,
              child: TextFormField(
                style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontSize: widget.size),
                textAlign: TextAlign.right,
                controller: widget.textEditingController,
                cursorColor: AppColors.textFieldTextColor,
                decoration: InputDecoration(

                  hintStyle: textFieldStyle(),
                  fillColor: AppColors.textFieldFill,
                  contentPadding: const EdgeInsets.only(left: 20.0,right: 5),

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
                keyboardType: TextInputType.number,
                onChanged: (value){
                  log('logger');
                  log(value);
                  if(value.isNotEmpty){
                    if(value[0]=='0'){
                      setState(() {
                        pos.discountController.clear();
                      });
                      pos.onChangeDiscount(0);
                    }
                    else if( RegExp(discountPattern).hasMatch(value) == false){
                      log('happended');
                      setState(() {
                        pos.discountController.clear();
                      });
                      pos.onChangeDiscount(0);
                    }
                    else if(int.parse(value)>pos.subTotal){
                      setState(() {
                        pos.discountController.clear();
                      });
                      pos.onChangeDiscount(0);
                    }
                    else{
                      log('hh');
                      pos.onChangeDiscount(int.parse(value));
                    }
                  }
                  else{
                    pos.onChangeDiscount(0);
                  }
                  // pos.onChangeDiscount(value);
                  },


                // validator: (value) {
                //
                // },
              ),
            ),
          ],
        );
      },

    );
  }
}