// To parse this JSON data, do
//
//     final dayCloseReportModel = dayCloseReportModelFromMap(jsonString);

import 'dart:convert';

DayCloseReportModel dayCloseReportModelFromMap(String str) => DayCloseReportModel.fromMap(json.decode(str));

String dayCloseReportModelToMap(DayCloseReportModel data) => json.encode(data.toMap());

class DayCloseReportModel {
  bool success;
  Data data;
  String message;

  DayCloseReportModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory DayCloseReportModel.fromMap(Map<String, dynamic> json) => DayCloseReportModel(
    success: json["success"],
    data: Data.fromMap(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data.toMap(),
    "message": message,
  };
}

class Data {
  int noOfSales;
  List<Product> product;
  List<Product> service;
  int totalSales;
  int totalDiscount;
  int grandTotal;
  List<Payment> payment;

  Data({
    required this.noOfSales,
    required this.product,
    required this.service,
    required this.totalSales,
    required this.totalDiscount,
    required this.grandTotal,
    required this.payment,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    noOfSales: json["no_of_sales"],
    product: List<Product>.from(json["product"].map((x) => Product.fromMap(x))),
    service: List<Product>.from(json["service"].map((x) => Product.fromMap(x))),
    totalSales: json["total_sales"],
    totalDiscount: json["total_discount"],
    grandTotal: json["grand_total"],
    payment: List<Payment>.from(json["payment"].map((x) => Payment.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "no_of_sales": noOfSales,
    "product": List<dynamic>.from(product.map((x) => x.toMap())),
    "service": List<dynamic>.from(service.map((x) => x.toMap())),
    "total_sales": totalSales,
    "total_discount": totalDiscount,
    "grand_total":grandTotal,
    "payment": List<dynamic>.from(payment.map((x) => x.toMap())),
  };
}

class Payment {
  String name;
  int amount;

  Payment({
    required this.name,
    required this.amount,
  });

  factory Payment.fromMap(Map<String, dynamic> json) => Payment(
    name: json["name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "amount": amount,
  };
}

class Product {
  int employeeId;
  String employeeName;
  int amount;

  Product({
    required this.employeeId,
    required this.employeeName,
    required this.amount,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    employeeId: json["employee_id"],
    employeeName: json["employee_name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toMap() => {
    "employee_id": employeeId,
    "employee_name": employeeName,
    "amount": amount,
  };
}