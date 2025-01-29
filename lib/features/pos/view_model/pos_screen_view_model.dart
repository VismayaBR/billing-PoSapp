// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
import 'dart:io' show File, Platform;
import 'package:barcode/barcode.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:get/get.dart';
import 'package:saloon_pos/app_config/data_base_helper.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/features/account/model/login_model.dart';
import 'package:saloon_pos/features/account/view/mpin_login.dart';
import 'package:saloon_pos/features/common_widgets/square_button.dart';
import 'package:saloon_pos/features/pos/domain/pos_repository.dart';
import 'package:saloon_pos/features/pos/model/add_employee_model.dart';
import 'package:saloon_pos/features/pos/model/branch_model.dart';
import 'package:saloon_pos/features/pos/model/category_model.dart';
import 'package:saloon_pos/features/pos/model/commission_day_wise_model.dart';
import 'package:saloon_pos/features/pos/model/customer_fetch_by_mobile_model.dart';
import 'package:saloon_pos/features/pos/model/daySummary_model.dart';
import 'package:saloon_pos/features/pos/model/day_close_open_model.dart';
import 'package:saloon_pos/features/pos/model/day_close_report_model.dart';
import 'package:saloon_pos/features/pos/model/employee_model.dart';
import 'package:saloon_pos/features/pos/model/fetch_synced_model.dart';
import 'package:saloon_pos/features/pos/model/item_wise_model.dart';
import 'package:saloon_pos/features/pos/model/payment_method_model.dart';
import 'package:saloon_pos/features/pos/model/payment_model.dart';
import 'package:saloon_pos/features/pos/model/products_model.dart';
import 'package:saloon_pos/features/pos/model/sale_model.dart';
import 'package:saloon_pos/features/pos/model/sale_synced_model.dart';
import 'package:saloon_pos/features/pos/model/service_response_model.dart';
import 'package:saloon_pos/features/pos/model/single_local_sale_model.dart';
import 'package:saloon_pos/features/pos/model/total_values_model.dart';
import 'package:saloon_pos/features/pos/widgets/pos_text_field.dart';
import 'package:saloon_pos/helper/app_contants.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/themes.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'package:translator/translator.dart';

import '../../../app_config/server_addresses.dart';
import '../../../helper/app_colors.dart';
import '../../account/model/logo_model.dart';
import '../model/employee_designation_model.dart';

class PosScreenViewModel with ChangeNotifier {
  final _prefs = SharedPreferencesRepo.instance;
  int? selectedEmployeeId;
  String selectedReportType = 'Summary-Billwise';
  String selectedProductService = 'Products';
  String changeDateFormat(String date) {
    String newDate = '';
    if (date.isNotEmpty) {
      List a = date.split('-');
      newDate = '${a[2]}-${a[1]}-${a[0]}';
    }
    return newDate;
  }

  setBackToEmployeeSummary() {
    selectedReportType = 'Summary-Billwise';
    notifyListeners();
  }

  bool checkOpeningDate(String date) {
    log('received Date$date');
    log('received Date${date.substring(8, 10)}');
    log('Todays Date${DateTime.now().toString().substring(8, 10)}');

    bool val = false;
    if (date.isNotEmpty) {
      if (date.substring(8, 10) == DateTime.now().toString().substring(8, 10)) {
        val = true;
      }
    }
    return val;
  }

  switchReport(String title) {
    selectedReportType = 'Summary-Billwise';
    if (selectedReportType == 'Commission-Daywise') {
      fetchCommissionDayWise();
    } else if (selectedReportType == 'Commission-Summary') {
      fetchCommissionSummery();
    } else if (selectedReportType == 'Summary-Billwise') {
      fetchSyncedData();
    } else {
      fetchItemReport();
    }
    notifyListeners();
  }

  switchProductServiceReports(String title) {
    selectedProductService = 'Products';
    notifyListeners();
  }

