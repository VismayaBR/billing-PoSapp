import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/features/pos/widgets/mobile_commission_daywise_report.dart';
import 'package:saloon_pos/features/pos/widgets/mobile_commission_summary_report.dart';
import 'package:saloon_pos/features/pos/widgets/mobile_item_report.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

import 'mobile_employee_summary_report.dart';
class ReportsMobileScreen extends StatefulWidget {
  const ReportsMobileScreen({
    super.key,
  });

  @override
  State<ReportsMobileScreen> createState() => _ReportsMobileScreenState();
}

class _ReportsMobileScreenState extends State<ReportsMobileScreen> {
  @override

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        var count = 20;
         if(pos.selectedReportType=='Employee-Summary'){
        count= pos.selectedProductService=='Products'?pos.employeeSummery!.data!.product!.length:pos.employeeSummery!.data!.service!.length;
        }else if(pos.selectedReportType=='Summary-Billwise'){
          count= pos.fetchedSyncedData!.data!.length;
        }
        else if(pos.selectedReportType=='Commission-Daywise'){
          count= pos.selectedProductService=='Products'?pos.commissionDayWise!.data!.product!.length:pos.commissionDayWise!.data!.service!.length;
        } else if(pos.selectedReportType=='Commission-Summary'){
          count= pos.selectedProductService=='Products'?pos.commissionSummery!.data!.product!.length:pos.commissionSummery!.data!.service!.length;
        }
         else {
          count = pos.itemReport!.data!.length;
        }

        if(count<10){
          count =10;
        }

