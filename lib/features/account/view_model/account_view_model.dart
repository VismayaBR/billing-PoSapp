import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saloon_pos/app_config/data_base_helper.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/features/account/domain/account_repository.dart';
import 'package:saloon_pos/features/account/model/login_model.dart';
import 'package:saloon_pos/helper/app_contants.dart';
import 'package:saloon_pos/helper/themes.dart';

class AccountViewModel with ChangeNotifier{
  final _prefs = SharedPreferencesRepo.instance;

//Check Internet
  Future<bool> checkInternet()async{
    bool internetAvailable=true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
      internetAvailable=true;
      return internetAvailable;
    } else {
      internetAvailable=false;
      return internetAvailable;
    }
  }

  //Login
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController mobileController=TextEditingController();
  bool loginLoading=false;
  LoginModel? login;
  // List<String> numbers=['1','2','3','4','5','6','7','8','9','*','0','#'];
  List<String> numbers=['1','2','3','4','5','6','7','8','9'];
  List<String> typedPin=[];

  doLogin(BuildContext context,String method,String userType) async {
    if(method=='pin'&&typedPin.isEmpty){
      // ignore: use_build_context_synchronously
      Themes.showSnackBar(
          context: context,
          msg: 'Please Enter your pin');
    }
    else{

      loginLoading = true;
      notifyListeners();
      bool internetAvailable = await checkInternet();
      if (internetAvailable == true) {
        try {
          login =
              LoginModel.fromMap(await AccountRepository().login(email: emailController.text,password: method=='pin'?typedPin.join():passwordController.text,method:method,mobile: mobileController.text,userType: userType));
          notifyListeners();
          if (login!.success == true) {
            loginLoading = false;
            // login!.data!.user!.adminFlag='true';
            notifyListeners();
            List<User> userDetails =await DataBaseHelper.instance.getUserDetails();
            List<User> user=userDetails.where((element) => element.id==login!.data!.user!.id).toList();
            var localSales = await DataBaseHelper.instance.getLocalSale();
            User userObj = login!.data!.user!;
            int lastBill=login!.data!.user!.salesCount!;
            var pinInt = int.parse(typedPin.join());
            userObj.salesCount=lastBill+1;
            assert(pinInt is int);
            userObj.pin = pinInt;
            if(login!.data!.user!.salesCount==0){
              if(user.length==1){
                await DataBaseHelper.instance.editUser(login!.data!.user!);
                // _prefs!.setInt('salesCount',lastBill+1);
              }else{
                await DataBaseHelper.instance.add(login!.data!.user!);
                // _prefs!.setInt('salesCount',lastBill+1);
              }
            }
            else{
              if(localSales.isNotEmpty){
                if(user.length==1){
                  // await DataBaseHelper.instance.editUser(userObj);
                  // _prefs!.setInt('salesCount',lastBill+1);
                }else{
                  await DataBaseHelper.instance.add(login!.data!.user!);
                  // _prefs!.setInt('salesCount',lastBill+1);
                }
              }
              else{
                if(user.length==1){
                  await DataBaseHelper.instance.editUser(login!.data!.user!);
                  // _prefs!.setInt('salesCount',lastBill+1);
                }else{
                  await DataBaseHelper.instance.add(login!.data!.user!);
                  // _prefs!.setInt('salesCount',lastBill+1);
                }
              }
            }
            _prefs!.setBool(AppStrings.loggedIn, true);
            _prefs!.setBool(AppStrings.punchedIn, true);
            _prefs!.setString(AppStrings.userToken, login!.data!.user!.token??'');
            _prefs!.setString(AppStrings.userName, login!.data!.user!.name??'');
            _prefs!.setString(AppStrings.userEmail, login!.data!.user!.email??'');
            _prefs!.setString(AppStrings.userDate, login!.data!.user!.loggedAt??'');
            _prefs!.setString(AppStrings.userId,login!.data!.user!.id.toString());
            _prefs!.setString(AppStrings.userIsAdmin,login!.data!.user!.adminFlag??'false');
            _prefs!.setString('openingDate',login!.data!.user!.openingDate??'');
            _prefs!.setString('code',login!.data!.user!.code.toString());
            _prefs!.setInt(AppStrings.branchId, login!.data!.user!.branchId!);
            log('openingDat${login!.data!.user!.openingDate}');






            // if(_prefs!.getInt(AppStrings.userBillCount)==null){
            //   _prefs!.setInt(AppStrings.userBillCount, 1);
            // }
            emailController.clear();
            passwordController.clear();
            mobileController.clear();
            typedPin=[];
            notifyListeners();
            if(login!.data!.user!.adminFlag=='true'){
              Get.offAllNamed('/reportScreen');
            }
            else{
              Get.offAllNamed('/posScreen');
            }
          } else {
            // ignore: use_build_context_synchronously
            Themes.showSnackBar(
                context: context,
                msg: login!.message);
            loginLoading = false;
            notifyListeners();
          }
        } catch (e) {
          log('chi');
          log(e.toString());
          // ignore: use_build_context_synchronously
          Themes.showSnackBar(
              context: context,
              msg: "An error occurred");
          loginLoading = false;
          notifyListeners();
        }
      } else {
        if(method!='pin'){
          // ignore: use_build_context_synchronously
          Themes.showSnackBar(
              context: context,
              msg: "No Internet Connection");
          loginLoading = false;
          notifyListeners();
        }
        else{
          log('comeon');
          List<User> userDetails =await DataBaseHelper.instance.getUserDetails();
          List<User> user=userDetails.where((element) => element.pin==int.parse(typedPin.join())).toList();


          if(user.length==1){
            _prefs!.setBool(AppStrings.loggedIn, true);
            _prefs!.setBool(AppStrings.punchedIn, true);
            _prefs!.setString(AppStrings.userToken, user[0].token??'');
            _prefs!.setString(AppStrings.userName, user[0].name??'');
            _prefs!.setString(AppStrings.userEmail, user[0].email??'');
            _prefs!.setString(AppStrings.userDate, DateTime.now().toString());
            _prefs!.setString(AppStrings.userId, user[0].id.toString());
            _prefs!.setString(AppStrings.userIsAdmin,user[0].adminFlag??'false');
            _prefs!.setInt(AppStrings.branchId,user[0].branchId!);
            _prefs!.setString('code',user[0].code.toString());
            // _prefs!.setInt('salesCount', user[0].salesCount!+1);
            // await DataBaseHelper.instance.editUser(userObj);


            // _prefs!.setString(AppStrings.openingDate, user[0].openingDate!);


            loginLoading = false;
            notifyListeners();
            //Get.offAllNamed('/posScreen');
            if(user[0].adminFlag == "true"){
              Get.offAllNamed('/reportScreen');
            }
            else{
              Get.offAllNamed('/posScreen');
            }
          }
          else{
            log('inge');
            // ignore: use_build_context_synchronously
            Themes.showSnackBar(
                context: context,
                msg: "No Internet Connection");
            loginLoading = false;
            notifyListeners();
          }
        }



        }

      }
    }

  }
checkInvoiceExist(){


}