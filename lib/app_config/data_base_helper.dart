
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saloon_pos/features/account/model/login_model.dart';
import 'package:saloon_pos/features/pos/model/category_model.dart';
import 'package:saloon_pos/features/pos/model/employee_model.dart';
import 'package:saloon_pos/features/pos/model/payment_method_model.dart';
import 'package:saloon_pos/features/pos/model/products_model.dart';
import 'package:saloon_pos/features/pos/model/single_local_sale_model.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper{
  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance=DataBaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database??=await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path=join(documentsDirectory.path,'saloon_pos.db');
    log(documentsDirectory.path);
    return await openDatabase(path,version: 1,onCreate: _onCreate);
  }

  Future _onCreate(Database db,int version)async{
    await db.execute('''
    CREATE TABLE user_details(
    id INTEGER PRIMARY KEY,
    branch_id INTEGER,
    name TEXT,
    code TEXT,
    place TEXT,
    mobile TEXT,
    email TEXT,
    pin INTEGER,
    nationality TEXT,
    salary INTEGER,
    hra INTEGER,
    allowance INTEGER,
    designation_id INTEGER,
    dob TEXT,
    doj TEXT,
    flag INTEGER,
    token TEXT,
    logged_at TEXT,
    admin_flag TEXT,
    opening_date TEXT,
    total_no_of_sales INTEGER,
    password TEXT
    )''');

    await db.execute('''
    CREATE TABLE product_categories(
    id INTEGER PRIMARY KEY,
    name TEXT,
    arabic_name TEXT
    )''');

    await db.execute('''
    CREATE TABLE service_categories(
    id INTEGER PRIMARY KEY,
    name TEXT,
    arabic_name TEXT
    )''');

    await db.execute('''
    CREATE TABLE products(
    id INTEGER PRIMARY KEY,
    name TEXT,
    arabic_name TEXT,
    group_id INTEGER,
    `group` TEXT,
    price INTEGER,
    time INTEGER,
    description TEXT,
    serviced_by INTEGER,
    product_type TEXT,
    edit_id INTEGER,
    image_path TEXT,
    category_id TEXT
    )''');

    await db.execute('''
    CREATE TABLE services(
    id INTEGER PRIMARY KEY,
    name TEXT,
    arabic_name TEXT,
    group_id INTEGER,
    `group` TEXT,
    price INTEGER,
    time INTEGER,
    description TEXT,
    serviced_by INTEGER,
    product_type TEXT,
    edit_id INTEGER,
    image_path TEXT,
    category_id TEXT
    )''');

    await db.execute('''
    CREATE TABLE employee(
    id INTEGER PRIMARY KEY,
    name TEXT
    )''');

    await db.execute('''
    CREATE TABLE paymentMethods(
    id INTEGER PRIMARY KEY,
    name TEXT
    )''');

    await db.execute('''
    CREATE TABLE localSale(
    date TEXT,
    customerName TEXT,
    customerMobile TEXT,
    total TEXT,
    discount TEXT,
    grandTotal TEXT,
    overTimeFlag TEXT,
    createdBy INTEGER,
    updatedBy INTEGER,
    id INTEGER PRIMARY KEY,
    type TEXT,
    syncedId INTEGER,
    counter_invoice_no TEXT,
    branch_id INTEGER
    )''');



    await db.execute('''
    CREATE TABLE localProducts(
    saleId INTEGER,
    productId INTEGER,
    employeeId INTEGER,
    price TEXT,
    editId INTEGER
    )''');



    await db.execute('''
    CREATE TABLE localServices(
    saleId INTEGER,
    serviceId INTEGER,
    employeeId INTEGER,
    price TEXT,
    editId INTEGER
    )''');



    await db.execute('''
    CREATE TABLE localPayments(
    saleId INTEGER,
    id INTEGER,
    paymentMethod TEXT,
    amount TEXT
    )''');


  }

  //User Details
  Future<List<User>> getUserDetails()async{
    Database db= await instance.database;
    var userDetails=await db.query('user_details');
   List<User> userData=userDetails.map((e) => User.fromMap(e)).toList();
   return userData;
  }

  Future<int> add(User userData) async{
    log('${userData.id},${userData.loggedAt},${userData.name},${userData.code},${userData.dob},${userData.doj},${userData.branchId}');
    log('reching add');
    Database db= await instance.database;
    return await db.insert('user_details', userData.toMap());
  }

  Future<int> removeUser() async{
    Database db= await instance.database;
    List<Map<String, dynamic>> rows = await db.query('user_details');
    if (rows.isNotEmpty) {
      int firstRowId = rows.first['id'];

      // Delete the first row
      return await db.delete('user_details', where: 'id = ?', whereArgs: [firstRowId]);
    }
    else{
      log('empty database');
      return 1;
    }
  }

  Future<int> editUser(User userData)async{
    log('${userData.id},${userData.loggedAt},${userData.name},${userData.code},${userData.dob},${userData.doj},${userData.branchId}');
    Database db=await instance.database;
    return await db.update('user_details', userData.toMap(),where: 'id = ?', whereArgs: [userData.id]);
  }

  //Product & Service Categories Categories
  Future<List<Datum>> getProductCategories(String tableName)async{
    Database db= await instance.database;
    var productCategories=await db.query(tableName);
    List<Datum> productCategory=productCategories.map((e) => Datum.fromMap(e)).toList();
    return productCategory;
  }

  Future<int> addProductCategory(Datum productCategories,String tableName) async{
    Database db= await instance.database;
    return await db.insert(tableName, productCategories.toMap());
  }

  Future<int> removeTable(String tableName) async{
    Database db= await instance.database;
    return await db.delete(tableName);
  }

  //Products & Services
  Future<List<ProductDatum>> getProductAndService(String tableName)async{
    Database db= await instance.database;
    var productAndServices=await db.query(tableName);
    List<ProductDatum> productAndService=productAndServices.map((e) => ProductDatum.fromMap(e)).toList();
    log('product datum length ${productAndService.length}');
    return productAndService;
  }

  Future<int> addProductAndService(ProductDatum productAndService,String tableName) async{
    Database db= await instance.database;
    return await db.insert(tableName, productAndService.toMap());
  }

  //Employees
  Future<List<EmployeeDatum>> getEmployees(String tableName)async{
    Database db= await instance.database;
    var employees=await db.query(tableName);
    List<EmployeeDatum> employeesList=employees.map((e) => EmployeeDatum.fromMap(e)).toList();
    return employeesList;
  }

  Future<int> addEmployees(EmployeeDatum employee,String tableName) async{
    Database db= await instance.database;
    return await db.insert(tableName, employee.toMap());
  }

  //Payment
  Future<List<PaymentDatum>> getPaymentMethods(String tableName)async{
    Database db= await instance.database;
    var payments=await db.query(tableName);
    List<PaymentDatum> paymentList=payments.map((e) => PaymentDatum.fromMap(e)).toList();
    return paymentList;
  }

  Future<int> addPaymentMethod(PaymentDatum payment,String tableName) async{
    Database db= await instance.database;
    return await db.insert(tableName, payment.toMap());
  }

  Future<int> addLocalSale({String? data1Date,String? data1CustomerName,String? data1CustomerMobile,String? data1Total,String? data1Discount,String? data1GrandTotal,bool? data1OverTimeFlag,int? data1CreatedBy,int? data1UpdatedBy, int? data1Id,String? type,int? syncedId,String? counterInvoice,int? branchId}) async{
    Database db= await instance.database;
    return await db.insert('localSale', {'date':data1Date,'customerName':data1CustomerName,'customerMobile':data1CustomerMobile,'total':data1Total,'discount':data1Discount,'grandTotal':data1GrandTotal,'overTimeFlag':data1OverTimeFlag.toString(),'createdBy':data1CreatedBy,'updatedBy':data1UpdatedBy,'id':data1Id,'type':type,'syncedId':syncedId,'counter_invoice_no':counterInvoice,'branch_id':branchId});
  }



   addLocalProduct(List<SingleLocalSaleProduct> sale) async{
    Database db= await instance.database;
    for(int i=0;i<sale.length;i++){
       await db.insert('localProducts', sale[i].toMap());
    }

  }



   addLocalService(List<SingleLocalSaleService> sale) async{
    Database db= await instance.database;
    for(int i=0;i<sale.length;i++){
      await db.insert('localServices', sale[i].toMap());
    }
  }



   addLocalPayment(List<SingleLocalSalePayment> sale) async{
    Database db= await instance.database;
    for(int i=0;i<sale.length;i++){
      await db.insert('localPayments', sale[i].toMap());
    }
  }



  Future<List<SingleLocalSaleModel>> getLocalSale()async{
    Database db= await instance.database;
    var localSale=await db.query('localSale');
    log(localSale.toString());
    List<SingleLocalSaleModel> localSaleList=localSale.map((e) => SingleLocalSaleModel.fromMap(e)).toList();
    var localProduct=await db.query('localProducts');
    List<SingleLocalSaleProduct> localSaleProduct=localProduct.map((e) => SingleLocalSaleProduct.fromMap(e)).toList();
    var localService=await db.query('localServices');
    List<SingleLocalSaleService> localSaleService=localService.map((e) => SingleLocalSaleService.fromMap(e)).toList();
    var localPayments=await db.query('localPayments');
    List<SingleLocalSalePayment> localSalePayment=localPayments.map((e) => SingleLocalSalePayment.fromMap(e)).toList();

    for(int i=0;i<localSaleList.length;i++){

      List<SingleLocalSaleProduct> filteredProductList=localSaleProduct.where((element) => element.saleId==localSaleList[i].id).toList();
      List<SingleLocalSaleService> filteredServiceList=localSaleService.where((element) => element.saleId==localSaleList[i].id).toList();
      List<SingleLocalSalePayment> filteredPaymentList=localSalePayment.where((element) => element.saleId==localSaleList[i].id).toList();
      localSaleList[i].products=filteredProductList;
      localSaleList[i].services=filteredServiceList;
      localSaleList[i].payments=filteredPaymentList;
    }

    return localSaleList;
  }




}