        return Container(
            height: (count*75),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.white
            ),
            child: Stack(
              children: [
                pos.selectedReportType=='Employee-Summary'?
                const MobileEmployeeSummary():
                pos.selectedReportType=='Summary-Billwise'?
                SizedBox(
                    width: getWidth(context: context),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        SizedBox(
                          width: getWidth(context: context)/5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height:40,
                                  width: getWidth(context: context)/5,
                                  color: AppColors.posScreenContainerBackground,
                                  child: Align(alignment:Alignment.centerLeft,child: Text('',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                              Expanded(
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount:pos.fetchedSyncedData!.data!.length ,
                                    itemBuilder: (context,index){
                                      return Column(
                                        children: [
                                          verticalSpaceSX,
                                          SizedBox(
                                              height: 40,
                                              width: getWidth(context: context)/7,
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text('',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                                          verticalSpaceSX,
                                          Container(
                                            height: 1,
                                            color: AppColors.posScreenSeparator,
                                          )
                                        ],
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getHeight(context: context),
                          width: getWidth(context: context)/5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height:40,
                                  width: getWidth(context: context)/5,
                                  color: AppColors.posScreenContainerBackground,
                                  child: Align(alignment:Alignment.centerLeft,child: Text('Bill No',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: pos.fetchedSyncedData!.data!.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          if(pos.isAdmin==false){
                                            log('admin false');
                                            pos.addToCartForEdit(pos.fetchedSyncedData!.data![index]);
                                          }
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              verticalSpaceSX,
                                              SizedBox(
                                                  height: 40,
                                                  width: getWidth(context: context)/5,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(pos.fetchedSyncedData!.data![index].invoiceNo!,textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                                              verticalSpaceSX,
                                              Container(
                                                height: 1,
                                                color: AppColors.posScreenSeparator,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: getWidth(context: context)/4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height:40,
                                  width: getWidth(context: context)/4,
                                  color: AppColors.posScreenContainerBackground,
                                  child: Align(alignment:Alignment.centerLeft,child: Text('Date',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),

                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: pos.fetchedSyncedData!.data!.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          if(pos.isAdmin==false){
                                            log('admin false');
                                            pos.addToCartForEdit(pos.fetchedSyncedData!.data![index]);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            verticalSpaceSX,
                                            SizedBox(
                                                height: 40,
                                                width: getWidth(context: context)/4,
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(pos.fetchedSyncedData!.data![index].date!,textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                                            verticalSpaceSX,
                                            Container(
                                              height: 1,
                                              color: AppColors.posScreenSeparator,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getHeight(context: context),
                          width: getWidth(context: context)/2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height:40,
                                  width: getWidth(context: context)/2,
                                  color: AppColors.posScreenContainerBackground,
                                  child: Align(alignment:Alignment.centerLeft,child: Text('Serviced By',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                              Expanded(child:ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: pos.fetchedSyncedData!.data!.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        if(pos.isAdmin==false){
                                          log('admin false');
                                          pos.addToCartForEdit(pos.fetchedSyncedData!.data![index]);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          verticalSpaceSX,
                                          SizedBox(
                                              height: 40,
                                              width: getWidth(context: context)/2,
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(pos.fetchedSyncedData!.data![index].createdBy!,textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                                          verticalSpaceSX,
                                          Container(
                                            height: 1,
                                            color: AppColors.posScreenSeparator,
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getHeight(context: context),
                          width: getWidth(context: context)/3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height:40,
                                  width: getWidth(context: context)/3,
                                  color: AppColors.posScreenContainerBackground,
                                  child: Align(alignment:Alignment.centerLeft,child: Text('Total',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: pos.fetchedSyncedData!.data!.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          if(pos.isAdmin==false){
                                            log('admin false');
                                            pos.addToCartForEdit(pos.fetchedSyncedData!.data![index]);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            verticalSpaceSX,
                                            SizedBox(
                                                height: 40,
                                                width: getWidth(context: context)/3,
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(pos.fetchedSyncedData!.data![index].grandTotal.toString(),textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                                            verticalSpaceSX,
                                            Container(
                                              height: 1,
                                              color: AppColors.posScreenSeparator,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getHeight(context: context),
                          width: getWidth(context: context)/4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height:40,
                                  width: getWidth(context: context)/4,
                                  color: AppColors.posScreenContainerBackground,
                                  child: Align(alignment:Alignment.centerLeft,child: Text('',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap:true,
                                    padding: EdgeInsets.zero,
                                    itemCount: pos.fetchedSyncedData!.data!.length,
                                    itemBuilder: (context,index){
                                      return Column(
                                        children: [
                                          verticalSpaceSX,
                                          SizedBox(
                                              height: 40,
                                              width: getWidth(context: context)/7,
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text('',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                                          verticalSpaceSX,
                                          Container(
                                            height: 1,
                                            color: AppColors.posScreenSeparator,
                                          )
                                        ],
                                      );
                                    }),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ):
                pos.selectedReportType=='Commission-Daywise'?
                const MobileCommissionDayWise():
                pos.selectedReportType=='Commission-Summary'?
                const MobileCommissionSummary():const MobileItemReport(),
                pos.selectedReportType=='Summary-Billwise'?
                const SummaryBillWiseCount():
                pos.selectedReportType=='Commission-Daywise'?
                const CommissionDayWiseCount():
                pos.selectedReportType=='Commission-Summary'?
                const CommissionSummaryCount():
                pos.selectedReportType=='Employee-Summary'?
                const EmployeeSummaryCount():
                const ItemReportCount()
              ],
            )


        );
      },


    );
  }
}

class SummaryBillWiseCount extends StatelessWidget {
  const SummaryBillWiseCount({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        var count= pos.fetchedSyncedData!.data!.length;
        if(count<10){
          count =10;
        }
        return Container(
          height: (count*80),
          width: getWidth(context: context)/7,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  height:40,
                  width: getWidth(context: context)/4,

                  decoration: BoxDecoration(
                    color: AppColors.posScreenContainerBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Align(alignment:Alignment.center,child: Text('#',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
              Expanded(
                child: ListView.builder(
                    shrinkWrap:true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pos.fetchedSyncedData!.data!.length,
                    itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            verticalSpaceSX,
                            SizedBox(
                                height: 40,
                                width: getWidth(context: context)/7,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('${index+1}',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                            verticalSpaceSX,
                            Container(
                              height: 1,
                              color: AppColors.posScreenSeparator,
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}

class ItemReportCount extends StatelessWidget {
  const ItemReportCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        var count = pos.itemReport!.data!.length;
        if(count<10){
          count =10;
        }
        return Container(
          height: (count*80),
          width: getWidth(context: context)/7,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  height:40,
                  width: getWidth(context: context)/4,

                  decoration: BoxDecoration(
                    color: AppColors.posScreenContainerBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Align(alignment:Alignment.center,child: Text('#',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
              Expanded(
                child: ListView.builder(
                    shrinkWrap:true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pos.itemReport!.data!.length,
                    itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            verticalSpaceSX,
                            SizedBox(
                                height: 40,
                                width: getWidth(context: context)/7,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('${index+1}',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                            verticalSpaceSX,
                            Container(
                              height: 1,
                              color: AppColors.posScreenSeparator,
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}


class CommissionDayWiseCount extends StatelessWidget {
  const CommissionDayWiseCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        var count= pos.selectedProductService=='Products'?pos.commissionDayWise!.data!.product!.length:pos.commissionDayWise!.data!.service!.length;
        if(count<10){
          count =10;
        }
        return Container(
          height: (count*80),
          width: getWidth(context: context)/7,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  height:40,
                  width: getWidth(context: context)/4,

                  decoration: BoxDecoration(
                    color: AppColors.posScreenContainerBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Align(alignment:Alignment.center,child: Text('#',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
              Expanded(
                child: ListView.builder(
                    shrinkWrap:true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pos.selectedProductService=='Products'?pos.commissionDayWise!.data!.product!.length:pos.commissionDayWise!.data!.service!.length,
                    itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            verticalSpaceSX,
                            SizedBox(
                                height: 40,
                                width: getWidth(context: context)/7,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('${index+1}',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                            verticalSpaceSX,
                            Container(
                              height: 1,
                              color: AppColors.posScreenSeparator,
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}

class CommissionSummaryCount extends StatelessWidget {
  const CommissionSummaryCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        var count= pos.selectedProductService=='Products'?pos.commissionSummery!.data!.product!.length:pos.commissionSummery!.data!.service!.length;
        if(count<10){
          count =10;
        }
        return Container(
          height: (count*80),
          width: getWidth(context: context)/7,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  height:40,
                  width: getWidth(context: context)/4,

                  decoration: BoxDecoration(
                    color: AppColors.posScreenContainerBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Align(alignment:Alignment.center,child: Text('#',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
              Expanded(
                child: ListView.builder(
                    shrinkWrap:true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pos.selectedProductService=='Products'?pos.commissionSummery!.data!.product!.length:pos.commissionSummery!.data!.service!.length,
                    itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            verticalSpaceSX,
                            SizedBox(
                                height: 40,
                                width: getWidth(context: context)/7,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('${index+1}',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                            verticalSpaceSX,
                            Container(
                              height: 1,
                              color: AppColors.posScreenSeparator,
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}

class EmployeeSummaryCount extends StatelessWidget {
  const EmployeeSummaryCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        var count= pos.selectedProductService=='Products'?pos.employeeSummery!.data!.product!.length:pos.employeeSummery!.data!.service!.length;
        if(count<10){
          count =10;
        }
        return Container(
          height: (count*80),
          width: getWidth(context: context)/7,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  height:40,
                  width: getWidth(context: context)/4,

                  decoration: BoxDecoration(
                    color: AppColors.posScreenContainerBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Align(alignment:Alignment.center,child: Text('#',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
              Expanded(
                child: ListView.builder(
                    shrinkWrap:true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pos.selectedProductService=='Products'?pos.employeeSummery!.data!.product!.length:pos.employeeSummery!.data!.service!.length,
                    itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            verticalSpaceSX,
                            SizedBox(
                                height: 40,
                                width: getWidth(context: context)/7,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('${index+1}',textAlign: TextAlign.center,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
                            verticalSpaceSX,
                            Container(
                              height: 1,
                              color: AppColors.posScreenSeparator,
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
