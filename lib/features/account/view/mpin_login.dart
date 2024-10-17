import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/features/account/view_model/account_view_model.dart';
import 'package:saloon_pos/features/common_widgets/square_button.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/app_contants.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

import '../../../app_config/api.dart';
import '../../../app_config/server_addresses.dart';
import '../../pos/view_model/pos_screen_view_model.dart';
class PinLogin extends StatefulWidget {
  const PinLogin({Key? key}) : super(key: key);

  @override
  State<PinLogin> createState() => _PinLoginState();
}
class _PinLoginState extends State<PinLogin> {
  String? orgName;
  String? userType;
  final _prefs = SharedPreferencesRepo.instance;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)  {
      checkOrgAndUser();
       Provider.of<PosScreenViewModel>(context,listen: false).fetchLogo();
      //  if(orgName!.isEmpty && userType!.isEmpty){
      //    Provider.of<PosScreenViewModel>(context,listen: false).showBranchUserTypeDialog(context);
      //  }
      // _prefs!.setString(AppStrings.userToken, '');
    });
    super.initState();
  }
  checkOrgAndUser()async{
    setState(() {
      orgName=_prefs!.checkOrgName();
      userType=_prefs!.checkUserType();
      if(orgName=='TALENT'){
        ServerAddresses.baseUrl=ServerAddresses.talentsBaseUrl;
        ServerAddresses.logoUrl=ServerAddresses.talentsLogoUrl;
      }
      else{
        ServerAddresses.baseUrl=ServerAddresses.trendzAlnasrBaseUrl;
        ServerAddresses.logoUrl=ServerAddresses.trendzAlnasrLogoUrl;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountViewModel,PosScreenViewModel>(

        builder: (context,account,pos,child) {
          return Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    height: getHeight(context: context),
                    width: getWidth(context: context),
                    color: Colors.white,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(pos.orgLogo!=null)
                              SizedBox(width:constraints.maxWidth<800?getWidth(context: context)/2:getWidth(context: context)/6,height:constraints.maxWidth<800?getHeight(context: context)/4:getHeight(context: context)/8,child: Image.network(pos.orgLogo!.data!.companyLogo!)),
                            if(constraints.maxWidth > 800)
                            verticalSpaceMedium,
                            Text('Sign In', style: mainSubHeadingStyle().copyWith(
                                fontSize: constraints.maxWidth < 800
                                    ? 32
                                    : getWidth(context: context) / 45,
                                fontWeight: FontWeight.w600),),
                            constraints.maxWidth < 800
                                ? verticalSpaceMedium
                                : verticalSpaceLarge,
                            SizedBox(
                              width: constraints.maxWidth < 800?getWidth(context: context) / 1.2:getWidth(context: context)/2,
                              height: 20,
                              child: ListView.builder(
                                padding: EdgeInsets.only(left:getWidth(context: context)/4),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: account.typedPin.length,
                                  itemBuilder: (context,index){
                                    return Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      height: 10,
                                      width: 10,
                                      decoration: const BoxDecoration(
                                        color: AppColors.posScreenSelectedTextColor,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }),
                            ),
                            verticalSpaceMedium,
                            SizedBox(
                              width: constraints.maxWidth < 800?getWidth(context: context) / 1.2:getWidth(context: context)/2,
                              child: GridView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                  childAspectRatio: 2 / 1,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        if(account.typedPin.length<10){
                                          account.typedPin.add(account.numbers[index]);
                                        }

                                      });

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.posScreenContainerBackground,
                                        border: Border.all(color: AppColors.textFieldBorder,width: 1)
                                      ),
                                      child: Center(
                                        child: Text(account.numbers[index],style: mainSubHeadingStyle().copyWith(color: AppColors.posScreenSelectedTextColor,fontSize:constraints.maxWidth < 800?14:getWidth(context: context)/80,fontWeight: FontWeight.bold ),),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: account.numbers.length,),
                            ),
                            SizedBox(
                              width: constraints.maxWidth < 800?getWidth(context: context) / 1.2:getWidth(context: context)/2,
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          if(account.typedPin.isNotEmpty){
                                            account.typedPin.clear();
                                          }

                                        });

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.posScreenContainerBackground,
                                            border: Border.all(color: AppColors.textFieldBorder,width: 1)
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.close,color: AppColors.posScreenSelectedTextColor,),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          if(account.typedPin.length<10){
                                            account.typedPin.add('0');
                                          }

                                        });

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.posScreenContainerBackground,
                                            border: Border.all(color: AppColors.textFieldBorder,width: 1)
                                        ),
                                        child: Center(
                                          child: Text('0',style: mainSubHeadingStyle().copyWith(color: AppColors.posScreenSelectedTextColor,fontSize:constraints.maxWidth < 800?14:getWidth(context: context)/80,fontWeight: FontWeight.bold ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          if(account.typedPin.isNotEmpty){
                                            account.typedPin.removeLast();
                                          }
                                        });

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.posScreenContainerBackground,
                                            border: Border.all(color: AppColors.textFieldBorder,width: 1)
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.backspace,color: AppColors.posScreenSelectedTextColor,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            SquareButton(onTap: () {
                              log('usertype $userType');
                              account.doLogin(context,'pin',userType!);
                            },
                              title: 'Sign In',
                              width: constraints.maxWidth < 800
                                  ? getWidth(context: context) / 1.2
                                  : getWidth(context: context) / 2,
                              isLoading: account.loginLoading,),
                            verticalSpaceMedium,
                            constraints.maxWidth<800?
                                Column(
                                  children: [
                                    SquareButton(onTap: () {
                                      Get.offAllNamed('/loginScreen');
                                    },
                                      title: 'Sign In With Email',
                                      width: getWidth(context: context) / 1.2,
                                        color: Colors.white,
                                        textColor: Colors.black,

                                      isLoading: false),
                                    verticalSpaceMedium,
                                    SquareButton(onTap: () {
                                      Get.offAllNamed('/mobileScreen');
                                    },
                                        title: 'Sign In With Mobile',
                                        width: getWidth(context: context) / 1.2,
                                        color: Colors.white,
                                        textColor: Colors.black,

                                        isLoading: false),

                                  ],
                                ):
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SquareButton(onTap: () {
                                      Get.offAllNamed('/loginScreen');
                                    },
                                        title: 'Sign In With Email',
                                        width: getWidth(context: context) / 3,
                                        color: Colors.white,
                                        textColor: Colors.black,

                                        isLoading: false),
                                    horizontalSpaceSmall,
                                    SquareButton(onTap: () {
                                      Get.offAllNamed('/mobileScreen');
                                    },
                                        title: 'Sign In With Mobile',
                                        width: getWidth(context: context) / 3,
                                        color: Colors.white,
                                        textColor: Colors.black,

                                        isLoading: false),

                                  ],
                                )

                          ],
                        ),
                      ),
                    ),
                  );
                }

            ),
          );
        }
    );
  }

}
