import 'package:flutter/material.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class ErrorHandlingWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const ErrorHandlingWidget({Key? key,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpaceMedium,
          const Text('Oops',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          verticalSpaceSmall,
          Container(
              margin: const EdgeInsets.only(left: 20,right: 20),
              child: const Text('The page cant be found',style:TextStyle(fontSize: 20,fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
          verticalSpaceMedium,
          InkWell(
            onTap: onPressed,
            child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.only(left:20,right: 20,top: 10,bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: AppColors.posScreenSelectedTextColor,width: 1)
                ),
                child: const Text('Go Home',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.posScreenSelectedTextColor))
            ),
          )
        ],
      ),
    );
  }
}
