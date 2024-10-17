import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/themes.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class PaymentMethodWidget extends StatefulWidget {
  final double size;
  final double listViewHeight;
  final double padding;
  final double  dropDownTextSize;
  const PaymentMethodWidget({
    super.key,
    required this.size,
    required this.listViewHeight,
    required this.padding,
    required this.dropDownTextSize
  });

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return SizedBox(
          height: widget.listViewHeight,
          child: ListView.builder(
            controller: pos.paymentMethodScrollController,
            padding: EdgeInsets.zero,
            itemCount: pos.paymentMethods.length,
            itemBuilder: (context,index){
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:7,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: AppColors.textFieldBorder,width: 1)
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(flex:3,child: Text('Payment Method',style:mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: widget.size))),
                                  Expanded(flex:2,child: Container(
                                    width: getWidth(context: context)/10,
                                    height: 30,
                                    padding: const EdgeInsets.only(left:10,right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.textFieldBorder,width: 2),
                                        borderRadius: const BorderRadius.all(Radius.circular(8))
                                    ),
                                    child: SizedBox(
                                      child: DropDown<String>(
                                        customWidgets:
                                        pos.paymentDropDown[index].map((e) => Text(e,style:  TextStyle(overflow: TextOverflow.ellipsis,fontSize:widget.dropDownTextSize))).toList(),
                                        showUnderline: false,
                                        isExpanded: true,
                                        initialValue: pos.isEditEnabled?pos.paymentDropDown[index][pos.paymentDropDown[index].indexWhere((element) => element==pos.paymentMethods[index].type)]:pos.paymentDropDown[index][1],
                                        items: pos.paymentDropDown[index],
                                        onChanged: (value) {
                                          pos.onChangedPaymentType(index,value!,);

                                        },
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              verticalSpaceSmall,
                              Row(
                                children: [
                                  Expanded(flex:3,child: Text('Amount',style:mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: widget.size))),
                                  Expanded(flex:2,child: AmountTextField(textEditingController: pos.paymentControllers[index],size: widget.size,index: index,boxSize: 30,))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      horizontalSpaceSmall,

                      Expanded(
                        flex:1,
                        child: Column(
                          children: [
                            index+1==pos.paymentMethods.length&&index+1<pos.paymentTypes.length?
                            InkWell(
                              onTap: (){
                                if(pos.paymentControllers[index].text.isNotEmpty) {
                                  double totalAmountCollected = 0;
                                  for (int i = 0; i <
                                      pos.paymentMethods.length; i++) {
                                    totalAmountCollected =
                                        totalAmountCollected + (double.parse(
                                            pos.paymentControllers[i].text));
                                  }
                                  if (totalAmountCollected >
                                      (pos.total - pos.discount)) {
                                    Themes.showSnackBar(
                                        msg: 'You have collected more than full amount',
                                        context: context);
                                  }
                                  else {
                                    if (index == 0) {
                                      if (double.parse(
                                          pos.paymentControllers[index].text) ==
                                          (pos.subTotal - pos.discount)) {
                                        Themes.showSnackBar(
                                            msg: 'You have collected total amount',
                                            context: context);
                                      }
                                      else {
                                        pos.onChangedPaymentAmount(index,
                                            pos.paymentControllers[index].text);
                                        pos.addPaymentMethodsToDropDown(index);
                                        pos.onAddPayment(
                                            pos.paymentDropDown[index + 1][0],
                                            '0');
                                        Future.delayed(const Duration(
                                            milliseconds: 500), () {
                                          pos.paymentMethodScrollController
                                              .animateTo(
                                            pos.paymentMethodScrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeOut,
                                          );
                                        });
                                      }
                                    }
                                    else {
                                      log('catch else');
                                      double totalPaid = 0;
                                      for (int i = 0; i <
                                          pos.paymentMethods.length; i++) {
                                        totalPaid = totalPaid + double.parse(
                                            pos.paymentControllers[i].text);
                                      }

                                      if (totalPaid ==
                                          (pos.subTotal - pos.discount)) {
                                        Themes.showSnackBar(
                                            msg: 'You have collected total amount',
                                            context: context);
                                      }
                                      else {
                                        pos.onChangedPaymentAmount(index,
                                            pos.paymentControllers[index].text);
                                        pos.addPaymentMethodsToDropDown(index);
                                        pos.onAddPayment(
                                            pos.paymentDropDown[index + 1][0],
                                            '0');
                                        Future.delayed(const Duration(
                                            milliseconds: 500), () {
                                          pos.paymentMethodScrollController
                                              .animateTo(
                                            pos.paymentMethodScrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeOut,
                                          );
                                        });
                                      }
                                    }
                                  }
                                }



                              },
                              child: Container(
                                height: 30,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.posScreenContainerBackground,
                                ),
                                child: const Center(child: Icon(Icons.add,color: AppColors.posScreenSelectedTextColor,size: 20,)),
                              ),
                            ):Container(),
                            verticalSpaceTiny,
                            index!=0&&(index+1==pos.paymentMethods.length)?
                            InkWell(
                              onTap: (){
                                pos.onDeletePaymentMethod(index);
                                },
                              child: Container(
                                height: 30,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.posScreenContainerBackground,
                                ),
                                child:  Center(child: Container(height: 2,color: AppColors.posScreenSelectedTextColor,margin: EdgeInsets.only(left: widget.padding,right: widget.padding),)),
                              ),
                            ):Container(),


                          ],
                        ),
                      ),

                    ],
                  ),
                  verticalSpaceSmall,
                ],
              );
            },

          ),
        );
      },

    );
  }
}

class AmountTextField extends StatelessWidget {

  final TextEditingController textEditingController;
  final double size;
  final int index;
  final double boxSize;



  const AmountTextField({
    super.key,
    required this.textEditingController,
    required this.size,
    required this.index,
    this.boxSize=50


  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: boxSize,
              child: TextFormField(
                style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontSize: size),
                controller: textEditingController,
                cursorColor: AppColors.textFieldTextColor,
                decoration: InputDecoration(
                  hintStyle: textFieldStyle(),
                  fillColor: AppColors.textFieldFill,
                  contentPadding: const EdgeInsets.only(left: 20.0,right: 5),

                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.textFieldBorder,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.textFieldBorder,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.textFieldBorder,
                        width: 1
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 1,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),],

                keyboardType: const TextInputType.numberWithOptions(decimal: true),

              ),
            ),
          ],
        );
      },
    );
  }
}