  //Check Internet
  Future<bool> checkInternet() async {
    bool internetAvailable = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      internetAvailable = true;
      return internetAvailable;
    } else {
      internetAvailable = false;
      return internetAvailable;
    }
  }

  //Initial PosScreen
  User? userData;
  String? userName;
  String? openingDate;
  String? userEmail;
  String? isAdminUser;
  String? branchName;
  String? userType;

  bool punchedIn = false;
  bool posScreenLoading = true;
  String posScreenState = AppStrings.apiSuccess;
  bool mobileCheckoutVisible = false;
  initiateForAdmin() async {
    punchedIn = _prefs!.checkPunchedIn();
    userName = _prefs!.getString(AppStrings.userName) ?? '';
    openingDate = _prefs!.getString("openingDate") ?? '';
    branchName = _prefs!.getString(AppStrings.orgNameSet) ?? '';
    userType = _prefs!.getString(AppStrings.userType) ?? '';
    fetchProducts();
    fetchServices();
    fetchPaymentMethods();
    /*if(branchName=='TALENT'){
     ServerAddresses.baseUrl=ServerAddresses.talentsBaseUrl;
     ServerAddresses.logoUrl=ServerAddresses.talentsLogoUrl;
   }
   else{
     ServerAddresses.baseUrl=ServerAddresses.trendsBaseUrl;
     ServerAddresses.logoUrl=ServerAddresses.trendsLogoUrl;
   }*/
    ServerAddresses.baseUrl = ServerAddresses.talentsBaseUrl;
    ServerAddresses.logoUrl = ServerAddresses.talentsLogoUrl;
  }

  initiatePosScreen(BuildContext context) async {
    if (isEditEnabled == false) {
      showDataEntryDialog(context);
      productServiceSelected = 1;
      punchedIn = _prefs!.checkPunchedIn();
      userName = _prefs!.getString(AppStrings.userName) ?? '';
      openingDate = _prefs!.getString("openingDate") ?? '';
      userEmail = _prefs!.getString(AppStrings.userEmail) ?? '';
      branchName = _prefs!.getString(AppStrings.orgNameSet) ?? '';
      userType = _prefs!.getString(AppStrings.userType) ?? '';
      /*if(branchName=='TALENT'){
        ServerAddresses.baseUrl=ServerAddresses.talentsBaseUrl;
        ServerAddresses.logoUrl=ServerAddresses.talentsLogoUrl;
      }
      else{
        ServerAddresses.baseUrl=ServerAddresses.trendsBaseUrl;
        ServerAddresses.logoUrl=ServerAddresses.trendsLogoUrl;
      }*/
      ServerAddresses.baseUrl = ServerAddresses.talentsBaseUrl;
      ServerAddresses.logoUrl = ServerAddresses.talentsLogoUrl;
      // if(_prefs!.getInt(AppStrings.userBillCount)==null){
      //   _prefs!.setInt(AppStrings.userBillCount, 1);
      // }
      if (userName != null && userEmail != null) {
        posScreenLoading = false;
        posScreenState = AppStrings.apiSuccess;
        notifyListeners();
      } else {
        posScreenLoading = false;
        posScreenState = AppStrings.apiError;
        notifyListeners();
      }
      fetchEmployees();
      fetchPaymentMethods();
      await fetchProductCategories();
      await fetchServicesCategories();
      await fetchServices();
      await fetchProducts();
      await syncSale();
      notifyListeners();
    } else {
      log('not required');
      posScreenLoading = false;
      notifyListeners();
    }
  }

  //Function TO check whether Admin
  bool? isAdmin;
  checkAdmin() {
    if (_prefs!.getString(AppStrings.userIsAdmin) == 'true') {
      isAdmin = true;
      notifyListeners();
    } else {
      isAdmin = false;
      notifyListeners();
    }
  }

  punchOut(BuildContext context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        title: 'Log Out',
        desc: 'Are you sure to log out?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          if (!(isAdmin!)) {
            clearCart(context);
          }
          // clearCart(context);
          fromDate = DateTime.now();
          toDate = DateTime.now();
          paymentTypes = [];
          paymentDropDown = [];
          paymentMethods = [];

          _prefs!.clearAll();
          Get.offAllNamed('/pinScreen');
        }).show();
  }

  backToHomeInMobile() {
    mobileCheckoutVisible = false;
    notifyListeners();
  }

  //Fetch Product & Services
  bool productScreenLoading = true;
  String productsState = AppStrings.apiSuccess;
  CategoryModel? productCategoriesResponse;
  LogoModel? orgLogo;
  List<Datum>? productCategories;
  CategoryModel? serviceCategoriesResponse;
  EmployeeDesignationModel? employeeDesignationModel;
  List<DesignationData>? employeeDesignationList;
  List<Datum>? serviceCategories;
  ProductsModel? productListResponse;
  List<ProductDatum>? productList;
  ProductsModel? serviceListResponse;
  List<ProductDatum>? serviceList;
  int productServiceSelected = 1;
  int categorySelectedId = 0;
  int selectedCategoryIndex = 0;
  List<ProductDatum>? productsAndServiceToBePassedInGridView;
  int cartCount = 0;
  EmployeeModel? employeeListResponse;
  List<EmployeeDatum>? employeeList;
  CustomerFetchByMobileModel? customer;
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();

  //SwitchProductAndService
  switchProductAndService(int serviceSelected) {
    productServiceSelected = serviceSelected;
    categorySelectedId = 0;
    selectedCategoryIndex = 0;
    if (serviceSelected == 0) {
      productsAndServiceToBePassedInGridView = productList;
    } else {
      productsAndServiceToBePassedInGridView = serviceList;
    }
    notifyListeners();
  }

  switchCategories(int selectedCategoryId) {
    categorySelectedId = selectedCategoryId;
    print(
        '________________________________________________$categorySelectedId');

    notifyListeners();
    if (selectedCategoryId == 0) {
      if (productServiceSelected == 0) {
        productsAndServiceToBePassedInGridView = productList;
      } else {
        productsAndServiceToBePassedInGridView = serviceList;
      }
      notifyListeners();
    } else {
      if (productServiceSelected == 0) {
        productsAndServiceToBePassedInGridView = productList!
            .where((element) =>
                element.category_id == selectedCategoryId.toString())
            .toList();
      } else {
        final filteredProducts = productsAndService.where((product) {
          return categorySelectedId == productServiceSelected;
        }).toList();
      }
      notifyListeners();

      // productsAndServiceToBePassedInGridView=productsAndServiceToBePassedInGridView!.where((element) => element.groupId==selectedCategoryId).toList();
      // log(productsAndServiceToBePassedInGridView.toString());

      // notifyListeners();
    }
  }

  fetchLogo() async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        orgLogo = LogoModel.fromMap(await PosRepository().fetchLogo());
        notifyListeners();
      } catch (e) {
        log('error in logo');
        log(e.toString());
      }
    }
  }

  fetchEmployeeDesignation() async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      log('internet available');
      try {
        employeeDesignationModel = EmployeeDesignationModel.fromMap(
            await PosRepository().fetchEmployeeDesignation());

        if (employeeDesignationModel!.success == true) {
          log(employeeDesignationModel!.data.toString());
          employeeDesignationList = employeeDesignationModel!.data ?? [];

          log(employeeDesignationList!.length.toString());
          notifyListeners();
        } else {
          log('failed');
        }
      } catch (e) {
        log('error in service');
        log(e.toString());
      }
    } else {
      log('internet not available');
    }
  }

  fetchProductCategories() async {
    productScreenLoading = true;
    productsState = AppStrings.apiSuccess;
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        productCategoriesResponse = CategoryModel.fromMap(
            await PosRepository().fetchCategories(type: 'Product'));
        notifyListeners();
        if (productCategoriesResponse!.success == true) {
          productCategories = productCategoriesResponse!.data ?? [];
          productCategories!
              .insert(0, Datum(id: 0, name: 'All'));
          if (productCategories!.length == 1) {
            switchProductAndService(1);
          }
          notifyListeners();
          await DataBaseHelper.instance.removeTable('product_categories');
          for (int i = 0; i < productCategories!.length; i++) {
            await DataBaseHelper.instance.addProductCategory(
                productCategories![i], 'product_categories');
          }
        } else {
          log('failed');
          productScreenLoading = false;
          productsState = AppStrings.apiError;
          notifyListeners();
        }
      } catch (e) {
        log('error in category');
        log(e.toString());
        productScreenLoading = false;
        productsState = AppStrings.apiError;
        notifyListeners();
      }
    } else {
      productCategories = await DataBaseHelper.instance
          .getProductCategories('product_categories');
      if (productCategories!.length == 1) {
        switchProductAndService(1);
      }
      if (productCategories!.isEmpty) {
        productScreenLoading = false;
        // productsState = AppStrings.apiNoInternet;
        notifyListeners();
      }
    }
  }

  fetchServicesCategories() async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      log('internet available');
      try {
        serviceCategoriesResponse = CategoryModel.fromMap(
            await PosRepository().fetchCategories(type: 'Service'));
        notifyListeners();
        if (serviceCategoriesResponse!.success == true) {
          log(serviceCategoriesResponse!.data.toString());
          serviceCategories = serviceCategoriesResponse!.data ?? [];
          serviceCategories!
              .insert(0, Datum(id: 0, name: 'All'));
          if (serviceCategories!.length == 1) {
            switchProductAndService(0);
          }
          log(serviceCategories!.length.toString());
          notifyListeners();
          await DataBaseHelper.instance.removeTable('service_categories');

          for (int i = 0; i < serviceCategories!.length; i++) {
            await DataBaseHelper.instance.addProductCategory(
                serviceCategories![i], 'service_categories');
          }
        } else {
          log('failed');
          productScreenLoading = false;
          productsState = AppStrings.apiError;
          notifyListeners();
        }
      } catch (e) {
        log('error in service');
        log(e.toString());
        productScreenLoading = false;
        productsState = AppStrings.apiError;
        notifyListeners();
      }
    } else {
      log('internet not available');
      serviceCategories = await DataBaseHelper.instance
          .getProductCategories('service_categories');
      if (serviceCategories!.length == 1) {
        switchProductAndService(0);
      }

      if (serviceCategories!.isEmpty) {
        productScreenLoading = false;
        // productsState = AppStrings.apiNoInternet;
        notifyListeners();
      }
    }
  }

  fetchProducts() async {
    log('product');
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        print(categorySelectedId);
        productListResponse = ProductsModel.fromMap(await PosRepository()
            .fetchProductsAndService(
                type: 'Product', category_id: categorySelectedId));
        notifyListeners();
        if (productListResponse!.success == true) {
          productList = productListResponse!.data ?? [];
          notifyListeners();
          await DataBaseHelper.instance.removeTable('products');
          for (int i = 0; i < productList!.length; i++) {
            await DataBaseHelper.instance
                .addProductAndService(productList![i], 'products');
          }
        } else {
          log('failed');
          productScreenLoading = false;
          productsState = AppStrings.apiError;
          notifyListeners();
        }
      } catch (e) {
        log(e.toString());
        productScreenLoading = false;
        productsState = AppStrings.apiError;
        notifyListeners();
      }
    } else {
      productList =
          await DataBaseHelper.instance.getProductAndService('products');
      productsAndServiceToBePassedInGridView = serviceList;
      if (productList!.isEmpty) {
        productScreenLoading = false;
        // productsState = AppStrings.apiNoInternet;
        notifyListeners();
      }
    }
  }

  fetchServices() async {
    log('service');
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        serviceListResponse = ProductsModel.fromMap(await PosRepository()
            .fetchProductsAndService(type: 'Service', category_id: ''));
        notifyListeners();
        if (serviceListResponse!.success == true) {
          serviceList = serviceListResponse!.data ?? [];
          productsAndServiceToBePassedInGridView = serviceList;
          // if(productList!.isNotEmpty){
          //   productsAndServiceToBePassedInGridView = productList;
          // }
          // else{
          //   productsAndServiceToBePassedInGridView = serviceList;
          // }
          productScreenLoading = false;
          notifyListeners();
          await DataBaseHelper.instance.removeTable('services');
          for (int i = 0; i < serviceList!.length; i++) {
            await DataBaseHelper.instance
                .addProductAndService(serviceList![i], 'services');
          }
        } else {
          log('failed');
          productScreenLoading = false;
          productsState = AppStrings.apiError;
          notifyListeners();
        }
      } catch (e) {
        log(e.toString());
        productScreenLoading = false;
        productsState = AppStrings.apiError;
        notifyListeners();
      }
    } else {
      log('inside else service');
      serviceList =
          await DataBaseHelper.instance.getProductAndService('services');
      if (serviceList!.isEmpty) {
        productScreenLoading = false;
        // productsState = AppStrings.apiNoInternet;
        notifyListeners();
      } else {
        productScreenLoading = false;
        notifyListeners();
      }
    }
  }

  bool employeeLoading = false;
  List<String> adminViewEmployeeList = [];
  String adminViewEmployeeSelected = '';
  changeAdminViewEmployee(String val, int id) {
    adminViewEmployeeSelected = val;
    selectedEmployeeId = id;
    notifyListeners();
  }

  fetchEmployees() async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        adminViewEmployeeList = [];
        employeeListResponse =
            EmployeeModel.fromMap(await PosRepository().fetchEmployees());

        if (employeeListResponse!.success == true) {
          employeeList = employeeListResponse!.data ?? [];
          if (isAdmin!) {
            employeeList!.insert(
              0,
              EmployeeDatum(id: 0, name: 'All'),
            );
            selectedEmployeeId = 0;
            adminViewEmployeeSelected = 'All';
          }

          await DataBaseHelper.instance.removeTable('employee');
          adminViewEmployeeList.clear();
          for (int i = 0; i < employeeList!.length; i++) {
            adminViewEmployeeList.add(employeeList![i].name!);
            await DataBaseHelper.instance
                .addEmployees(employeeList![i], 'employee');
          }
          notifyListeners();
        } else {
          log('failed');
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      employeeList = await DataBaseHelper.instance.getEmployees('employee');
      notifyListeners();
      // if(employeeList!.isEmpty){
      //   productScreenLoading=false;
      //   productsState=AppStrings.apiNoInternet;
      //   notifyListeners();
      // }
      // else{
      //   productScreenLoading=false;
      //   notifyListeners();
      // }
    }
    employeeLoading = true;
    notifyListeners();
  }

  DaySummaryModel? daySummaryModel;
  DayCloseReportModel? dayCloseReport;
  bool daySummaryLoading = false;
  LoginModel? userDetails;
  bool click = false;
  fetchDaySummary() async {
    daySummaryLoading = true;
    reportState = AppStrings.apiSuccess;
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        await syncSale();
        if (isAdmin == false) {
          selectedEmployeeId = int.parse(_prefs!.getString(AppStrings.userId)!);
        }
        log(selectedEmployeeId.toString());

        if (isAdmin == false &&
            selectedEmployeeId != 0 &&
            selectedEmployeeId != null) {
          log('inside fetch day summary');
          daySummaryModel = DaySummaryModel.fromJson(await PosRepository()
              .fetchDaySummaryAdmin(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}',
                  id: selectedEmployeeId));
          log('--aaaaaaaaaaaaaaaaaaaaaaaaaaaa---------------------$daySummaryModel');
        } else {
          log('inside fetch day close');
          userDetails =
              LoginModel.fromMap(await PosRepository().fetchUserDetails());
          dayCloseReport = DayCloseReportModel.fromMap(await PosRepository()
              .fetchDayCloseSummary(
                  fromDate: openingDate,
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}'));
        }
        notifyListeners();
        if (isAdmin == false &&
            selectedEmployeeId != 0 &&
            selectedEmployeeId != null) {
          if (daySummaryModel!.success == true) {
            await printSummary();
            daySummaryLoading = false;
            notifyListeners();
          } else {
            daySummaryLoading = false;
            notifyListeners();
          }
        } else {
          if (dayCloseReport!.success == true) {
            await printDayCloseReport();
            daySummaryLoading = false;
            notifyListeners();
          } else {
            daySummaryLoading = false;
            notifyListeners();
            log('failed');
          }
        }
      } catch (e) {
        daySummaryLoading = false;
        notifyListeners();
      }
    } else {
      daySummaryLoading = false;
      notifyListeners();
    }
  }

  fetchCustomerName(BuildContext context) async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        customer = CustomerFetchByMobileModel.fromMap(await PosRepository()
            .fetchCustomerName(customerNumberController.text));
        notifyListeners();
        if (customer!.success == true) {
          customerNameController.text = customer!.data!.name!;
          notifyListeners();
        } else {
          log('no customer');
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      Themes.showSnackBar(context: context, msg: "No Internet Connection");
    }
  }

  //Cart
  TextEditingController discountController = TextEditingController();
  List<ProductDatum> cartItems = [];
  int subTotal = 0;
  int total = 0;
  int discount = 0;

  List<TextEditingController> paymentControllers = [];
  // List<GlobalKey<FormState>> formKeys = [
  //   GlobalKey<FormState>(),
  //   GlobalKey<FormState>(),
  //   GlobalKey<FormState>(),
  // ];
  List<String> paymentTypes = [];
  List<List<String>> paymentDropDown = [];

  List<PaymentModel> paymentMethods = [];
  ScrollController paymentMethodScrollController = ScrollController();
  PaymentMethodModel? paymentResponse;
  List<PaymentDatum>? paymentList;

  bool otBills = false;

  fetchPaymentMethods() async {
    log('inside fetch payment');
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        print('-----------------------------------------PAY');
        paymentResponse =
            PaymentMethodModel.fromMap(await PosRepository().fetchPayments());
        notifyListeners();
        if (paymentResponse!.success == true) {
          paymentList = paymentResponse!.data ?? [];

          notifyListeners();
          await DataBaseHelper.instance.removeTable('paymentMethods');
          for (int i = 0; i < paymentList!.length; i++) {
            await DataBaseHelper.instance
                .addPaymentMethod(paymentList![i], 'paymentMethods');
            paymentTypes.add(paymentList![i].name!);
            paymentControllers.add(TextEditingController());
            notifyListeners();
          }
          paymentMethods.add(PaymentModel(
              type: paymentList![0].name, amount: '0', id: paymentList![0].id));
          paymentDropDown.add(paymentTypes);
          notifyListeners();
          print(
              '-----------------------------PAY-----------------------${paymentMethods[0].type}');
        } else {
          log('failed');
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      paymentList =
          await DataBaseHelper.instance.getPaymentMethods('paymentMethods');
      for (int i = 0; i < paymentList!.length; i++) {
        paymentTypes.add(paymentList![i].name!);
        paymentControllers.add(TextEditingController());
        notifyListeners();
      }
      paymentMethods.add(PaymentModel(
          type: paymentList![0].name, amount: '0', id: paymentList![0].id));
      paymentDropDown.add(paymentTypes);

      notifyListeners();
      // if(employeeList!.isEmpty){
      //   productScreenLoading=false;
      //   productsState=AppStrings.apiNoInternet;
      //   notifyListeners();
      // }
      // else{
      //   productScreenLoading=false;
      //   notifyListeners();
      // }
    }
  }

  //Add To Cart For Edit Purpose
  bool isEditEnabled = false;
  int? editBillId;
  String? editCounterInvoice;
  int? editCreatedBy;
  String? editDate;
  addToCartForEdit(FetchedSyncedDatum data) {
    mobileCheckoutVisible = true;
    isEditEnabled = true;
    cartItems.clear();
    paymentMethods.clear();
    paymentControllers.clear();
    paymentDropDown.clear();
    for (int i = 0; i < data.products!.length; i++) {
      cartItems.add(ProductDatum(
        id: data.products![i].productId,
        name: data.products![i].productName,
        arabicName: productList![productList!.indexWhere(
                (element) => element.id == data.products![i].productId)]
            .arabicName,
        groupId: productList![productList!.indexWhere(
                (element) => element.id == data.products![i].productId)]
            .groupId,
        group: productList![productList!.indexWhere(
                (element) => element.id == data.products![i].productId)]
            .group,
        price: data.products![i].price,
        time: productList![productList!.indexWhere(
                (element) => element.id == data.products![i].productId)]
            .time,
        description: productList![productList!.indexWhere(
                (element) => element.id == data.products![i].productId)]
            .description,
        servicedById: data.products![i].employeeId,
      ));
      cartItems.last.productType = 'Products';
      cartItems.last.editId = data.products![i].id;
      notifyListeners();
    }
    for (int i = 0; i < data.services!.length; i++) {
      log(data.services![i].employeeId.toString());
      cartItems.add(ProductDatum(
          id: data.services![i].serviceId,
          name: data.services![i].serviceName,
          // arabicName: serviceList![serviceList!.indexWhere(
          //         (element) => element.id == data.services![i].serviceId)]
          //     .name,
          groupId: serviceList![serviceList!.indexWhere(
                  (element) => element.id == data.services![i].serviceId)]
              .groupId,
          group:
              serviceList![serviceList!.indexWhere((element) => element.id == data.services![i].serviceId)]
                  .group,
          price: data.services![i].price,
          time:
              serviceList![serviceList!.indexWhere((element) => element.id == data.services![i].serviceId)]
                  .time,
          description:
              serviceList![serviceList!.indexWhere((element) => element.id == data.services![i].serviceId)]
                  .description,
          servicedById: data.services![i].employeeId));
      cartItems.last.productType = 'Services';
      cartItems.last.editId = data.services![i].id;
      notifyListeners();
      log('cart product ${cartItems.last.price} ${cartItems.last.productType} ${cartItems.last.editId}');
    }
    cartCount = cartItems.length;
    paymentMethods.add(PaymentModel(
        id: data.payments![0].methodId,
        amount: data.payments![0].amount.toString(),
        type: data.payments![0].methodName));
    paymentDropDown.add(paymentTypes);
    for (int i = 0; i < paymentList!.length; i++) {
      paymentControllers.add(TextEditingController());
      notifyListeners();
    }
    for (int i = 0; i < data.payments!.length; i++) {
      paymentControllers.add(TextEditingController());
      paymentControllers[i].text = data.payments![i].amount.toString();
      if (i != 0) {
        addPaymentMethodsToDropDown(i - 1);
        onAddPayment(
            data.payments![i].methodName!, data.payments![i].amount.toString());
      }

      // if(i==0){
      //   paymentDropDown[i].add(data.payments![i].methodName!);
      //   for(int j=0;i<paymentTypes.length;j++){
      //     if(paymentTypes[j]!=data.payments![i].methodName){
      //       paymentDropDown[i].add(paymentTypes[j]);
      //     }
      //   }
      // }
      // paymentControllers[i].text=data.payments![i].amount.toString();
      // paymentDropDown.add(['Cash','Card','Cheque']);
    }
    log('for complete');
    editBillId = data.id;
    editCounterInvoice = data.invoiceNo;
    editCreatedBy = data.datumCreatedBy;
    editDate = data.date;

    customerNameController.text = data.customerName!;
    customerNumberController.text = data.customerMobile!;
    subTotal = data.total!;
    total = data.grandTotal! + data.discount!;
    discount = data.discount!;
    discountController.text = data.discount.toString();
    otBills = data.overTimeFlag == 1 ? true : false;
    notifyListeners();
    Get.toNamed('/posScreen');
  }

  changeOtBills(bool value) {
    otBills = value;
    notifyListeners();
  }

  clearCart(BuildContext context) {
    mobileCheckoutVisible = false;
    cartCount = 0;
    isEditEnabled = false;
    customerNameController.clear();
    customerNumberController.clear();
    otBills = false;
    cartItems.clear();
    discountController.clear();
    discount = 0;
    subTotal = 0;
    total = 0;
    cartCount = 0;
    paymentDropDown = [paymentTypes];
    paymentMethods = [
      PaymentModel(
          type: paymentList![0].name, amount: '0', id: paymentList![0].id)
    ];
    for (int i = 0; i < paymentControllers.length; i++) {
      paymentControllers[i].clear();
    }
    showDataEntryDialog(context);
    notifyListeners();
  }

  addProductToCart(ProductDatum items) {
    cartItems.add(items);
    String userId = _prefs!.getString(AppStrings.userId)!;
    cartItems.last.servicedById = int.parse(userId.trim());
    cartItems.last.editId = null;
    if (productServiceSelected == 0) {
      cartItems.last.productType = 'Products';
    } else {
      cartItems.last.productType = 'Services';
    }
    log(cartItems.last.servicedById.toString());
    subTotal = subTotal + items.price!;
    total = total + items.price!;
    if (paymentMethods.length == 1) {
      paymentControllers[0].text = total.toString();
    }
    cartCount = cartCount + 1;

    // paymentDropDown=[['Cash','Card','Upi']];
    // paymentMethods=[PaymentModel(type: "Cash",amount: '0')];
    // paymentControllers[0].clear();
    // paymentControllers[1].clear();
    // paymentControllers[2].clear();
    notifyListeners();
  }

  deleteProduct(int deleteItemId, int price) {
    cartItems.removeAt(
        cartItems.indexWhere((element) => element.id == deleteItemId));
    // paymentDropDown=[['Cash','Card','Upi']];
    // paymentMethods=[PaymentModel(type: "Cash",amount: '0')];
    // paymentControllers[0].clear();
    // paymentControllers[1].clear();
    // paymentControllers[2].clear();
    subTotal = subTotal - price;
    total = total - price;
    if (paymentMethods.length == 1) {
      paymentControllers[0].text = total.toString();
    }
    cartCount = cartCount - 1;
    if (discount > subTotal) {
      discount = 0;
      discountController.clear();
    }
    notifyListeners();
  }

  onChangedServiceEmployees(int positionId, int changeEmployeeId) {
    cartItems[positionId].servicedById = changeEmployeeId;
    notifyListeners();
  }

  onChangeDiscount(int value) {
    discount = value;
    if (paymentMethods.length == 1) {
      paymentControllers[0].text = (total - discount).toString();
    }
    // paymentDropDown=[['Cash','Card','Upi']];
    // paymentMethods=[PaymentModel(type: "Cash",amount: '0')];
    // paymentControllers[0].clear();
    // paymentControllers[1].clear();
    // paymentControllers[2].clear();
    notifyListeners();
  }

  var selectedMethod = 'CARD';

  onChangedPaymentType(int index, String type) {
    log('Index: $index');

    // Update the selected payment method's type and ID
    paymentMethods[index].type = type;
    paymentMethods[index].id =
        paymentList!.firstWhere((element) => element.name == type).id;

    // Print the selected payment method details
    print(
        'Selected Payment Method: ${paymentMethods[index].type}, ID: ${paymentMethods[index].id}');
    selectedMethod = paymentMethods[index].type.toString();
    notifyListeners();

    // Remove subsequent payment methods if the current one is changed
    for (int i = index + 1; i < paymentMethods.length; i++) {
      log('Processing index $i');

      if (paymentMethods[i].amount!.isNotEmpty) {
        paymentMethods.removeAt(i);
        paymentDropDown.removeAt(i);
        paymentControllers[i].clear();
      }
    }

    // Notify listeners once after all updates are done
    notifyListeners();
  }

  onChangedPaymentAmount(int index, String amount) {
    paymentMethods[index].amount = amount;
    log(paymentMethods[index].amount!);
    notifyListeners();
  }

  onAddPayment(String type, String amount) {
    paymentMethods.add(PaymentModel(
        type: type,
        amount: amount,
        id: paymentList![
                paymentList!.indexWhere((element) => element.name == type)]
            .id));
    notifyListeners();
  }

  addPaymentMethodsToDropDown(int index) {
    log('calledDropDown');
    paymentDropDown.add(paymentDropDown[index]
        .where((element) => element != paymentMethods[index].type)
        .toList());
    notifyListeners();
  }

  onDeletePaymentMethod(int index) {
    paymentMethods.removeAt(index);
    paymentDropDown.removeAt(index);
    paymentControllers[index].clear();
    notifyListeners();
  }

  // Future<bool> validateFormKeys(BuildContext context) async {
  //   final bool isValid1 = formKeys[0].currentState?.validate() ?? false;
  //   final bool isValid2 = paymentMethods.length > 1
  //       ? formKeys[1].currentState?.validate() ?? false
  //       : true;
  //   final bool isValid3 = paymentMethods.length > 2
  //       ? formKeys[2].currentState?.validate() ?? false
  //       : true;
  //
  //   if (isValid1 == false) {
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       paymentMethodScrollController.animateTo(
  //         paymentMethodScrollController.position.minScrollExtent,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.easeOut,
  //       );
  //     });
  //   } else if (isValid2 == false) {
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       paymentMethodScrollController.animateTo(
  //         paymentMethodScrollController.position.minScrollExtent +
  //             getHeight(context: context) / 7.5,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.easeOut,
  //       );
  //     });
  //   } else {
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       paymentMethodScrollController.animateTo(
  //         paymentMethodScrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.easeOut,
  //       );
  //     });
  //   }
  //
  //   // Return true if all form keys are valid
  //   return isValid1 && isValid2 && isValid3;
  // }

  //Sale Module
  SingleLocalSaleModel? singleSale;
  bool checkoutLoading = false;
  List<User>? user;
  saveSingleSale(BuildContext context) async {
    print('****************************');
    if (customerNameController.text.isEmpty &&
        customerNumberController.text.isNotEmpty) {
      Themes.showSnackBar(msg: 'Please Enter Customer Name', context: context);
    } else if (customerNumberController.text.isEmpty &&
        customerNameController.text.isNotEmpty) {
      Themes.showSnackBar(
          msg: 'Please Enter Customer Number', context: context);
    } else if (cartItems.isEmpty) {
      Themes.showSnackBar(msg: 'Please Add Items To Cart', context: context);
    } else {
      List<User> userDetails = await DataBaseHelper.instance.getUserDetails();
      user = userDetails
          .where((element) =>
              element.id == int.parse(_prefs!.getString(AppStrings.userId)!))
          .toList();

      int id;
      if (isEditEnabled) {
        id = editBillId!;
      } else {
        // Safely increment sales count to get a new unique ID
        id = user![0].salesCount!;
        user![0].salesCount = id + 1;
      }

      String date = _prefs!.getString("openingDate") ??
          DateTime.now().toString().substring(0, 10);
      String userId = _prefs!.getString(AppStrings.userId)!;
      String code = _prefs!.getString("code")!;

      singleSale = SingleLocalSaleModel(
          date: isEditEnabled ? editDate : date,
          customerName: customerNameController.text,
          customerMobile: customerNumberController.text,
          total: subTotal.toString(),
          discount: discount.toString(),
          grandTotal: (total - discount).toString(),
          overTimeFlag: otBills ? 'true' : 'false',
          createdBy: isEditEnabled ? editCreatedBy : int.parse(userId),
          updatedBy: int.parse(userId),
          id: id,
          type: isEditEnabled ? 'synced' : 'unSynced',
          syncedId: isEditEnabled ? editBillId : null,
          counterInvoice: isEditEnabled ? editCounterInvoice : '$code/$id',
          branchId: _prefs!.getInt(AppStrings.branchId),
          products: [],
          services: [],
          payments: []);

      // Add products and services to the sale
      for (var item in cartItems) {
        if (item.productType == 'Products') {
          singleSale!.products!.add(SingleLocalSaleProduct(
            productId: item.id,
            price: item.price.toString(),
            employeeId: item.servicedById,
            saleId: id,
            editId: item.editId,
          ));
        } else {
          singleSale!.services!.add(SingleLocalSaleService(
            serviceId: item.id,
            price: item.price.toString(),
            employeeId: item.servicedById,
            saleId: id,
            editId: item.editId,
          ));
        }
      }

      // Add payments to the sale
      for (var payment in paymentMethods) {
        // print('...................${payment.id}');
        singleSale!.payments!.add(SingleLocalSalePayment(
          id: selectedMethod=='CARD'?18: payment.id,
          paymentMethod: selectedMethod=='CARD'?'CARD': payment.type,
          amount: payment.amount,
          saleId: id,
        ));
      }

      // Save the sale and related data to the database
      await DataBaseHelper.instance.addLocalSale(
          data1Date: singleSale!.date,
          data1CustomerName: singleSale!.customerName!.isNotEmpty
              ? singleSale!.customerName
              : ' ',
          data1CustomerMobile: singleSale!.customerMobile!.isNotEmpty
              ? singleSale!.customerMobile
              : ' ',
          data1Total: singleSale!.total,
          data1Discount: singleSale!.discount,
          data1GrandTotal: singleSale!.grandTotal,
          data1OverTimeFlag: otBills,
          data1CreatedBy: singleSale!.createdBy,
          data1UpdatedBy: singleSale!.updatedBy,
          data1Id: id,
          type: singleSale!.type,
          syncedId: singleSale!.syncedId,
          counterInvoice: singleSale!.counterInvoice,
          branchId: singleSale!.branchId);

      await DataBaseHelper.instance.addLocalProduct(singleSale!.products!);
      await DataBaseHelper.instance.addLocalService(singleSale!.services!);
      await DataBaseHelper.instance.addLocalPayment(singleSale!.payments!);

      // Update the user's sales count after successful save
      if (!isEditEnabled) {
        await DataBaseHelper.instance.editUser(user![0]);
      }

      if (Platform.isAndroid) {
        await printInvoice();
      }

      // Clear the cart and other related data
      clearCart(context);
      paymentTypes = [];
      paymentDropDown = [];
      paymentMethods = [];
      syncSale();
      _prefs!.clearAll();

      checkoutLoading = false;
      Get.offAllNamed('/pinScreen');
      notifyListeners();
    }
  }

  //Sync Sales
  List<SingleLocalSaleModel>? localSales;
  SaleModel? localSaleForSync;
  SaleSyncedModel? syncResponse;
  List<SaleDatum> listOfSaleToSync = [];

  clickBool() {
    click = true;
  }

  syncSale() async {
    if (click == false) {
      switchReport('Summary-Billwise');
      clickBool();
    }
    //
    log('***syncing sale***');
    listOfSaleToSync = [];
    localSaleForSync = SaleModel();
    String userId = _prefs!.getString(AppStrings.userId)!;
    localSales = await DataBaseHelper.instance.getLocalSale();
    if (localSales!.isNotEmpty) {
      log('not empthy');
      for (int i = 0; i < localSales!.length; i++) {
        List<SaleProduct> localProductForSync = [];
        List<SaleService> localServiceForSync = [];
        List<SalePayment> localPaymentsForSync = [];
        for (int j = 0; j < localSales![i].products!.length; j++) {
          log('from db price ${localSales![i].products![j].price!} editId ${localSales![i].products![j].editId}');
          localProductForSync.add(SaleProduct(
              productId: localSales![i].products![j].productId,
              employeeId: localSales![i].products![j].employeeId,
              price: int.parse(localSales![i].products![j].price!),
              id: localSales![i].products![j].editId));
        }
        for (int k = 0; k < localSales![i].services!.length; k++) {
          localServiceForSync.add(SaleService(
              serviceId: localSales![i].services![k].serviceId,
              employeeId: localSales![i].services![k].employeeId,
              price: int.parse(localSales![i].services![k].price!),
              id: localSales![i].services![k].editId));
        }
        //change method
        for (int l = 0; l < localSales![i].payments!.length; l++) {
          log('manf${localSales![i].payments!.length}');
          log('man${localSales![i].payments![l].id}');
          log('wom${localSales![i].payments![l].amount}');
          localPaymentsForSync.add(SalePayment(
              method: localSales![i].payments![l].id,
              amount: int.parse(localSales![i].payments![l].amount!)));
        }
        log('for loop');

        listOfSaleToSync.add(SaleDatum(
            date: localSales![i].date,
            customerName: localSales![i].customerName,
            customerMobile: localSales![i].customerMobile,
            total: localSales![i].total,
            discount: localSales![i].discount,
            grandTotal: localSales![i].grandTotal,
            overTimeFlag: localSales![i].overTimeFlag,
            createdBy: localSales![i].createdBy.toString(),
            updatedBy: localSales![i].updatedBy.toString(),
            id: localSales![i].type == 'synced'
                ? localSales![i].syncedId.toString()
                : null,
            counterInvoice: localSales![i].counterInvoice,
            branchId: localSales![i].branchId,
            products: localProductForSync,
            services: localServiceForSync,
            payments: localPaymentsForSync));
        log('pk');
        log('--------------------counter invoice---------------------------------------------------$listOfSaleToSync');
        log('product$localProductForSync');
        log('service $localServiceForSync');
      }
      localSaleForSync = SaleModel(data: listOfSaleToSync);
      bool internetAvailable = await checkInternet();
      if (internetAvailable == true) {
        try {
          syncResponse = SaleSyncedModel.fromMap(await PosRepository().saleSync(
              employeeId: userId, saleToSync: localSaleForSync!.toMap()));
          notifyListeners();
          if (syncResponse!.success == true) {
            log('synced successfully');
            await DataBaseHelper.instance.removeTable('localSale');
            await DataBaseHelper.instance.removeTable('localProducts');
            await DataBaseHelper.instance.removeTable('localServices');
            await DataBaseHelper.instance.removeTable('localPayments');
          } else {
            log('no customer');
          }
        } catch (e) {
          log('pidichee');
          log(e.toString());
        }
      }
    } else {
      log('no sale to sync');
    }
  }

  //Fetch Synced Data
  FetchedSyncedModel? fetchedSyncedData;
  DayCloseOpenModel? dayStatus;
  bool reportScreenLoading = true;
  String reportState = AppStrings.apiSuccess;

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  DateTime openDate = DateTime.now();
  fetchDayStatus(
    String date,
    String type,
    BuildContext context,
  ) async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        dayStatus = DayCloseOpenModel.fromMap(await PosRepository()
            .fetchDayStatus(
                date, type == "DAY_OPEN" ? "from_date" : "to_date"));
        if (dayStatus!.success == true) {
          if (dayStatus!.data!.status == 'Closed') {
            openingDate = '';
          } else {
            fromDate = DateTime.now();
            toDate = DateTime.now();
            openingDate = dayStatus!.data!.date;
          }
        } else {
          Themes.showSnackBar(context: context, msg: dayStatus?.message);
        }
        notifyListeners();
      } catch (e) {
        log(e.toString());
      }
    } else {}
  }

  dayClosePopup(BuildContext context, DateTime date) {
    var currentDate = date.toString().substring(0, 10);
    AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        body: Center(
          child: Column(
            children: [
              const Text(
                'Confirm',
                style: (TextStyle(fontSize: 18)),
              ),
              Text(
                'Day close $currentDate',
                style: (const TextStyle(fontSize: 15)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you sure?',
                    style: (TextStyle(fontSize: 15)),
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      selectOpenClose(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          fromDate = DateTime.now();
          toDate = DateTime.now();

          var dateString = "${date.day}-${date.month}-${date.year}";
          await fetchDayStatus(dateString, "DAY_CLOSE", context);
          await fetchDaySummary();
        }).show();
  }

  fetchSyncedData() async {
    log(productList == null ? 'null' : 'not');
    selectedReportType = 'Summary-Billwise';
    String? dateOpening = _prefs!.getString("openingDate");
    reportScreenLoading = true;
    reportState = AppStrings.apiSuccess;
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        await syncSale();
        dateOpening = dateOpening!.isEmpty
            ? DateTime.now().toString().substring(0, 10)
            : dateOpening;
        if (isAdmin! && selectedEmployeeId != 0 && selectedEmployeeId != null) {
          fetchedSyncedData = FetchedSyncedModel.fromMap(await PosRepository()
              .fetchSyncedSalesAdminView(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}',
                  id: selectedEmployeeId));
        } else {
          print('----------------------------');

          fetchedSyncedData = FetchedSyncedModel.fromMap(await PosRepository()
              .fetchSyncedSales(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}'));
        }
        notifyListeners();
        if (fetchedSyncedData!.success == true) {
          fetchTotalValues();
        } else {
          reportScreenLoading = false;
          reportState = AppStrings.apiError;
          notifyListeners();
          log('failed');
        }
      } catch (e) {
        reportScreenLoading = false;
        reportState = AppStrings.apiError;
        notifyListeners();
      }
    } else {
      reportScreenLoading = false;
      reportState = AppStrings.apiNoInternet;
      notifyListeners();
    }
  }

  //Commission DayWise
  CommissionDayWiseModel? commissionDayWise;
  fetchCommissionDayWise() async {
    log('inside fetch admin');

    reportScreenLoading = true;
    reportState = AppStrings.apiSuccess;
    String? dateOpening = _prefs!.getString("openingDate");
    dateOpening = dateOpening!.isEmpty
        ? DateTime.now().toString().substring(0, 10)
        : dateOpening;
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        if (isAdmin! && selectedEmployeeId != 0 && selectedEmployeeId != null) {
          log('inside commsion admin');
          commissionDayWise = CommissionDayWiseModel.fromMap(
              await PosRepository().fetchCommissionDayWiseAdmin(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}',
                  id: selectedEmployeeId));
        } else {
          log('inside else commsion admin');

          commissionDayWise = CommissionDayWiseModel.fromMap(
              await PosRepository().fetchCommissionDayWise(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}'));
        }
        notifyListeners();
        if (commissionDayWise!.success == true) {
          fetchTotalValues();
        } else {
          reportScreenLoading = false;
          reportState = AppStrings.apiError;
          notifyListeners();
          log('failed');
        }
      } catch (e) {
        reportScreenLoading = false;
        reportState = AppStrings.apiError;
        notifyListeners();
        log(e.toString());
      }
    } else {
      reportScreenLoading = false;
      reportState = AppStrings.apiNoInternet;
      notifyListeners();
    }
  }

  //Employee Summary
  CommissionDayWiseModel? employeeSummery;
  fetchEmployeeSummery() async {
    reportScreenLoading = true;
    reportState = AppStrings.apiSuccess;
    String? dateOpening = _prefs!.getString("openingDate");
    dateOpening = dateOpening!.isEmpty
        ? DateTime.now().toString().substring(0, 10)
        : dateOpening;
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        if (isAdmin! && selectedEmployeeId != 0 && selectedEmployeeId != null) {
          print('-----------------');
          // employeeSummery = CommissionDayWiseModel.fromMap(await PosRepository()
          //     .fetchEmployeeSummaryAdmin(
          //         fromDate:
          //             '${fromDate.year}-${fromDate.month}-${fromDate.day}',
          //         toDate: '${toDate.year}-${toDate.month}-${toDate.day}',
          //         id: selectedEmployeeId));
        } else {
          print('-----------------');

          employeeSummery = CommissionDayWiseModel.fromMap(await PosRepository()
              .fetchEmployeeSummaryAdmin(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}'));
        }
        notifyListeners();
        if (employeeSummery!.success == true) {
          fetchTotalValues();
        } else {
          reportScreenLoading = false;
          reportState = AppStrings.apiError;
          notifyListeners();
          log('failed');
        }
      } catch (e) {
        reportScreenLoading = false;
        reportState = AppStrings.apiError;
        notifyListeners();
        log(e.toString());
      }
    } else {
      reportScreenLoading = false;
      reportState = AppStrings.apiNoInternet;
      notifyListeners();
    }
  }

  //Fetch Branch
  BranchesModel? branches;
  int? selectedBranchId;
  fetchBranches() async {
    reportScreenLoading = true;
    reportState = AppStrings.apiSuccess;
    selectedBranchId = _prefs!.getInt(AppStrings.branchId);
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        branches = BranchesModel.fromMap(await PosRepository().fetchBranches());

        notifyListeners();
      } catch (e) {
        reportScreenLoading = false;
        reportState = AppStrings.apiError;
        notifyListeners();
        log(e.toString());
      }
    } else {
      reportScreenLoading = false;
      reportState = AppStrings.apiNoInternet;
      notifyListeners();
    }
  }

  switchBranch({int? branchId}) {
    _prefs!.setInt(AppStrings.branchId, branchId!);
    selectedBranchId = branchId;
    if (isAdmin!) {
      initiateForAdmin();
      fetchEmployees();
    }
    fetchEmployeeSummery();
    switchReport('Employee-Summary');
    switchProductServiceReports('Services');

    notifyListeners();
  }

  //Commission Summary
  CommissionDayWiseModel? commissionSummery;
  fetchCommissionSummery() async {
    reportScreenLoading = true;
    reportState = AppStrings.apiSuccess;
    String? dateOpening = _prefs!.getString("openingDate");
    dateOpening = dateOpening!.isEmpty
        ? DateTime.now().toString().substring(0, 10)
        : dateOpening;
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        if (isAdmin! && selectedEmployeeId != 0 && selectedEmployeeId != null) {
          commissionSummery = CommissionDayWiseModel.fromMap(
              await PosRepository().fetchCommissionSummaryAdmin(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}',
                  id: selectedEmployeeId));
        } else {
          commissionSummery = CommissionDayWiseModel.fromMap(
              await PosRepository().fetchCommissionSummary(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}'));
        }
        notifyListeners();
        if (commissionSummery!.success == true) {
          fetchTotalValues();
        } else {
          reportScreenLoading = false;
          reportState = AppStrings.apiError;
          notifyListeners();
          log('failed');
        }
      } catch (e) {
        reportScreenLoading = false;
        reportState = AppStrings.apiError;
        notifyListeners();
        log(e.toString());
      }
    } else {
      reportScreenLoading = false;
      reportState = AppStrings.apiNoInternet;
      notifyListeners();
    }
  }

  //Commission Summary
  ItemWiseModel? itemReport;
  fetchItemReport() async {
    log('inside item report');
    reportScreenLoading = true;
    reportState = AppStrings.apiSuccess;
    // String? dateOpening=_prefs!.getString("openingDate");
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        if (isAdmin! && selectedEmployeeId != 0 && selectedEmployeeId != null) {
          itemReport = ItemWiseModel.fromMap(await PosRepository()
              .fetchItemReportAdmin(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}',
                  id: selectedEmployeeId));
        } else {
          itemReport = ItemWiseModel.fromMap(await PosRepository()
              .fetchItemReport(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}'));
        }
        notifyListeners();
        if (itemReport!.success == true) {
          fetchTotalValues();
        } else {
          reportScreenLoading = false;
          reportState = AppStrings.apiError;
          notifyListeners();
          log('failed');
        }
      } catch (e) {
        reportScreenLoading = false;
        reportState = AppStrings.apiError;
        notifyListeners();
        log(e.toString());
      }
    } else {
      reportScreenLoading = false;
      reportState = AppStrings.apiNoInternet;
      notifyListeners();
    }
  }

  //Total Values
  TotalValuesModel? totalValues;
  fetchTotalValues() async {
    log('iniside fetch total values');
    reportScreenLoading = true;
    reportState = AppStrings.apiSuccess;
    // String? dateOpening=_prefs!.getString("openingDate");
    notifyListeners();
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        if (isAdmin! && selectedEmployeeId != 0 && selectedEmployeeId != null) {
          totalValues = TotalValuesModel.fromMap(await PosRepository()
              .fetchTotalValuesAdmin(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}',
                  id: selectedEmployeeId));
        } else {
          totalValues = TotalValuesModel.fromMap(await PosRepository()
              .fetchTotalValues(
                  fromDate:
                      '${fromDate.year}-${fromDate.month}-${fromDate.day}',
                  toDate: '${toDate.year}-${toDate.month}-${toDate.day}'));
        }
        notifyListeners();
        if (totalValues!.success == true) {
          reportScreenLoading = false;
          reportState = AppStrings.apiSuccess;
          notifyListeners();
        } else {
          reportScreenLoading = false;
          reportState = AppStrings.apiError;
          notifyListeners();
          log('failed');
        }
      } catch (e) {
        reportScreenLoading = false;
        reportState = AppStrings.apiError;
        notifyListeners();
        log(e.toString());
      }
    } else {
      reportScreenLoading = false;
      reportState = AppStrings.apiNoInternet;
      notifyListeners();
    }
  }

  //Create service api
  createServiceApi(ServiceData serviceData, BuildContext context) async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        var response = await PosRepository()
            .createService(createParam: serviceData.toMap());
        log('create service response:$response');
        if (response != null) {
          var createRespo = ServiceResponseModel.fromMap(response);
          notifyListeners();
          if (createRespo.success == true) {
            log('create service successfully');
            Themes.showSnackBar(
                context: context, msg: 'Service successfully added');

            return "success";
          }
        } else {
          log(' response null');
          return "failed";
        }
      } catch (e) {
        log('create service error');
        log(e.toString());
        return "failed";
      }
    }
  }

  //Create service api
  createEmployeeApi(User employeeData, BuildContext context) async {
    bool internetAvailable = await checkInternet();
    if (internetAvailable == true) {
      try {
        var response = await PosRepository()
            .createEmployee(createParam: employeeData.toMap());
        log('create employee response:$response');
        if (response != null) {
          var createRespo = AddEmployeeResponse.fromMap(response);
          notifyListeners();
          if (createRespo.success == true) {
            log('create employee successfully');
            Themes.showSnackBar(
                context: context, msg: 'Employee successfully added');

            return "success";
          } else {
            Themes.showSnackBar(
                context: context, msg: '${createRespo.message}');
            return "failed";
          }
        } else {
          log(' response null');
          return "failed";
        }
      } catch (e) {
        log('create employee error');
        log(e.toString());
        return "failed";
      }
    }
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != fromDate) {
      fromDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != toDate) {
      toDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectOpenDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: openDate,
        firstDate: DateTime(2023, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != toDate) {
      openDate = picked;
      openingDate = picked.toString().substring(0, 10);
      var date = "${openDate.day}-${openDate.month}-${fromDate.year}";
      await fetchDayStatus(date, "DAY_OPEN", context);
      _prefs!.setString('openingDate', date);
    }
  }

  Future<void> selectOpenClose(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: openDate,
        lastDate: DateTime.now());
    if (picked != null && picked != toDate) {
      dayClosePopup(context, picked);
    }
  }

  onPressCheckoutMobile(BuildContext context) {
    if (cartItems.isEmpty) {
      Themes.showSnackBar(msg: 'Please Add Items To Cart', context: context);
    } else {
      mobileCheckoutVisible = true;
      notifyListeners();
    }
  }

  Future<Uint8List> generateInvoice(PosScreenViewModel pos) async {
    print('****');

    saveSingleSale(BuildContext context) async {
      print('****');
      if (customerNameController.text.isEmpty &&
          customerNumberController.text.isNotEmpty) {
        Themes.showSnackBar(
            msg: 'Please Enter Customer Name', context: context);
      } else if (customerNumberController.text.isEmpty &&
          customerNameController.text.isNotEmpty) {
        Themes.showSnackBar(
            msg: 'Please Enter Customer Number', context: context);
      } else if (cartItems.isEmpty) {
        Themes.showSnackBar(msg: 'Please Add Items To Cart', context: context);
      } else {
        List<User> userDetails = await DataBaseHelper.instance.getUserDetails();
        user = userDetails
            .where((element) =>
                element.id == int.parse(_prefs!.getString(AppStrings.userId)!))
            .toList();
        int id = isEditEnabled ? editBillId! : user![0].salesCount!;
        String date = _prefs!.getString("openingDate")!;
        date = date.isEmpty ? DateTime.now().toString().substring(0, 10) : date;
        // String dateTemp = _prefs!.getString(AppStrings.userDate)!;
        String userId = _prefs!.getString(AppStrings.userId)!;
        String code = _prefs!.getString("code")!;
        int sCount = user![0].salesCount!;
        log('sales count when saving$sCount');
        singleSale = SingleLocalSaleModel(
            date: isEditEnabled ? editDate : date,
            customerName: customerNameController.text,
            customerMobile: customerNumberController.text,
            total: subTotal.toString(),
            discount: discount.toString(),
            grandTotal: (total - discount).toString(),
            overTimeFlag: otBills ? 'true' : 'false',
            createdBy: isEditEnabled ? editCreatedBy : int.parse(userId),
            updatedBy: int.parse(userId),
            id: id,
            type: isEditEnabled ? 'synced' : 'unSynced',
            syncedId: isEditEnabled ? editBillId : null,
            counterInvoice:
                isEditEnabled ? editCounterInvoice : 'ATLAS/$sCount',
            branchId: _prefs!.getInt(AppStrings.branchId),
            products: [],
            services: [],
            payments: []);
        for (int i = 0; i < cartItems.length; i++) {
          if (cartItems[i].productType == 'Products') {
            singleSale!.products!.add(SingleLocalSaleProduct(
              productId: cartItems[i].id,
              price: cartItems[i].price.toString(),
              employeeId: cartItems[i].servicedById,
              saleId: id,
              editId: cartItems[i].editId,
            ));
          } else {
            singleSale!.services!.add(SingleLocalSaleService(
              serviceId: cartItems[i].id,
              price: cartItems[i].price.toString(),
              employeeId: cartItems[i].servicedById,
              saleId: id,
              editId: cartItems[i].editId,
            ));
          }
        }
        for (int i = 0; i < paymentMethods.length; i++) {
          singleSale!.payments!.add(SingleLocalSalePayment(
              id: paymentMethods[i].id,
              paymentMethod: paymentMethods[i].type,
              amount: paymentMethods[i].amount,
              saleId: id));
        }

        await DataBaseHelper.instance.addLocalSale(
            data1Date: isEditEnabled ? editDate : date,
            data1CustomerName: customerNameController.text.isNotEmpty
                ? customerNameController.text
                : ' ',
            data1CustomerMobile: customerNumberController.text.isNotEmpty
                ? customerNumberController.text
                : ' ',
            data1Total: subTotal.toString(),
            data1Discount: discount.toString(),
            data1GrandTotal: (total - discount).toString(),
            data1OverTimeFlag: otBills,
            data1CreatedBy: isEditEnabled ? editCreatedBy : int.parse(userId),
            data1UpdatedBy: int.parse(userId),
            data1Id: id,
            type: isEditEnabled ? 'synced' : 'unSynced',
            syncedId: isEditEnabled ? editBillId : null,
            counterInvoice:
                isEditEnabled ? editCounterInvoice : '$code/$sCount',
            branchId: _prefs!.getInt(AppStrings.branchId));
        await DataBaseHelper.instance.addLocalProduct(singleSale!.products!);
        await DataBaseHelper.instance.addLocalService(singleSale!.services!);
        await DataBaseHelper.instance.addLocalPayment(singleSale!.payments!);

        // _prefs!.setInt(AppStrings.userBillCount, id + 1);
        // int newId=_prefs!.getInt(AppStrings.userBillCount)!;

        if (Platform.isAndroid) {
          await printInvoice();
        }
        if (isEditEnabled == false) {
          user![0].salesCount = user![0].salesCount! + 1;
          await DataBaseHelper.instance.editUser(user![0]);
        }

        clearCart(context);
        paymentTypes = [];
        paymentDropDown = [];
        paymentMethods = [];
        syncSale();
        _prefs!.clearAll();
        // _prefs!.setInt(AppStrings.userBillCount, newId);
        checkoutLoading = false;
        Get.offAllNamed('/pinScreen');
        notifyListeners();
      }
    }

    checkoutLoading = false;
    List<User> userDetails = await DataBaseHelper.instance.getUserDetails();
    user = userDetails
        .where((element) =>
            element.id == int.parse(_prefs!.getString(AppStrings.userId)!))
        .toList();

    String userName = _prefs!.getString(AppStrings.userName)!;
    String code = _prefs!.getString("code")!;
    int sCount = user![0].salesCount!;

    final pdf = pw.Document();
    final DateTime now = DateTime.now();

    // Format the date
    final String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    final String formattedDate1 = DateFormat('dd-MM-yyyy').format(now);
    final time = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(time);

    String invoiceNumber = '$code/$sCount';
    final barcode = Barcode.code128(); // Using Code128 barcode type
    final barcodeSvg = barcode.toSvg(
      invoiceNumber, // Setting the invoice number as barcode data
      width: 200, // Adjust the width as needed
      height: 80, // Adjust the height as needed
    );
    final barcodeImage = pw.SvgImage(svg: barcodeSvg);

    try {
      final ByteData fontData =
          await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
      final pw.Font ttf = pw.Font.ttf(fontData);
      final ByteData fontDataAr =
          await rootBundle.load("assets/fonts/cairo.ttf");
      final pw.Font ttfAr = pw.Font.ttf(fontDataAr);

      final ByteData fontData2 =
          await rootBundle.load("assets/fonts/Amiri-Regular.ttf");
      final pw.Font ttf2 = pw.Font.ttf(fontData2);

      final ByteData logoData =
          await rootBundle.load("assets/images/logo.jpeg");
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final pw.MemoryImage logo = pw.MemoryImage(logoBytes);

      final ByteData last = await rootBundle.load("assets/images/thnks.png");
      final Uint8List lastBytes = last.buffer.asUint8List();
      final pw.MemoryImage text1 = pw.MemoryImage(lastBytes);

      final ByteData last1 = await rootBundle.load("assets/images/invoice.png");
      final Uint8List lastBytes1 = last1.buffer.asUint8List();
      final pw.MemoryImage text2 = pw.MemoryImage(lastBytes1);

      final ByteData last2 = await rootBundle.load("assets/images/date.png");
      final Uint8List lastBytes2 = last2.buffer.asUint8List();
      final pw.MemoryImage text3 = pw.MemoryImage(lastBytes2);

      final ByteData last3 = await rootBundle.load("assets/images/cus.png");
      final Uint8List lastBytes3 = last3.buffer.asUint8List();
      final pw.MemoryImage text4 = pw.MemoryImage(lastBytes3);

      final ByteData last4 = await rootBundle.load("assets/images/paymode.png");
      final Uint8List lastBytes4 = last4.buffer.asUint8List();
      final pw.MemoryImage text5 = pw.MemoryImage(lastBytes4);

      final ByteData last5 = await rootBundle.load("assets/images/item.png");
      final Uint8List lastBytes5 = last5.buffer.asUint8List();
      final pw.MemoryImage text6 = pw.MemoryImage(lastBytes5);

      final ByteData last6 = await rootBundle.load("assets/images/rice.png");
      final Uint8List lastBytes6 = last6.buffer.asUint8List();
      final pw.MemoryImage text7 = pw.MemoryImage(lastBytes6);

      final ByteData last7 = await rootBundle.load("assets/images/qty.png");
      final Uint8List lastBytes7 = last7.buffer.asUint8List();
      final pw.MemoryImage text8 = pw.MemoryImage(lastBytes7);

      final ByteData last8 = await rootBundle.load("assets/images/amount.png");
      final Uint8List lastBytes8 = last8.buffer.asUint8List();
      final pw.MemoryImage text9 = pw.MemoryImage(lastBytes8);

      final ByteData last9 =
          await rootBundle.load("assets/images/netvalue.png");
      final Uint8List lastBytes9 = last9.buffer.asUint8List();
      final pw.MemoryImage text10 = pw.MemoryImage(lastBytes9);

      final ByteData last10 = await rootBundle.load("assets/images/total.png");
      final Uint8List lastBytes10 = last10.buffer.asUint8List();
      final pw.MemoryImage text11 = pw.MemoryImage(lastBytes10);

      final ByteData last11 = await rootBundle.load("assets/images/paid.png");
      final Uint8List lastBytes11 = last11.buffer.asUint8List();
      final pw.MemoryImage text12 = pw.MemoryImage(lastBytes11);

      final ByteData last12 = await rootBundle.load("assets/images/cash.png");
      final Uint8List lastBytes12 = last12.buffer.asUint8List();
      final pw.MemoryImage text13 = pw.MemoryImage(lastBytes12);

      final ByteData last13 = await rootBundle.load("assets/images/card.png");
      final Uint8List lastBytes13 = last13.buffer.asUint8List();
      final pw.MemoryImage text14 = pw.MemoryImage(lastBytes13);

      final ByteData last14 = await rootBundle.load("assets/images/cheque.png");
      final Uint8List lastBytes14 = last14.buffer.asUint8List();
      final pw.MemoryImage text15 = pw.MemoryImage(lastBytes14);

      final ByteData qrData =
          await rootBundle.load("assets/images/QR Code.png");
      final Uint8List qrBytes = qrData.buffer.asUint8List();
      final pw.MemoryImage qrCode = pw.MemoryImage(qrBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(80 * PdfPageFormat.mm,
              double.infinity), // Set height to undefined for dynamic height
          // margin: pw.EdgeInsets.all(5 * PdfPageFormat.mm),
          margin: const pw.EdgeInsets.only(
              left: 5 * PdfPageFormat.mm,
              top: 5 * PdfPageFormat.mm,
              bottom: 5 * PdfPageFormat.mm,
              right: 10 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Logo
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Image(logo, height: 30),
                ),
                pw.SizedBox(height: 5),

                // Store Name
                // pw.Align(
                //   alignment: pw.Alignment.center,
                //   child: pw.Text(
                //     'ATLAS BOOKSTORE',
                //     style: pw.TextStyle(
                //         font: ttf,
                //         fontSize: 14,
                //         fontWeight: pw.FontWeight.bold),
                //   ),
                // ),

                // Store Address
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'MSHEIREB\nDOHA',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: ttf, fontSize: 9),
                  ),
                ),
                pw.SizedBox(height: 5),

                // Invoice Details
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('Invoice No / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Image(text2, height: 10),
                    ]),
                    pw.Text('$code/$sCount ',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('Invoice Date / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Image(text3, height: 10),
                    ]),
                    pw.Text('${formattedDate} ',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('Customer Name / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Image(text4, height: 10),
                    ]),
                    pw.Text('${customerNameController.text} ',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('Payment Mode / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Image(text5, height: 10),
                    ]),
                    pw.Text('${pos.selectedMethod} ',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.Divider(),

                // Header for Items
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text('ITEM',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                    ),
                    pw.Expanded(
                      child: pw.Text('PRICE',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                    ),
                    pw.Expanded(
                      child: pw.Text('QTY',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                    ),
                    pw.Expanded(
                      child: pw.Text('AMOUNT',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                    ),
                  ],
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(right: 20),
                  child: pw.SizedBox(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Image(text6, height: 10),
                        ),
                        pw.Expanded(
                          child: pw.Image(text7, height: 10),
                        ),
                        pw.Expanded(
                          child: pw.Image(text8, height: 10),
                        ),
                        pw.Expanded(
                          child: pw.Image(text9, height: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.Divider(),

                // List of Items
                pw.ListView.builder(
                  itemCount: pos.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = pos.cartItems[index];
                  print('---------------------${pos.cartItems[index].name}');
                  print('---------------------${pos.cartItems[index].arabicName}');

                   
                   

                    
                   
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(top: 8.0),
                          child: pw.Text(item.name.toString(),
                              style: pw.TextStyle(font: ttf, fontSize: 8)),
                        ),
                        if(item.arabicName!=null)
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(top: 2.0),
                                child: pw.Text(item.arabicName.toString(),
                                    style:
                                        pw.TextStyle(font: ttf2, fontSize: 8),
                                    textDirection: pw.TextDirection.rtl),
                              ),
                            ]),

                        // pw.Divider(thickness: 0.01),
                        pw.Row(
                          children: [
                            pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                width: 0.25,
                              )),
                              child: pw.Text('_',
                                  style: pw.TextStyle(font: ttf, fontSize: 8)),
                              width: 45, // You can adjust the width as needed
                            ),
                            pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                width: 0.25,
                              )),
                              width: 60, // You can adjust the width as needed
                              child: pw.Padding(
                                padding: pw.EdgeInsets.only(left: 4.0),
                                child: pw.Text(
                                    '${item.price?.toStringAsFixed(2)}',
                                    style:
                                        pw.TextStyle(font: ttf, fontSize: 8)),
                              ),
                            ),
                            pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                width: 0.25,
                              )),

                              width: 30, // You can adjust the width as needed
                              child: pw.Padding(
                                padding: pw.EdgeInsets.only(left: 4.0),
                                child: pw.Text('1', // Assuming quantity is 1
                                    style:
                                        pw.TextStyle(font: ttf, fontSize: 8)),
                              ),
                            ),
                            pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.symmetric(
                                horizontal: pw.BorderSide(width: 0.25),
                              )),

                              width: 60, // You can adjust the width as needed
                              child: pw.Padding(
                                padding: pw.EdgeInsets.only(left: 4.0),
                                child: pw.Text(
                                    '${item.price?.toStringAsFixed(2)}',
                                    style:
                                        pw.TextStyle(font: ttf, fontSize: 8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                pw.Divider(),
                pw.SizedBox(height: 5),

                // Total Information

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('NET VALUE / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Image(text10, height: 10),
                    ]),
                    pw.Text('${pos.total.toStringAsFixed(2)} Qr',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('TOTAL / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Image(text11, height: 10),
                    ]),
                    pw.Text('${pos.total.toStringAsFixed(2)} Qr',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('PAID / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Image(text12, height: 10),
                    ]),
                    pw.Text('${pos.total.toStringAsFixed(2)} Qr',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(children: [
                      pw.Text('${pos.selectedMethod} / ',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pos.selectedMethod == 'CASH'
                          ? pw.Image(text13, height: 10)
                          : pos.selectedMethod == 'CARD'
                              ? pw.Image(text14, height: 10)
                              : pw.Image(text15, height: 10),
                    ]),
                    pw.Text('${pos.total.toStringAsFixed(2)} Qr',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ],
                ),
                pw.SizedBox(height: 5),

                // QR Code
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
                  child: pw.Align(
                    alignment: pw.Alignment.center,
                    child: barcodeImage, // Display the barcode
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'Served By $userName',
                    style: pw.TextStyle(font: ttf, fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                // pw.Align(
                //         alignment: pw.Alignment.center,
                //         child: pw.Text(
                //           'Biller : ${userName}',
                //           style: pw.TextStyle(font: ttf, fontSize: 8),
                //           textAlign: pw.TextAlign.center,
                //         ),
                //       ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Align(
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          formattedDate1,
                          style: pw.TextStyle(font: ttf, fontSize: 8),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Align(
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          formattedTime,
                          style: pw.TextStyle(font: ttf, fontSize: 8),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ]),

                // // Thank You Message
                // pw.Align(
                //   alignment: pw.Alignment.center,
                //   child: pw.Text(
                //     'THANKS FOR SHOPPING WITH US VISIT US AGAIN ',
                //     style: pw.TextStyle(font: ttf, fontSize: 8),
                //     textAlign: pw.TextAlign.center,
                //   ),
                // ),
                // pw.Align(
                //   alignment: pw.Alignment.center,

                //   child: pw.Image(text1, height: 30),
                //   // Text(
                //   //   'شكرًا لك على التسوق معنا، قم بزيارتنا مرة أخرى',
                //   //   style: pw.TextStyle(font: ttf2, fontSize: 8),
                //   //   textAlign: pw.TextAlign.center,
                //   // ),
                // ),
              ],
            );
          },
        ),
      );
    } catch (e) {
      print('Error generating invoice PDF: $e');
      rethrow;
    }

    return pdf.save();
  }

  printInvoice() async {
    // Uint8List byte = (await NetworkAssetBundle(Uri.parse(orgLogo!.data!.printLogo!)).load(orgLogo!.data!.printLogo!)).buffer.asUint8List();
    String userName = _prefs!.getString(AppStrings.userName)!;
    String code = _prefs!.getString("code")!;
    int sCount = user![0].salesCount!;

    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    // Uint8List byte = await _getImageFromAsset('assets/images/figma.png');
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    // await SunmiPrinter.printImage(byte);
    await SunmiPrinter.printText(branchName!,
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('TRENDZ', style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('QPOSS',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText(
        'Date : ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.printText(
        'Bill No : ${isEditEnabled ? editCounterInvoice : '$code/$sCount'}',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.printText(
        'Biller : $userName-${DateTime.now().hour}:${DateTime.now().minute}',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(text: 'Item', width: 25, align: SunmiPrintAlign.LEFT),
      ColumnMaker(text: 'Price', width: 25, align: SunmiPrintAlign.LEFT),
      ColumnMaker(text: 'Qty', width: 5, align: SunmiPrintAlign.LEFT),
      ColumnMaker(text: 'amount', width: 5, align: SunmiPrintAlign.LEFT),
    ]);

    for (int i = 0; i < cartItems.length; i++) {
      // Print the product name
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
            text: cartItems[i].name!, width: 25, align: SunmiPrintAlign.LEFT),
      ]);

      // Print the quantity, price, and amount
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
            text: 'Qty: ${cartItems[i].quantity.toString()}',
            width: 10,
            align: SunmiPrintAlign.LEFT),
        ColumnMaker(
            text: 'Price: ${cartItems[i].price!.toStringAsFixed(2)}',
            width: 10,
            align: SunmiPrintAlign.LEFT),
        ColumnMaker(
            text:
                'Amount: ${(cartItems[i].price! * cartItems[i].quantity!).toStringAsFixed(2)}',
            width: 10,
            align: SunmiPrintAlign.LEFT),
      ]);
      await SunmiPrinter.lineWrap(1); // Optional: add space between items
    }
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Sub Total : ${subTotal.toString()}',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.RIGHT));
    // await SunmiPrinter.printText('Discount : ${discount.toString()}',
    //     style: SunmiStyle(bold: true, align: SunmiPrintAlign.RIGHT));
    await SunmiPrinter.printText(
        'Grand Total : ${(total - discount).toString()}',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.RIGHT));
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(text: '', width: 15, align: SunmiPrintAlign.RIGHT),
      ColumnMaker(text: '', width: 10, align: SunmiPrintAlign.RIGHT),
    ]);
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.exitTransactionPrint(true);
  }

  printSummary() async {
    var hour = DateTime.now().hour;
    var formattedHour = 0;
    if (hour == 0) {
      formattedHour = 1;
    } else if (hour > 12) {
      formattedHour = hour % 12;
    } else {
      formattedHour = hour;
    }
    final period = hour < 12 ? 'AM' : 'PM';
    String time = '$formattedHour:${DateTime.now().minute} $period';
    // Uint8List byte = (await NetworkAssetBundle(Uri.parse(orgLogo!.data!.printLogo!)).load(orgLogo!.data!.printLogo!)).buffer.asUint8List();
    String userName = _prefs!.getString(AppStrings.userName)!;
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    // Uint8List byte = await _getImageFromAsset('assets/images/figma.png');
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    // await SunmiPrinter.printImage(byte);
    await SunmiPrinter.printText(branchName!,
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('TRENDZ', style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('QPOSS',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
        'Date : ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} $time',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.printText('Employee : $userName',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
        'First Login Time : ${daySummaryModel!.data.summary.firstBillTime}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    await SunmiPrinter.printText(
        'Last Logout Time : ${daySummaryModel!.data.summary.lastBillTime}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    await SunmiPrinter.printText(
        'No.of Bills : ${daySummaryModel!.data.summary.noOfBills}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    await SunmiPrinter.printText(
        'Amount : ${daySummaryModel!.data.summary.sale}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    // await SunmiPrinter.printText(
    //     'No.of Services : ${daySummaryModel!.data.summary.noOfServices}',
    //     style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    await SunmiPrinter.printText(
        'Amount : ${daySummaryModel!.data.summary.services}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    for (int i = 0; i < daySummaryModel!.data.payments.length; i++) {
      await SunmiPrinter.printText(
          '${daySummaryModel!.data.payments[i].debit} : ${daySummaryModel!.data.payments[i].total}',
          style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    }
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(text: '', width: 15, align: SunmiPrintAlign.RIGHT),
      ColumnMaker(text: '', width: 10, align: SunmiPrintAlign.RIGHT),
    ]);
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.exitTransactionPrint(true);
  }

  Future<void> shareInvoiceToWhatsApp(
    PosScreenViewModel pos,
  ) async {
    try {
      // Generate the invoice PDF
      
      
      final pdfBytes = await generateInvoice(pos);
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File('${tempDir.path}/invoice.pdf');
      await pdfFile.writeAsBytes(pdfBytes);

      // Message content
      final message = "Here is your invoice.";

      // Use shareXFiles to send the PDF along with the message
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: message,
        subject: 'Invoice',
      );
    } catch (e) {
      print('Error sharing invoice to WhatsApp: $e');
    }
  }

  printDayCloseReport() async {
    var hour = DateTime.now().hour;
    var formattedHour = 0;
    if (hour == 0) {
      formattedHour = 1;
    } else if (hour > 12) {
      formattedHour = hour % 12;
    } else {
      formattedHour = hour;
    }
    final period = hour < 12 ? 'AM' : 'PM';
    String time = '$formattedHour:${DateTime.now().minute} $period';
    // Uint8List byte = (await NetworkAssetBundle(Uri.parse(orgLogo!.data!.printLogo!)).load(orgLogo!.data!.printLogo!)).buffer.asUint8List();
    // String userName = _prefs!.getString(AppStrings.userName)!;
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    // Uint8List byte = await _getImageFromAsset('assets/images/figma.png');
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    // await SunmiPrinter.printImage(byte);
    await SunmiPrinter.printText(branchName!,
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    // await SunmiPrinter.printText('TRENDZ', style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printText('SALOON',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Opening Date : $openingDate',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    await SunmiPrinter.printText(
        'Date : ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} $time',
        style: SunmiStyle(align: SunmiPrintAlign.CENTER, bold: true));
    // await SunmiPrinter.printText('Employee : $userName', style: SunmiStyle(align: SunmiPrintAlign.CENTER,bold: true));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('SERVICES',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(text: 'Employee', width: 25, align: SunmiPrintAlign.LEFT),
      ColumnMaker(text: 'Amount', width: 5, align: SunmiPrintAlign.LEFT),
    ]);
    for (int i = 0; i < dayCloseReport!.data.service.length; i++) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
            text: dayCloseReport!.data.service[i].employeeName,
            width: 25,
            align: SunmiPrintAlign.LEFT),
        ColumnMaker(
            text: dayCloseReport!.data.service[i].amount.toString(),
            width: 5,
            align: SunmiPrintAlign.LEFT),
      ]);
    }
    if (dayCloseReport!.data.product.isNotEmpty) {
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.printText('PRODUCTS',
          style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(text: 'Employee', width: 25, align: SunmiPrintAlign.LEFT),
        ColumnMaker(text: 'Amount', width: 5, align: SunmiPrintAlign.LEFT),
      ]);
      for (int i = 0; i < dayCloseReport!.data.product.length; i++) {
        await SunmiPrinter.printRow(cols: [
          ColumnMaker(
              text: dayCloseReport!.data.product[i].employeeName,
              width: 25,
              align: SunmiPrintAlign.LEFT),
          ColumnMaker(
              text: dayCloseReport!.data.product[i].amount.toString(),
              width: 5,
              align: SunmiPrintAlign.LEFT),
        ]);
      }
    }
    await SunmiPrinter.printText(
        'Total Sales : ${dayCloseReport!.data.totalSales}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    if (dayCloseReport!.data.totalDiscount > 0) {
      await SunmiPrinter.printText(
          'Total Discount: ${dayCloseReport!.data.totalDiscount}',
          style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    }
    await SunmiPrinter.printText(
        'Grand Total : ${dayCloseReport!.data.grandTotal}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));

    await SunmiPrinter.printText(
        'No.of Sales : ${dayCloseReport!.data.noOfSales}',
        style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('PAYMENTS',
        style: SunmiStyle(bold: true, align: SunmiPrintAlign.CENTER));

    for (int i = 0; i < dayCloseReport!.data.payment.length; i++) {
      await SunmiPrinter.printText(
          '${dayCloseReport!.data.payment[i].name} : ${dayCloseReport!.data.payment[i].amount}',
          style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
    }

    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(text: '', width: 15, align: SunmiPrintAlign.RIGHT),
      ColumnMaker(text: '', width: 10, align: SunmiPrintAlign.RIGHT),
    ]);
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.exitTransactionPrint(true);
  }

  void showDataEntryDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: SizedBox(
                height: 250,
                width: constraints.maxWidth < 800
                    ? getWidth(context: context)
                    : getWidth(context: context) / 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PosTextField(
                        textEditingController: customerNumberController,
                        hintText: 'Customer Mobile',
                        icon: Icons.phone,
                        width: constraints.maxWidth < 800
                            ? getWidth(context: context) / 1.5
                            : getWidth(context: context) / 3,
                        fromPopUp: true,
                      ),
                      verticalSpaceSmall,
                      PosTextField(
                          textEditingController: customerNameController,
                          hintText: 'Customer Name',
                          icon: Icons.person,
                          width: constraints.maxWidth < 800
                              ? getWidth(context: context) / 1.5
                              : getWidth(context: context) / 3,
                          fromPopUp: true),
                      verticalSpaceSmall,
                      SizedBox(
                        width: constraints.maxWidth < 800
                            ? getWidth(context: context) / 1.5
                            : getWidth(context: context) / 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SquareButton(
                              onTap: () {
                                customerNameController.clear();
                                customerNumberController.clear();
                                Navigator.pop(context);
                              },
                              title: 'Skip',
                              width: constraints.maxWidth < 800
                                  ? getWidth(context: context) / 5
                                  : getWidth(context: context) / 8,
                            ),
                            SquareButton(
                              onTap: () {
                                if (customerNameController.text.isEmpty) {
                                  Themes.showSnackBar(
                                      context: context,
                                      msg: "Enter Customer Name");
                                } else if (customerNumberController
                                    .text.isEmpty) {
                                  Themes.showSnackBar(
                                      context: context,
                                      msg: "Enter Customer Number");
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              title: 'Save',
                              width: constraints.maxWidth < 800
                                  ? getWidth(context: context) / 5
                                  : getWidth(context: context) / 8,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  //List<String> branchList=['TALENT','TRENDZ'];
  List<String> branchList = ['TALENT'];
  // String selectedBranch='TALENT';
  String selectedBranch = 'TALENT';
  List<String> userTypeList = ['Employee', 'User'];
  String selectedUser = 'Employee';
  void showBranchUserTypeDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: SizedBox(
                  height: 200,
                  width: constraints.maxWidth < 800
                      ? getWidth(context: context)
                      : getWidth(context: context) / 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Branch  ',
                              style:
                                  mainSubHeadingStyle().copyWith(fontSize: 15),
                            ),
                            Container(
                              height: 40,
                              width: constraints.maxWidth < 800
                                  ? getWidth(context: context) / 3
                                  : getWidth(context: context) / 8,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.textFieldBorder,
                                border: Border.all(
                                    color: AppColors.textFieldBorder, width: 2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: DropDown<String>(
                                customWidgets: branchList
                                    .map((e) => Text(
                                          e,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14),
                                          maxLines: 2,
                                        ))
                                    .toList(),
                                showUnderline: false,
                                isExpanded: true,
                                initialValue: selectedBranch,
                                // initialValue: pos.employeeList![pos.employeeList!.indexWhere((element) => element.name==pos.userName)],
                                items: branchList,
                                onChanged: (value) {
                                  selectedBranch = value!;
                                  notifyListeners();
                                },
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'User Type  ',
                              style:
                                  mainSubHeadingStyle().copyWith(fontSize: 15),
                            ),
                            Container(
                              height: 40,
                              width: constraints.maxWidth < 800
                                  ? getWidth(context: context) / 3
                                  : getWidth(context: context) / 8,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.textFieldBorder,
                                border: Border.all(
                                    color: AppColors.textFieldBorder, width: 2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: DropDown<String>(
                                customWidgets: userTypeList
                                    .map((e) => Text(
                                          e,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14),
                                          maxLines: 2,
                                        ))
                                    .toList(),
                                showUnderline: false,
                                isExpanded: true,
                                initialValue: selectedUser,
                                // initialValue: pos.employeeList![pos.employeeList!.indexWhere((element) => element.name==pos.userName)],
                                items: userTypeList,
                                onChanged: (value) {
                                  selectedUser = value!;
                                  notifyListeners();
                                },
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SquareButton(
                          onTap: () {
                            _prefs!.setString(
                                AppStrings.orgNameSet, selectedBranch);
                            _prefs!
                                .setString(AppStrings.userType, selectedUser);
                            /*if(selectedBranch=='TALENT'){
                                  ServerAddresses.baseUrl=ServerAddresses.talentsBaseUrl;
                                  ServerAddresses.logoUrl=ServerAddresses.talentsLogoUrl;
                                }
                                else{
                                  ServerAddresses.baseUrl=ServerAddresses.trendsBaseUrl;
                                  ServerAddresses.logoUrl=ServerAddresses.trendsLogoUrl;
                                }*/
                            ServerAddresses.baseUrl =
                                ServerAddresses.talentsBaseUrl;
                            ServerAddresses.logoUrl =
                                ServerAddresses.talentsLogoUrl;
                            userType = selectedUser;
                            branchName = selectedBranch;
                            notifyListeners();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PinLogin()));
                          },
                          title: 'Save',
                          width: constraints.maxWidth < 800
                              ? getWidth(context: context) / 5
                              : getWidth(context: context) / 8,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  //Reports
  List<String> typesOfReport = [
    'Employee-Summary',
    'Summary-Billwise',
    'Detailed',
    'Commission-Daywise',
    'Commission-Summary'
  ];

  List<String> productsAndService = [
    'Products',
    'Services',
  ];
  ScrollController reportScrollController = ScrollController();

  handlePayment(BuildContext context, methodType) {}

  //Report Screen Drawer
  // final GlobalKey<ScaffoldState> reportScaffoldKey = GlobalKey<ScaffoldState>();
}
