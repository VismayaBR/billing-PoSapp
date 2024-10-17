import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:saloon_pos/app_config/api_services.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/helper/app_contants.dart';

import '../../../app_config/api.dart';
import '../../../app_config/server_addresses.dart';

class PosRepository{
  ApiServices httpService = ApiServices();
  final _prefs = SharedPreferencesRepo.instance;
  fetchEmployeeDesignation() async {
    try {
      http.Response response=await httpService.request(url:'${ServerAddresses.baseUrl}${Api.employeeDesignation}' , method: Method.post,params: {'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchCategories({String? type,}) async {
    try {
      http.Response response=await httpService.request(url:'${ServerAddresses.baseUrl}${type=='Product'?Api.productCategories:Api.serviceCategories}' , method: Method.post,params: {'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchLogo() async {
    try {
      log('ServerAddresses.logoUrl ${ServerAddresses.logoUrl}');
      http.Response response=await httpService.request(url:ServerAddresses.logoUrl , method: Method.post,params: {'branch_id':_prefs!.getInt(AppStrings.branchId)});
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchDayStatus(String date, type) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.dayCloseOpen,
          method: Method.post,params: {type:date,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchDaySummary({String? fromDate,String? toDate}) async {
    try {
      log('inside fertch day${ServerAddresses.baseUrl+Api.daySummary}');
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.daySummary, method: Method.post,params: {"from_date":fromDate,"to_date":toDate,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log('summary response ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchDayCloseSummary({String? fromDate,String? toDate}) async {
    try {
      log('inside fertch day${ServerAddresses.baseUrl+Api.dayCloseSummary}');
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.dayCloseSummary, method: Method.post,params: {"from_date":fromDate,"to_date":toDate,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log('dayClose response ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchUserDetails() async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.userDetails, method: Method.post,params: {'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log('User Details ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchDaySummaryAdmin({String? fromDate,String? toDate,int? id}) async {
    try {
      log('inside fertch day admin ${ServerAddresses.baseUrl+Api.daySummary}');
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.daySummary, method: Method.post,params: {"from_date":fromDate,"to_date":toDate,"employee_id":id,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log('summary response ${response.statusCode}');
      log('daySummary response ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchProductsAndService({String? type, required category_id,}) async {
    String type='Product';
    try {
      http.Response response=await httpService.request(url:'${ServerAddresses.baseUrl}${type=='Product'?Api.productList:Api.productList}' , method: Method.post,params: {'category_id':category_id});
      log('__________________${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  
 productsSearch(String barcode) async {
  try {
    String type = 'Product';
    http.Response response = await httpService.request(
      url: '${ServerAddresses.baseUrl}${type == 'Product' ? Api.productSearch : Api.productSearch}',
      method: Method.post,
      params: {'barcode': barcode},
    );
    log(response.body);
    return jsonDecode(response.body);
  } catch (e) {
    log('Error in productsSearch: $e');
    return null;
  }
}


  fetchEmployees() async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.employeeList , method: Method.post,params: {'branch_id':_prefs!.getInt(AppStrings.branchId)});
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchPayments() async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.paymentList , method: Method.post,params: {'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchSyncedSalesAdminView({String? fromDate,String? toDate,int? id}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.syncedSales , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,"employee_id":id,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }
  fetchSyncedSales({String? fromDate,String? toDate}) async {
    log('this is being done');
    log('${_prefs!.getInt(AppStrings.branchId)}');
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.syncedSales , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  fetchCommissionDayWiseAdmin({String? fromDate,String? toDate,int? id}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.commissionDayWise , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,"employee_id":id,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchCommissionDayWise({String? fromDate,String? toDate}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.commissionDayWise , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchCommissionSummary({String? fromDate,String? toDate}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.commissionDayWise , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchCommissionSummaryAdmin({String? fromDate,String? toDate,int? id}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.commissionDayWise , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,"employee_id":id,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchEmployeeSummaryAdmin({String? fromDate,String? toDate,int? id}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.employeeSummary, method: Method.post,params: {"from_date":fromDate,"to_date":toDate,"employee_id":id,'branch_id':_prefs!.getInt(AppStrings.branchId)});

      log(response.body);
      
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchBranches() async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.branchList, method: Method.post,params: {'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log('branches${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchItemReport({String? fromDate,String? toDate}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.itemReport , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchItemReportAdmin({String? fromDate,String? toDate,int? id}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.itemReport , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,"employee_id":id,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchTotalValues({String? fromDate,String? toDate}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.totalValues , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }
  fetchTotalValuesAdmin({String? fromDate,String? toDate,int? id}) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.totalValues , method: Method.post,params: {"from_date":fromDate,"to_date":toDate,"employee_id":id,'branch_id':_prefs!.getInt(AppStrings.branchId)});
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  fetchCustomerName(String mobile) async {
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.customerByMobile , method: Method.post,params: {
        'mobile':mobile,'branch_id':_prefs!.getInt(AppStrings.branchId)
      });
      log(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  saleSync({String? employeeId,Map<String,dynamic>? saleToSync})async{
    try {
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.saleSync, method: Method.post,params:saleToSync);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  createService({Map<String,dynamic>? createParam})async{
    try {
      log('createService: ${ServerAddresses.baseUrl+Api.createService}, $createParam');
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.createService, method: Method.post,params:createParam);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }

  createEmployee({Map<String,dynamic>? createParam})async{
    try {
      log('createEmployee: ${ServerAddresses.baseUrl+Api.createEmployee}, $createParam');
      http.Response response=await httpService.request(url:ServerAddresses.baseUrl+Api.createEmployee, method: Method.post,params:createParam);
      return jsonDecode(response.body);
    } catch (e) {
      log('catch');
      log(e.toString());
    }
  }



}