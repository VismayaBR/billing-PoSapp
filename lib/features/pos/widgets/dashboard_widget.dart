import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class DashBoardWidget extends StatelessWidget {
  final double titleSize;
  final double prizeSize;
  final double height;
  const DashBoardWidget({
    super.key,
    required this.titleSize,
    required this.prizeSize,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return  Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Row(
          children: [
            DashboardMobileContainer(title: 'TOTAL SALES',price: (pos.totalValues?.data?.sales??0).toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),
            horizontalSpaceSmall,
            DashboardMobileContainer(title: 'TOTAL COMMISSIONS',price: (pos.totalValues?.data?.commission??0).toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),
            horizontalSpaceSmall,
            DashboardMobileContainer(title: 'OT BILLS',price: (pos.totalValues?.data?.otBill??0).toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),
            horizontalSpaceSmall,
            DashboardMobileContainer(title: 'OT COMMISSIONS',price: (pos.totalValues?.data?.otCommission??0).toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),

          ],
        );
      },

    );
  }
}

class DashBoardWidgetMobile extends StatelessWidget {
  final double titleSize;
  final double prizeSize;
  final double height;
  const DashBoardWidgetMobile({
    super.key,
    required this.titleSize,
    required this.prizeSize,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return  Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Column(
          children: [
            Row(
              children: [
                
                DashboardMobileContainer(title: 'TOTAL SALES',price: pos.totalValues!.data!.sales.toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),
                horizontalSpaceSmall,
                // DashboardMobileContainer(title: 'TOTAL COMMISSIONS',price: pos.totalValues!.data!.commission.toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                // DashboardMobileContainer(title: 'OT BILLS',price: pos.totalValues!.data!.otBill.toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),
                horizontalSpaceSmall,
                // DashboardMobileContainer(title: 'OT COMMISSIONS',price: pos.totalValues!.data!.otCommission.toString(),prizeSize: prizeSize,titleSize: titleSize,height: height,),
              ],
            ),

          ],
        );
      },
    );
  }
}

class DashboardContainer extends StatelessWidget {
  final String title;
  final String price;
  final double titleSize;
  final double prizeSize;
  final double height;
  const DashboardContainer({
    super.key,
    required this.title,
    required this.price,
    required this.titleSize,
    required this.prizeSize,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(10),
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.white),
      child: Column(
        children: [
          Text(title,style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,color: AppColors.textFieldTextColor,fontSize: titleSize),textAlign: TextAlign.center,),
          verticalSpaceMedium,
          Text(price,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: prizeSize),),
          verticalSpaceSmall,
          Text('QAR',style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,color: AppColors.textFieldTextColor,fontSize: titleSize),),
        ],
      ),
    ));
  }
}

class DashboardMobileContainer extends StatelessWidget {
  final String title;
  final String price;
  final double titleSize;
  final double prizeSize;
  final double height;
  const DashboardMobileContainer({
    super.key,
    required this.title,
    required this.price,
    required this.titleSize,
    required this.prizeSize,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            height: 30,
              child: Center(child: Text(title,style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,color: AppColors.textFieldTextColor,fontSize: titleSize),textAlign: TextAlign.center,))),
          verticalSpaceSmall,
          Text(price,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: prizeSize),),
          verticalSpaceSmall,
          Text('QAR',style: mainSubHeadingStyle().copyWith(fontWeight: FontWeight.w600,color: AppColors.textFieldTextColor,fontSize: titleSize),),
        ],
      ),
    ));
  }
}