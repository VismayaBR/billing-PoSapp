import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/account/view_model/account_view_model.dart';
import 'package:saloon_pos/features/common_widgets/square_button.dart';
import 'package:saloon_pos/features/pos/domain/pos_repository.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/assets.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

import '../view/product_details.dart';

class HeaderForMobile extends StatefulWidget {
  HeaderForMobile({super.key});

  @override
  State<HeaderForMobile> createState() => _HeaderForMobileState();
}

class _HeaderForMobileState extends State<HeaderForMobile> {
  TextEditingController barcodeController = TextEditingController();
  final PosRepository posRepository =
      PosRepository(); // Initialize PosRepository

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Consumer2<PosScreenViewModel, AccountViewModel>(
        builder: (context, pos, account, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 93, 93, 93).withOpacity(
                                    0.2), // Adjust color and opacity for shadow
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo.jpeg'),
                          ),
                        ),

                        // Clip(
                        //   height: 50,width: 50,
                        //   child: Image.asset('assets/images/logo.jpeg')),
                        horizontalSpaceTiny,
                        Text(
                          pos.userName ?? 'Unknown User',
                          style: mainSubHeadingStyle().copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        horizontalSpaceTiny,
                        horizontalSpaceTiny,
                        Text(
                          pos.openingDate != null && pos.openingDate!.isNotEmpty
                              ? pos.changeDateFormat(pos.openingDate!)
                              : pos.changeDateFormat(
                                  DateTime.now().toString().substring(0, 10)),
                          style: mainSubHeadingStyle().copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: pos.openingDate != null &&
                                    pos.checkOpeningDate(pos.openingDate!)
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SquareButton(
                      onTap: () {
                        pos.punchOut(context);
                      },
                      title: pos.punchedIn ? 'Log Out' : 'Log In',
                      width: 100,
                      height: 40,
                      textSize: 14,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                InkWell(
                  onTap: () {
                    Get.toNamed('/reportScreen');
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: AppColors.posScreenColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.salesReportIcon),
                        horizontalSpaceSmall,
                        Text(
                          'Sales Report',
                          style: mainSubHeadingStyle().copyWith(
                            color: AppColors.posScreenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpaceSmall,
                verticalSpaceSmall,
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        try {
                          // Scan barcode
                          String barcode =
                              await FlutterBarcodeScanner.scanBarcode(
                            '#ff6666', // Line color
                            'Cancel', // Cancel button text
                            true, // Show flash icon
                            ScanMode.BARCODE, // Scan mode
                          );

                          // Check if the scan was successful
                          if (barcode != '-1') {
                            // Set the barcode in the controller
                            barcodeController.text = barcode;

                            // Perform the product search
                            var response =
                                await posRepository.productsSearch(barcode);
                            print(response); // Print the response

                            // Check the response
                            if (response != null &&
                                response is Map<String, dynamic> &&
                                response['success'] == true) {
                              // Navigate to Product Details Screen
                              Get.to(() =>
                                  ProductDetailsScreen(product: response));
                            } else {
                              // Show snackbar if product is not found
                              Get.snackbar('Error',
                                  response['message'] ?? 'Product not found.');
                            }
                          }
                        } catch (e) {
                          Get.snackbar('Error',
                              'An error occurred while scanning the barcode.');
                        }
                      },
                      icon: Icon(Icons.qr_code),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: barcodeController,
                        style: textFieldStyle(),
                        decoration: InputDecoration(
                          hintText: 'Barcode',
                          prefixIcon: Icon(
                            Icons.barcode_reader,
                            color: AppColors.textFieldTextColor,
                          ),
                          hintStyle: textFieldStyle(),
                          fillColor: AppColors.textFieldFill,
                          labelStyle: textFieldStyle(),
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.textFieldBorder,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.textFieldBorder,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.textFieldBorder,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        FocusScope.of(context)
                            .unfocus(); // Dismiss the keyboard
                        String barcode = barcodeController.text;

                        if (barcode.isNotEmpty) {
                          try {
                            var response =
                                await posRepository.productsSearch(barcode);
                            print(response); // Print the response

                            // Check the response
                            if (response != null &&
                                response is Map<String, dynamic> &&
                                response['success'] == true) {
                              // Navigate to Product Details Screen
                              Get.to(() =>
                                  ProductDetailsScreen(product: response));
                            } else {
                              // Show snackbar if product is not found
                              Get.snackbar('Error',
                                  response['message'] ?? 'Product not found.');
                            }
                          } catch (e) {
                            Get.snackbar('Error',
                                'An error occurred while searching for the product.');
                          }
                        } else {
                          Get.snackbar('Error', 'Barcode field is empty.');
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
  
}
