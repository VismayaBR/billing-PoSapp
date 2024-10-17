

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/features/common_widgets/error_handling_widget.dart';
import 'package:saloon_pos/features/common_widgets/no_internet_widget.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/features/pos/widgets/dashboard_widget.dart';
import 'package:saloon_pos/features/pos/widgets/report_drawer.dart';
import 'package:saloon_pos/features/pos/widgets/reports_machine_screen.dart';
import 'package:saloon_pos/features/pos/widgets/reports_mobile_screen.dart';
import 'package:saloon_pos/features/pos/widgets/search_widget.dart';
import 'package:saloon_pos/features/pos/widgets/search_widget_mobile.dart';
import 'package:saloon_pos/features/pos/widgets/switch_products_service_report_mobile.dart';
import 'package:saloon_pos/features/pos/widgets/switch_type_bar_report.dart';
import 'package:saloon_pos/features/pos/widgets/switch_type_bar_report_mobile.dart';
import 'package:saloon_pos/features/pos/widgets/switch_type_products_service_machine.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/app_contants.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

import '../../common_widgets/square_button.dart';
class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final prefs = SharedPreferencesRepo.instance;
  final GlobalKey<ScaffoldState> reportScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)   {
      Provider.of<PosScreenViewModel>(context,listen: false).setBackToEmployeeSummary();
      Provider.of<PosScreenViewModel>(context,listen: false).checkAdmin();
      if(Provider.of<PosScreenViewModel>(context,listen: false).isAdmin!){
         Provider.of<PosScreenViewModel>(context,listen: false).initiateForAdmin();
         Provider.of<PosScreenViewModel>(context,listen: false).fetchEmployees();
      }
      Provider.of<PosScreenViewModel>(context,listen: false).fetchBranches();

      Provider.of<PosScreenViewModel>(context,listen: false).fetchEmployeeSummery();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Consumer<PosScreenViewModel>(
      builder: (context,pos,child){

        return Scaffold(
          key: reportScaffoldKey,
          appBar: AppBar(
            backgroundColor: AppColors.posScreenSelectedTextColor,
          ),
          backgroundColor: Colors.white,
          drawer: const MenuPage(),
          body:
          // pos.reportScreenLoading
          //       ? const Center(
          //       child: CupertinoActivityIndicator(
          //         color: AppColors.posScreenSelectedTextColor,
          //       ))
          //       :
          pos.reportState == AppStrings.apiNoInternet
              ? Center(
                child: NoInternetWidget(onPressed: (){
                  pos.fetchEmployeeSummery();
                  pos.checkAdmin();
          }),
              )
              : pos.reportState == AppStrings.apiError
              ? Center(child: ErrorHandlingWidget(onPressed: (){Get.offAllNamed('/posScreen');})):LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                return Column(
                  children: [
                    constraints.maxWidth<800||constraints.maxHeight<600?verticalSpaceSmall:verticalSpaceMedium,
                   if(pos.isAdmin!=null)
                    Visibility(
                      visible: !pos.isAdmin!,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(Icons.chevron_left,size:constraints.maxWidth<800||constraints.maxHeight<600?20: getWidth(context: context)/50 ,),
                              horizontalSpaceSmall,
                              Text('BACK TO HOME',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w700,fontSize: constraints.maxWidth<800||constraints.maxHeight<600?14:getWidth(context: context)/80),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    //verticalSpaceSmall,
                    if(pos.employeeList!=null && pos.isAdmin!=null)
                      constraints.maxWidth<800||constraints.maxHeight<600?
                    Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin:  const EdgeInsets.only(left: 10, right:10),
                            padding:  const EdgeInsets.fromLTRB(10,10,10,0),
                            width: getWidth(context: context),
                            color: AppColors.posScreenContainerBackground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                        visible: !pos.isAdmin!,
                                        replacement: Text(pos.branchName!,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 24),),
                                        child: Text('Sales',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 24),)),

                                    // Visibility(
                                    //     visible: pos.isAdmin!,
                                    //     replacement:SquareButton(onTap: (){
                                    //       pos.fetchDaySummary();
                                    //     }, title: 'Day Summary',width: 150,height: 50,textSize: 14,isLoading:pos.daySummaryLoading,) ,
                                    //     child: SquareButton(onTap: (){
                                    //       pos.punchOut(context);
                                    //       }, title: pos.punchedIn?'Log Out':'Log In',width: 100,height: 40,textSize: 14,),
                                    //   )
                                  ],
                                ),
                                if(pos.isAdmin!)
                                  verticalSpaceSmall,
                                if(pos.isAdmin!)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    SquareButton(
                                      color: pos.openingDate!.isNotEmpty?Colors.green:Colors.red,
                                      onTap: (){
                                        if(pos.openingDate!.isNotEmpty){
                                          pos.dayClosePopup(context,DateTime.now());
                                        } else{
                                          pos.selectOpenDate(context);
                                        }
                                      }, title: pos.openingDate!.isNotEmpty?'DAY CLOSE':'DAY OPEN',width: 100,height: 40,textSize: 14,)
                                  ],
                                ),

                                if(pos.isAdmin!)
                                  Visibility(
                                    visible: pos.adminViewEmployeeList.isNotEmpty,
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      height:40,
                                      width: constraints.maxWidth<800||constraints.maxHeight<600?getWidth(context: context)/2:getWidth(context: context)/8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey),
                                        // color: DashBoardColours.dSideMenu,
                                      ),
                                      child: pos.adminViewEmployeeList.isNotEmpty?DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton(
                                            value: pos.adminViewEmployeeList.contains(pos.adminViewEmployeeSelected)?pos.adminViewEmployeeSelected:null,
                                            borderRadius: BorderRadius.circular(8),
                                            isDense: true,
                                            items:pos.adminViewEmployeeList.map((String val) {
                                              return DropdownMenuItem(
                                                value: val,
                                                child:  Text(val.toString(),
                                                  style:const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 14),),
                                              );
                                            }).toList(), onChanged: (val){
                                            int id=pos.employeeList![pos.employeeList!.indexWhere((element) => element.name==val!)].id!;
                                            pos.changeAdminViewEmployee(val!,id);
                                          },),
                                        ),
                                      ): const SizedBox(),
                                    ),
                                  ),
                                verticalSpaceSmall,
                                  const SearchWidgetMobile(),
                                Visibility(
                                  visible: !pos.reportScreenLoading,
                                  replacement: const Center(
                                          child: CupertinoActivityIndicator(
                                            color: AppColors.posScreenSelectedTextColor,
                                          )),
                                  child: Column(
                                    children: [
                                      pos.isAdmin!?verticalSpaceMedium:Container(),
                                      const DashBoardWidgetMobile(titleSize: 14,prizeSize: 33,height: 130,),
                                      verticalSpaceMedium,
                                       if(pos.selectedReportType=='Commission-Daywise'||pos.selectedReportType=='Commission-Summary'||pos.selectedReportType=='Employee-Summary')
                                        const SwitchProductsServicesReportMobile(),
                                      const SwitchTypeBarReportMobile(),
                                      if(pos.selectedReportType=='Commission-Daywise'||pos.selectedReportType=='Commission-Summary'||pos.selectedReportType=='Employee-Summary')
                                        verticalSpaceSmall,
                                     
                                      verticalSpaceMedium,
                                      const ReportsMobileScreen()
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ),
                        )):
                    Expanded(
                        child: SingleChildScrollView(
                          primary: true,
                          child: Container(
                            margin:  const EdgeInsets.only(left: 20, right: 20),
                            padding:  const EdgeInsets.fromLTRB(20,20,20,0),
                            width: getWidth(context: context),
                            color: AppColors.posScreenContainerBackground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                        visible: !pos.isAdmin!,
                                        replacement: Text(pos.branchName!,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 24),),
                                        child: Text('Sales',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 24),)),

                                    Visibility(
                                      visible: pos.isAdmin!,
                                      replacement:SquareButton(onTap: (){
                                        pos.fetchDaySummary();
                                      }, title: 'Day Summary',width: 150,height: 50,textSize: 14,isLoading:pos.daySummaryLoading,) ,
                                      child: Row(
                                        children: [
                                          // InkWell(
                                          //   onTap:(){
                                          //     pos.reportScaffoldKey.currentState!.openDrawer();
                                          //   },
                                          //     child: const Icon(Icons.menu,color: AppColors.posScreenColor,)) ,


                                          horizontalSpaceMedium,
                                          SquareButton(onTap: (){
                                            pos.punchOut(context);
                                          }, title: pos.punchedIn?'Log Out':'Log In',width: 100,height: 40,textSize: 14,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                if(pos.isAdmin!)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Visibility(
                                        visible: pos.adminViewEmployeeList.isNotEmpty,
                                        child: Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          height:40,
                                          width: constraints.maxWidth<800||constraints.maxHeight<600?getWidth(context: context)/3:getWidth(context: context)/5,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey),
                                            // color: DashBoardColours.dSideMenu,
                                          ),
                                          child: pos.adminViewEmployeeList.isNotEmpty?DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child:   DropdownButton(
                                                value: pos.adminViewEmployeeList.contains(pos.adminViewEmployeeSelected)?pos.adminViewEmployeeSelected:null,
                                                borderRadius: BorderRadius.circular(8),
                                                isDense: true,
                                                items:pos.adminViewEmployeeList.map((String val) {
                                                  return DropdownMenuItem(
                                                    value: val,
                                                    child:  Text(val.toString(),
                                                      style:const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 14),),
                                                  );
                                                }).toList(), onChanged: (val){
                                                int id=pos.employeeList![pos.employeeList!.indexWhere((element) => element.name==val!)].id!;
                                                pos.changeAdminViewEmployee(val!,id);
                                              },),
                                            ),
                                          ):const SizedBox(),
                                        ),
                                      ),
                                      SquareButton(
                                        color: pos.openingDate!.isNotEmpty?Colors.green:Colors.red,
                                        onTap: ()async{
                                          if(pos.openingDate!.isNotEmpty){
                                           // pos.selectOpenClose(context);
                                            pos.dayClosePopup(context,DateTime.now());
                                          } else{
                                            pos.selectOpenDate(context);
                                          }

                                        }, title: pos.openingDate!.isNotEmpty?'DAY CLOSE':'DAY OPEN',width: 100,height: 40,textSize: 14,)
                                    ],
                                  ),
                                if(pos.isAdmin!)
                                  verticalSpaceSmall,
                                const SearchWidget(),
                                verticalSpaceSmall,
                                pos.isAdmin!?verticalSpaceMedium:Container(),
                                DashBoardWidget(titleSize: getWidth(context: context)/80,prizeSize: getWidth(context: context)/40,height: 145,),
                                verticalSpaceMedium,
                                const SwitchTypeBarReportMachine(),
                                if(pos.selectedReportType=='Commission-Daywise'||pos.selectedReportType=='Commission-Summary'||pos.selectedReportType=='Employee-Summary')
                                verticalSpaceSmall,
                                if(pos.selectedReportType=='Commission-Daywise'||pos.selectedReportType=='Commission-Summary'||pos.selectedReportType=='Employee-Summary')
                                const SwitchTypeProductsServiceMachine(),
                                verticalSpaceMedium,
                                const ReportsMachineScreen()
                              ],
                            ),

                          ),
                        ))
                  ],
                );
              }

          ),
        );
      },

    );
  }
}






