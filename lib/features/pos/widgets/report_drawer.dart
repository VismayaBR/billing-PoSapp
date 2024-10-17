


// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/model/branch_model.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_contants.dart';
import 'package:saloon_pos/helper/themes.dart';
import 'package:saloon_pos/helper/ui_helper.dart';






class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MenuState();
  }
}

class _MenuState extends State<MenuPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Drawer(
            child: ListView(
              children: [

                ListTile(
                    onTap: ()async{
                      bool internetAvailable = await pos.checkInternet();
                      if (internetAvailable == true) {
                        Get.toNamed(
                            '/addEmployeeScreen');
                      } else{
                        Themes.showSnackBar(
                            context: context,
                            msg: AppStrings.apiNoInternet);
                      }
                    },
                    title: const Row(
                      children: [
                        Icon(Icons.add),
                        horizontalSpaceSmall,
                        Text('Employee Form',),
                      ],
                    )),
                ListTile(
                    onTap: ()async{
                      bool internetAvailable = await pos.checkInternet();
                      if (internetAvailable == true) {
                        Get.toNamed(
                            '/addServiceScreen');

                      } else{
                        Themes.showSnackBar(
                            context: context,
                            msg: AppStrings.apiNoInternet);
                      }
                    },
                    title:  const Row(
                      children: [
                        Icon(Icons.add),
                        horizontalSpaceSmall,
                        Text('Service Form'),
                      ],
                    )),
                const ListTile(
                    title: Text('Switch Branch',)),
                Container(
                  margin: const EdgeInsets.only(left: 10,right: 10),
                  padding: const EdgeInsets.only(right: 10),
                  height:40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                    // color: DashBoardColours.dSideMenu,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        value: pos.branches!.data[pos.branches!.data.indexWhere((element) => element.id==pos.selectedBranchId)],
                        borderRadius: BorderRadius.circular(8),
                        isDense: true,
                        items:pos.branches!.data.map((BranchData val) {
                          return DropdownMenuItem(
                            value: val,
                            child:  Text(val.name.toString(),
                              style:const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 14),),
                          );
                        }).toList(), onChanged: (val){
                          pos.switchBranch(branchId: val!.id);

                      },),
                    ),
                  ),
                )


              ],
            ));
      },
    );



  }
}
