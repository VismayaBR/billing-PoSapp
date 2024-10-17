import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/assets.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Row(
          children: [
            Expanded(flex:3,child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From Date :',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80),),
                verticalSpaceTiny,
                GestureDetector(
                  onTap: (){
                    pos.selectFromDate(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.white),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${pos.fromDate.year}/${pos.fromDate.month}/${pos.fromDate.day}',style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontWeight: FontWeight.w500,fontSize: getWidth(context: context)/80),),
                          Image.asset(Assets.calenderIcon)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
            horizontalSpaceSmall,
            Expanded(flex:3,child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To Date :',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80),),
                verticalSpaceTiny,
                GestureDetector(
                  onTap: (){
                    pos.selectToDate(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.white),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${pos.toDate.year}/${pos.toDate.month}/${pos.toDate.day}',style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontWeight: FontWeight.w500,fontSize: getWidth(context: context)/80),),
                          Image.asset(Assets.calenderIcon)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
            horizontalSpaceSmall,
            Expanded(flex:1,child: Column(
              children: [
                Text('',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80),),
                verticalSpaceTiny,
                GestureDetector(
                  onTap: (){
                    if(pos.selectedReportType=='Employee-Summary'){
                      pos.fetchEmployeeSummery();
                    }
                    else if(pos.selectedReportType=='Summary-Billwise'){
                      pos.fetchSyncedData();
                    }
                    else if(pos.selectedReportType=='Commission-Daywise'){
                      pos.fetchCommissionDayWise();
                    }
                    else if(pos.selectedReportType=='Commission-Summary'){
                      pos.fetchCommissionSummery();
                    }
                    else{
                      pos.fetchItemReport();
                    }

                  },
                  child: Container(height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: AppColors.posScreenSelectedTextColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search,color: Colors.white,),
                        horizontalSpaceTiny,
                        Text('Search',style: mainSubHeadingStyle().copyWith(fontWeight:FontWeight.w600,color: Colors.white,fontSize: getWidth(context: context)/75),)
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ],
        );
      },

    );
  }
}