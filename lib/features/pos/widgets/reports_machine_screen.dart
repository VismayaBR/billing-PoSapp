import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/features/pos/widgets/commission_day_wise_list.dart';
import 'package:saloon_pos/features/pos/widgets/commission_summary_list.dart';
import 'package:saloon_pos/features/pos/widgets/item_report_list.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

import 'employee_summary_list.dart';
class ReportsMachineScreen extends StatelessWidget {
  const ReportsMachineScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: Colors.white
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5,bottom: 5),

                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: AppColors.posScreenContainerBackground,
                ),
                child: pos.selectedReportType=='Employee-Summary'?Row(
                  children: [
                    Expanded(flex:1,child: Text('#',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Service By',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Charge',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Commission',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80),)),
                    Expanded(flex:2,child: Text('OT Commission',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                  ],
                ):pos.selectedReportType=='Summary-Billwise'?Row(
                  children: [
                    Expanded(flex:1,child: Text('#',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Bill No',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Date',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Service By',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80),)),
                    Expanded(flex:2,child: Text('Total',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                  ],
                ):pos.selectedReportType=='Commission-Daywise'?Row(
                  children: [
                    Expanded(flex:1,child: Text('#',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Date',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Item',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Total',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Commission Percentage',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80),)),
                    Expanded(flex:2,child: Text('Commission Amount',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                  ],
                ):pos.selectedReportType=='Commission-Summary'?Row(
                  children: [
                    Expanded(flex:1,child: Text('#',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Item',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Total',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Commission Percentage',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80),)),
                    Expanded(flex:2,child: Text('Commission Amount',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                  ],
                ):Row(
                  children: [
                    Expanded(flex:1,child: Text('#',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Item',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Employee',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Total',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                    Expanded(flex:2,child: Text('Commission',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80),)),
                    Expanded(flex:2,child: Text('OT Commission',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: getWidth(context: context)/80))),
                  ],
                )
                ,
              ),
              verticalSpaceSmall,
              pos.selectedReportType=='Employee-Summary'?
              const EmployeeSummaryList():
              pos.selectedReportType=='Summary-Billwise'?
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: pos.fetchedSyncedData?.data?.length??0,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          if(pos.isAdmin==false){
                            pos.addToCartForEdit(pos.fetchedSyncedData!.data![index]);
                          }

                        },
                        child: Column(
                          children: [
                            verticalSpaceSX,
                            Row(
                              children: [
                                Expanded(flex:1,child: Text((index+1).toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                                Expanded(flex:2,child: Text(pos.fetchedSyncedData!.data![index].invoiceNo!,textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                                Expanded(flex:2,child: Text(pos.fetchedSyncedData!.data![index].date!,textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                                Expanded(flex:2,child: Text(pos.fetchedSyncedData!.data![index].createdBy!,textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80),)),
                                Expanded(flex:2,child: Text(pos.fetchedSyncedData!.data![index].grandTotal.toString(),textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: getWidth(context: context)/80))),
                              ],
                            ),
                            verticalSpaceSX,
                            Container(
                              height: 1,
                              color: AppColors.posScreenSeparator,
                            )
                          ],
                        ),
                      );
                    }),
              ):
              pos.selectedReportType=='Commission-Daywise'?
                  const CommissionDayWiseList():
              pos.selectedReportType=='Commission-Summary'?
                  const CommissionSummaryList():

                  const ItemReportList()


            ],
          ),
        );
      },
    );
  }
}