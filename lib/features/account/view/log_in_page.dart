import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/account/view_model/account_view_model.dart';
import 'package:saloon_pos/features/account/widgets/login_text_field.dart';
import 'package:saloon_pos/features/common_widgets/square_button.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKeyLogin =  GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Consumer2<AccountViewModel,PosScreenViewModel>(
      builder: (context,account,pos,child){
        return Form(
          key: formKeyLogin,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  return Container(
                    height: getHeight(context: context),
                    width: getWidth(context: context),
                    color: Colors.white,
                    child:  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(pos.orgLogo!=null)
                            SizedBox(width:constraints.maxWidth<800?getWidth(context: context)/2:getWidth(context: context)/6,height:constraints.maxWidth<800?getHeight(context: context)/4:getHeight(context: context)/8,child: Image.network(pos.orgLogo!.data!.companyLogo!)),
                          Text('Sign In',style: mainSubHeadingStyle().copyWith(fontSize: constraints.maxWidth<800?32:getWidth(context: context)/45,fontWeight: FontWeight.w600),),
                          constraints.maxWidth<800?verticalSpaceMedium:verticalSpaceLarge,
                          LoginTextField(heading: 'Email',textEditingController: account.emailController,hintText: 'example@gmail.com',),
                          verticalSpaceMedium,
                          LoginTextField(heading: 'Password',textEditingController: account.passwordController,hintText: '',),
                          verticalSpaceMedium,
                          SquareButton(
                            onTap: (){
                              if(formKeyLogin.currentState!.validate()){
                                account.doLogin(context,'email',pos.userType!);
                              }

                            },
                            title: 'Sign In',width:constraints.maxWidth<800?getWidth(context: context)/1.2: getWidth(context: context)/2,isLoading: account.loginLoading,),
                          verticalSpaceMedium,
                          constraints.maxWidth<800?
                          Column(
                            children: [
                              SquareButton(onTap: () {
                                Get.offAllNamed('/pinScreen');
                              },
                                  title: 'Sign In With Pin',
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
                                Get.offAllNamed('/pinScreen');
                              },
                                  title: 'Sign In With Pin',
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
                  );
                }

            ),
          ),
        );
      },

    );
  }
}


