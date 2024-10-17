import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/features/pos/model/sale_model.dart';
import 'package:saloon_pos/helper/app_contants.dart';

import '../app_config/server_addresses.dart';


enum Method { post, get, put, delete, patch }

class ApiServices {
  ServerAddresses serverAddresses = ServerAddresses();
  final _prefs = SharedPreferencesRepo.instance;
  String? token;
  ApiServices() {
    String? tokenFetched=_prefs!.getString(AppStrings.userToken);
    token='';
    if(tokenFetched==null||tokenFetched==''){
      token='';
    }
    else{
      token=tokenFetched;
      log('token$token');
    }

  }

  header() => {
    'content-type': "application/json",
    'authorization':'Bearer $token'
  };


  Future<dynamic> request(
      {String? url,
        Method? method,
        Map<String, dynamic>? params,
        String? token}) async {
    http.Response response;

    try {
      log('reach');
      if (method == Method.post) {
        response = await http.post(Uri.parse(url!),
            body: jsonEncode(params), headers: header());
      }
      // else if (method == Method.delete) {
      //   response = await http.delete(Uri.parse(url),
      //       body: params, headers: removeAuth?null:header(removeAuth,token: token));
      // }
      else if (method == Method.patch) {
        response =
        await http.patch(Uri.parse(url!), body: params, headers: header());
        log(response.statusCode.toString());
        log(params.toString());
      } else if (method == Method.put) {
        response =
        await http.put(Uri.parse(url!), body: params, headers: header());
      } else {
        log('get');
        response = await http.get(Uri.parse(url!), headers: header());
        log('staat${response.statusCode}');
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return response;
      } else if (response.statusCode == 400) {
        return response;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something went wrong");
      }
    } on SocketException catch (e) {
      log(e.toString());
      throw Exception("No Internet Connection");

    } on FormatException catch (e) {
      log(e.toString());
      throw Exception("Bad response format");
    } catch (e) {
      log(e.toString());
      log('soma');
      throw Exception("Something went wrong");
    }
  }

  Future<dynamic> requestForSync(
      {String? url,
        Method? method,
        List<SaleModel>? params,
        String? token}) async {
    http.Response response;

    try {
      log('reach');
      if (method == Method.post) {
        response = await http.post(Uri.parse(url!),
            body: jsonEncode(params), headers: header());
      }
      // else if (method == Method.delete) {
      //   response = await http.delete(Uri.parse(url),
      //       body: params, headers: removeAuth?null:header(removeAuth,token: token));
      // }
      else if (method == Method.patch) {
        response =
        await http.patch(Uri.parse(url!), body: params, headers: header());
        log(response.statusCode.toString());
        log(params.toString());
      } else if (method == Method.put) {
        response =
        await http.put(Uri.parse(url!), body: params, headers: header());
      } else {
        log('get');
        response = await http.get(Uri.parse(url!), headers: header());
        log('staat${response.statusCode}');
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return response;
      } else if (response.statusCode == 400) {
        return response;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something went wrong");
      }
    } on SocketException catch (e) {
      log(e.toString());
      throw Exception("No Internet Connection");

    } on FormatException catch (e) {
      log(e.toString());
      throw Exception("Bad response format");
    } catch (e) {
      log('soma');
      throw Exception("Something went wrong");
    }
  }
}
