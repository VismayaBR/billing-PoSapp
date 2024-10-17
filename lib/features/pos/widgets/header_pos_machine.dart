
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/common_widgets/square_button.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/features/pos/widgets/pos_text_field.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/assets.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class HeaderForPosMachine extends StatelessWidget {
  const HeaderForPosMachine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: (){
              //         log(pos.userName!);
              //
              //       },
              //         child: Image.asset(Assets.figma)),
              //     horizontalSpaceSmall,
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(pos.userName!,style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80),),
              //         // horizontalSpaceTiny,
              //         // Text(pos.userEmail!,style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor),),
              //         //
              //       ],
              //     )
              //   ],
              // ),
              Row(
                children: [
                  Image.asset(Assets.figma),
                  horizontalSpaceTiny,
                  Text(pos.userName!,style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,fontSize: 14),),
                  horizontalSpaceTiny,
                  horizontalSpaceTiny,
                  pos.openingDate!.isNotEmpty? Text(pos.changeDateFormat(pos.openingDate!),style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,fontSize: 14,color:pos.checkOpeningDate(pos.openingDate!)?Colors.green:Colors.yellow),):
                  Text(pos.changeDateFormat(DateTime.now().toString().substring(0,10)),style:mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,fontSize: 14,color:Colors.red)),
                  // Text(pos.changeDateFormat(account.login?.data?.user?.openingDate??''),style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,fontSize: 14,color:pos.checkOpeningDate(account.login?.data?.user?.openingDate??'')?Colors.green:Colors.red),),
                ],
              ),
              Row(

                children: [
                  InkWell(
                    onTap: (){
                      Get.toNamed('/reportScreen');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: AppColors.posScreenColor,width: 1)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(Assets.salesReportIcon),
                          horizontalSpaceTiny,
                          Text('Sales Report',style: mainSubHeadingStyle().copyWith(color: AppColors.posScreenColor),)
                        ],
                      ),

                    ),
                  ),
                  horizontalSpaceMedium,
                  PosTextField(textEditingController: pos.customerNameController, hintText: 'Customer Name', icon: Icons.person,width: getWidth(context: context)/7,),
                  horizontalSpaceMedium,
                  PosTextField(textEditingController: pos.customerNumberController, hintText: 'Customer Mobile', icon: Icons.phone,width: getWidth(context: context)/7),
                  horizontalSpaceMedium,
                  SquareButton(onTap: (){pos.punchOut(context);}, title: pos.punchedIn?'Log Out':'Log In',width: getWidth(context: context)/10,)
                ],
              )


            ],
          ),
        );
      },

    );
  }
}