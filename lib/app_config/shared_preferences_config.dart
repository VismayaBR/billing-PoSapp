import 'dart:developer';

import 'package:saloon_pos/helper/app_contants.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SharedPreferencesRepo{
  static SharedPreferences? _prefs;
  static SharedPreferencesRepo? _instance;

  SharedPreferencesRepo._(SharedPreferences prefs){
    _prefs=prefs;
  }

  static SharedPreferencesRepo? get instance =>_instance;

  static Future<void> initialize() async{
    _instance??=SharedPreferencesRepo._(await SharedPreferences.getInstance());
  }



  bool checkLoggedIn(){
    bool? loggedIn=_prefs!.getBool(AppStrings.loggedIn);
    if(loggedIn==null){
      return false;
    }
    else{
      return loggedIn;
    }
  }
  String checkOrgName(){
    String? orgName=_prefs!.getString(AppStrings.orgNameSet);
    if(orgName==null){
      return '';
    }
    else{
      return orgName;
    }
  }
  String checkUserType(){
    String? userType=_prefs!.getString(AppStrings.userType);
    if(userType==null){
      return '';
    }
    else{
      return userType;
    }
  }
  bool checkAdminUSer(){
    String? isAdmin=_prefs!.getString(AppStrings.userIsAdmin);
    log('isAdmin $isAdmin');
    if(isAdmin=='true'){
      return true;
    }
    else{
      return false;
    }
  }

  bool checkPunchedIn(){
    bool? punchedIn=_prefs!.getBool(AppStrings.punchedIn);
    if(punchedIn==null){
      return false;
    }
    else{
      return punchedIn;
    }
  }

  // void setLoggedIn(){
  //   _prefs.setBool('gulf_islamic_loggedIn', true);
  // }
  //
  // void setOnBoarding({String currency,String symbol}){
  //   _prefs.setBool('gulf_islamic_onBoarding', true);
  //   _prefs.setString('gulf_islamic_currency',currency);
  //   _prefs.setString('gulf_islamic_symbol',symbol);
  //
  // }
  //
  // void setLoginDetails({String userId,String userName,String emailId,String userNumber,String lname}){
  //   _prefs.setString('gulf_islamic_user_id', userId);
  //   _prefs.setString('gulf_islamic_user_name', userName);
  //   _prefs.setString('gulf_islamic_user_last_name', lname);
  //   _prefs.setString('gulf_islamic_email_id', emailId);
  //   _prefs.setString('gulf_islamic_user_number', userNumber);
  //
  // }
  //
  void setString(String key,String value){
    _prefs!.setString(key, value);
  }

  void setInt(String key,int value){
    _prefs!.setInt(key, value);
  }
  void setBool(String key,bool value){
    _prefs!.setBool(key, value);
  }
  String? getString(String key){
    return _prefs!.getString(key);
  }

  int? getInt(String key){
    return _prefs!.getInt(key);
  }
  //
  // void setLanguage(List<String> values){
  //   _prefs.setStringList('gulf_islamic_language',values );
  // }
  // getLanguage(){
  //   return _prefs.getStringList('gulf_islamic_language');
  // }
  //
  // void clear(String key){
  //   _prefs.remove(key);
  // }
  //
  void clearAll(){
    _prefs!.remove(AppStrings.loggedIn);
    // _prefs!.remove(AppStrings.userId);
    _prefs!.remove(AppStrings.userName);
    _prefs!.remove(AppStrings.userEmail);
    _prefs!.remove(AppStrings.punchedIn);
    _prefs!.remove(AppStrings.userDate);
    _prefs!.remove(AppStrings.userBillCount);
    _prefs!.remove(AppStrings.userIsAdmin);

  }



}