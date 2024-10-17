import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class ItemReportList extends StatelessWidget {
  const ItemReportList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pos.itemReport?.data?.length??0,
            itemBuilder: (context,index){
              return Column(
                children: [
                  verticalSpaceSX,
                  Row(
                    children: [
                      Expanded(flex:1,child: Text((index+1).toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.itemReport!.data![index].serviceName!,textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.itemReport!.data![index].employeeName!,textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.itemReport!.data![index].total.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80),)),
                      Expanded(flex:2,child: Text(pos.itemReport!.data![index].commission!.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                      Expanded(flex:2,child: Text(pos.itemReport!.data![index].otCommission!.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),

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
