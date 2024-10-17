import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/common_widgets/error_handling_widget.dart';
import 'package:saloon_pos/features/common_widgets/expanded_square_button.dart';
import 'package:saloon_pos/features/common_widgets/no_internet_widget.dart';
import 'package:saloon_pos/features/pos/view/checkout_page_mobile.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/features/pos/widgets/cart_item_list.dart';
import 'package:saloon_pos/features/pos/widgets/category_selector_widget.dart';
import 'package:saloon_pos/features/pos/widgets/header_for_mobile.dart';
import 'package:saloon_pos/features/pos/widgets/header_pos_machine.dart';
import 'package:saloon_pos/features/pos/widgets/payment_method_widget.dart';
import 'package:saloon_pos/features/pos/widgets/price_details_widget.dart';
import 'package:saloon_pos/features/pos/widgets/product_grid_view_pos.dart';
import 'package:saloon_pos/features/pos/widgets/switch_type_bar.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/app_contants.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/themes.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  Timer? timer;
  // final _prefs = SharedPreferencesRepo.instance;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      timer=Timer.periodic(const Duration(seconds: 2), (timer) {
        Provider.of<PosScreenViewModel>(context,listen: false).syncSale();});
       Provider.of<PosScreenViewModel>(context,listen: false).checkAdmin();
      await Provider.of<PosScreenViewModel>(context,listen: false).initiatePosScreen(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton:getWidth(context: context)<800&&pos.posScreenLoading==false&&pos.mobileCheckoutVisible==false?
          Stack(
            children: [
              InkWell(
                onTap: (){
                  pos.onPressCheckoutMobile(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20,bottom: 10),
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.posScreenSelectedTextColor,
                  ),
                  child: const Center(
                    child: Icon(Icons.shopping_cart,color: Colors.white,size: 30,),
                  ),
                ),
              ),

              Positioned(
                right: 0,
                top: 0,
                child: pos.cartCount>0?Container(
                  margin: const EdgeInsets.only(right: 20,bottom: 10),
                  height: 25,
                  width: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child:  Center(
                    child: Text('${pos.cartCount}',style: const TextStyle(color: Colors.white),),
                  ),
                ):Container(
                  height: 25,
                  width: 25,
                  color: Colors.transparent,
                ),
              ),
            ],
          ):Container(),
          body: pos.posScreenLoading?
              SizedBox(
                height: getHeight(context: context),
                width: getWidth(context: context),
                child: const CupertinoActivityIndicator(color: AppColors.posScreenSelectedTextColor),
              ):
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                if(constraints.maxWidth<800){
                  return  Stack(
                    children: [
                      Column(
                        children: [
                          verticalSpaceMedium,
                           HeaderForMobile(),
                          verticalSpaceTiny,
                          Expanded(child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.all(10),
                            width: getWidth(context: context),
                            color: AppColors.posScreenContainerBackground,
                            child:   pos.productScreenLoading
                                ? const Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColors.posScreenSelectedTextColor,
                                ))
                                : pos.productsState == AppStrings.apiNoInternet
                                ? Center(child: NoInternetWidget(onPressed: (){pos.initiatePosScreen(context);}))
                                : pos.productsState == AppStrings.apiError
                                ? Center(
                                  child: ErrorHandlingWidget(onPressed: (){
                                   if( pos.isAdminUser=='true'){
                                     Get.offAllNamed('/reportScreen');
                                   }
                                   else{
                                     pos.initiatePosScreen(context);
                                   }
                            }),
                                ):
                             Column(
                              children: [
                                
                                const SwitchTypeBar(size: 14,),
                                verticalSpaceSmall,
                                const CategorySelectorWidget(size: 14,),
                                verticalSpaceSmall,
                                if(pos.productsAndServiceToBePassedInGridView!=null)
                                ProductsGridView(crossAxisCount: 2,titleSize: 19,priceSize: 16,aspectRatioHeight: 2.5,productsAndService: pos.productsAndServiceToBePassedInGridView!,)
                              ],
                            ),
                          ))
                        ],
                      ),
                      Visibility(
                        visible: pos.mobileCheckoutVisible,
                        child: const CheckoutPageMobile()
                      ),
                    ],
                  );
                }
                else{
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: pos.isEditEnabled? const BorderRadius.all(Radius.circular(20)):null,
                      border: pos.isEditEnabled?Border.all(
                          color: const Color(0xff39FF14),
                          width: 8.0,
                        ):null,

                    ),
                    child: Column(
                      children: [
                        verticalSpaceSmall,
                        const HeaderForPosMachine(),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.all(10),
                            width: getWidth(context: context),
                            color: AppColors.posScreenContainerBackground,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child:   pos.productScreenLoading
                                          ? const Center(
                                              child: CupertinoActivityIndicator(
                                                color: AppColors.posScreenSelectedTextColor,
                                              ))
                                          : pos.productsState == AppStrings.apiNoInternet
                                          ? Center(child: NoInternetWidget(onPressed: (){pos.initiatePosScreen(context);}))
                                          : pos.productsState == AppStrings.apiError
                                          ? Center(
                                            child: ErrorHandlingWidget(onPressed: (){
                                        pos.initiatePosScreen(context);
                                      }),
                                          ):
                                      Column(
                                        children: [
                                          SwitchTypeBar(size: getWidth(context: context) / 75,),
                                          verticalSpaceSmall,
                                          CategorySelectorWidget(size: getWidth(context: context) / 85,),
                                          verticalSpaceSmall,
                                          ProductsGridView(crossAxisCount: 3,titleSize: getWidth(context: context) / 60,priceSize: getWidth(context: context) / 80,aspectRatioHeight: 1.5,productsAndService: pos.productsAndServiceToBePassedInGridView!),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 5,right: 5),
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: ListView(
                                        children: [
                                          CartItemList(size: getWidth(context: context)/100,dropDownWidth: getWidth(context: context)/8,containerHeight: getHeight(context: context)/10,cartHeight: getHeight(context: context)/2.9,),
                                          verticalSpaceSmall,
                                          PriceDetailsWidget(size: getWidth(context: context)/100,discountWidth: getWidth(context: context)/15,),
                                          verticalSpaceSmall,
                                          if(pos.paymentDropDown.isNotEmpty)
                                            PaymentMethodWidget(size: getWidth(context: context)/100,listViewHeight: getHeight(context: context)/7.5,padding: 22,dropDownTextSize: getWidth(context: context)/100,),
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: AppColors.posScreenSelectedTextColor,
                                                value: pos.otBills,
                                                onChanged: (value){
                                                  pos.changeOtBills(value!);
                                                },shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)),),
                                              horizontalSpaceTiny,
                                              Text('OTBILL',style: mainSubHeadingStyle().copyWith(fontSize: getWidth(context: context)/100,color: Colors.black),),

                                            ],
                                          ),verticalSpaceTiny,
                                          Row(
                                            children: [
                                              ExpandedSquareButton(onTap: (){pos.clearCart(context);}, title: 'CANCEL', textColor: AppColors.cancelColor,color: AppColors.posScreenContainerBackground,),
                                              horizontalSpaceSmall,
                                              ExpandedSquareButton(onTap: ()async{
                                                // bool validation=await pos.validateFormKeys(context);
                                                // if(validation){
                                                log('check validate');
                                                double totalAmountCollected=0;
                                                for(int i=0;i<pos.paymentMethods.length;i++){
                                                  totalAmountCollected=totalAmountCollected+(pos.paymentControllers[i].text.isNotEmpty?double.parse(pos.paymentControllers[i].text):0.0);
                                                }
                                                log('fff$totalAmountCollected');
                                                if(totalAmountCollected<(pos.total-pos.discount)){
                                                  // ignore: use_build_context_synchronously
                                                  Themes.showSnackBar(msg: 'You have not collected the full amount',context: context);
                                                }
                                                else if(totalAmountCollected>(pos.total-pos.discount)){
                                                  // ignore: use_build_context_synchronously
                                                  Themes.showSnackBar(msg: 'You have collected more than full amount',context: context);
                                                }
                                                else{
                                                  for(int i=0;i<pos.paymentMethods.length;i++){
                                                    await pos.onChangedPaymentAmount(i, pos.paymentControllers[i].text);
                                                  }
                                                  // ignore: use_build_context_synchronously
                                                  await pos.saveSingleSale(context);

                                                }




                                              },title: 'PAY & PRINT',textColor: Colors.white,color: AppColors.posScreenSelectedTextColor,)
                                            ],
                                          )


                                        ],

                                      ),
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }

          ),
        );
      },

    );
  }
}








