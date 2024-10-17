import 'package:flutter/material.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class LoginTextField extends StatelessWidget {
  final String heading;
  final TextEditingController textEditingController;
  final String hintText;
  const LoginTextField({
    super.key,
    required this.heading,
    required this.textEditingController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heading,style: mainSubHeadingStyle().copyWith(fontSize:constraints.maxWidth<800?16: getWidth(context: context)/90),),
            verticalSpaceSmall,
            SizedBox(
              width: constraints.maxWidth<800?getWidth(context: context)/1.2:getWidth(context: context)/2,
              child: TextFormField(
                style: textFieldStyle(),
                controller: textEditingController,
                obscureText: heading=='Password'?true:false,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: textFieldStyle(),
                  fillColor: AppColors.textFieldFill,
                  labelStyle: textFieldStyle(),
                  contentPadding: const EdgeInsets.only(left: 20.0),
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
                keyboardType: TextInputType.text,
                validator: (value) {
                  if(heading=='Email'){
                    if (RegExp(emailPattern).hasMatch(value!) == false) {
                      return "Enter a Valid Email";
                    }
                  }
                  else if(heading=='Password'){
                    if(value!.isEmpty){
                      return "Enter your Password";
                    }
                  }
                  else{
                    if(value!.isEmpty||value.length<10){
                      return "Enter a Valid Number";
                    }

                  }

                  return null;
                },


                // validator: (value) {
                //
                // },
              ),
            ),
          ],
        );
      }

    );
  }
}