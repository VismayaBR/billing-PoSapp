import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:saloon_pos/app_config/api_services.dart';

import '../../../app_config/api.dart';
import '../../../app_config/server_addresses.dart';

class AccountRepository{
  ApiServices httpService = ApiServices();

  login({String? method,String? email,String? password,String? mobile,String? pin,String? userType}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.login , method: Method.post,params: {
        'email': email,
        'password': password,
        'method':method,
        'mobile':mobile,
        'userType':userType,
      });
      log('login response ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }





}