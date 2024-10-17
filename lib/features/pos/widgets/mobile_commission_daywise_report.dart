import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class MobileCommissionDayWise extends StatelessWidget {
  const MobileCommissionDayWise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return pos.selectedProductService=='Products'?SizedBox(
            width: getWidth(context: context),
            child: ListView(
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
                            shrinkWrap:true,
                            padding: EdgeInsets.zero,
                            itemCount:pos.commissionDayWise!.data!.product!.length ,
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
                  width: getWidth(context: context)/3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/3,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('Item',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.product!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/3,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.product![index].productName!,textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/4,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('Total',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),

                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.product!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/4,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.product![index].total.toString(),textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/2,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('OT Total',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.product!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/2,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.product![index].otAmount.toString(),textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/3,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('Commission Total',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.product!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/3,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.product![index].commissionAmount!.toString(),textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/4,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      ListView.builder(
                          shrinkWrap:true,
                          padding: EdgeInsets.zero,
                          itemCount: pos.commissionDayWise!.data!.product!.length,
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
                          })
                    ],
                  ),
                )
              ],
            )
        ):
        SizedBox(
            width: getWidth(context: context),
            child: ListView(
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
                        child : ListView.builder(
                            shrinkWrap:true,
                            padding: EdgeInsets.zero,
                            itemCount:pos.commissionDayWise!.data!.service!.length ,
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
                  width: getWidth(context: context)/3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/3,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('Date',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.service!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/3,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.service![index].date!,textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/3,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('Item',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.service!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/3,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.service![index].serviceName!,textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/4,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('Total',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),

                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.service!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/4,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.service![index].total.toString(),textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/2,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('OT Total',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.service!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/2,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.service![index].otAmount.toString(),textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                  width: getWidth(context: context)/3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height:40,
                          width: getWidth(context: context)/3,
                          color: AppColors.posScreenContainerBackground,
                          child: Align(alignment:Alignment.centerLeft,child: Text('Commission Total',textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14,),))),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: pos.commissionDayWise!.data!.service!.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  verticalSpaceSX,
                                  SizedBox(
                                      height: 40,
                                      width: getWidth(context: context)/3,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(pos.commissionDayWise!.data!.service![index].commissionAmount!.toString(),textAlign: TextAlign.start,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)))),
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
                            itemCount: pos.commissionDayWise!.data!.service!.length,
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
        );
      },

    );
  }
}
