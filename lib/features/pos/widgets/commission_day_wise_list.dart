import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class CommissionDayWiseList extends StatelessWidget {
  const CommissionDayWiseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return pos.selectedProductService=='Products'?
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pos.commissionDayWise?.data?.product?.length??0,
            itemBuilder: (context,index){
              return Column(
                children: [
                  verticalSpaceSX,
                  Row(
                    children: [
                      Expanded(flex:1,child: Text((index+1).toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.product![index].productName!,textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.product![index].total.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.product![index].otAmount.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80),)),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.product![index].commissionAmount!.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                    ],
                  ),
                  verticalSpaceSX,
                  Container(
                    height: 1,
                    color: AppColors.posScreenSeparator,
                  )
                ],
              );
            }):
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pos.commissionDayWise?.data?.service?.length??0,
            itemBuilder: (context,index){
              return Column(
                children: [
                  verticalSpaceSX,
                  Row(
                    children: [
                      Expanded(flex:1,child: Text((index+1).toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.service![index].date.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.service![index].serviceName!,textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.service![index].total.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.service![index].otAmount.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80),)),
                      Expanded(flex:2,child: Text(pos.commissionDayWise!.data!.service![index].commissionAmount!.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                    ],
                  ),
                  verticalSpaceSX,
                  Container(
                    height: 1,
                    color: AppColors.posScreenSeparator,
                  )
                ],
              );
            });

      },

    );
  }
}
