// To parse this JSON data, do
//
//     final commissionDayWiseModel = commissionDayWiseModelFromMap(jsonString);

import 'dart:convert';

CommissionDayWiseModel commissionDayWiseModelFromMap(String str) => CommissionDayWiseModel.fromMap(json.decode(str));

String commissionDayWiseModelToMap(CommissionDayWiseModel data) => json.encode(data.toMap());

class CommissionDayWiseModel {
  bool? success;
  Data? data;
  String? message;

  CommissionDayWiseModel({
    this.success,
    this.data,
    this.message,
  });

  factory CommissionDayWiseModel.fromMap(Map<String, dynamic> json) => CommissionDayWiseModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromMap(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data?.toMap(),
    "message": message,
  };
}

class Data {
  List<Product>? product;
  List<Service>? service;

  Data({
    this.product,
    this.service,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    product: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((x) => Product.fromMap(x))),
    service: json["service"] == null ? [] : List<Service>.from(json["service"]!.map((x) => Service.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "product": product == null ? [] : List<dynamic>.from(product!.map((x) => x.toMap())),
    "service": service == null ? [] : List<dynamic>.from(service!.map((x) => x.toMap())),
  };
}

class Product {
  int? productId;
  String? productName;
  int? total;
  int? otAmount;
  int? commissionAmount;

  Product({
    this.productId,
    this.productName,
    this.total,
    this.otAmount,
    this.commissionAmount,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    productName: json["product_name"],
    total: json["total"],
    otAmount: json["ot_commission_amount"],
    commissionAmount: json["commission_amount"],
  );

  Map<String, dynamic> toMap() => {
    "product_id": productId,
    "product_name": productName,
    "total": total,
    "ot_commission_amount": otAmount,
    "commission_amount": commissionAmount,
  };
}

class Service {
  int? serviceId;
  String? serviceName;
  int? total;
  int? otAmount;
  int? commissionAmount;
  String? employee;
  String? date;

  Service({
    this.serviceId,
    this.serviceName,
    this.total,
    this.otAmount,
    this.commissionAmount,
    this.employee,
    this.date,
  });

  factory Service.fromMap(Map<String, dynamic> json) => Service(
    serviceId: json["service_id"],
    serviceName: json["service_name"],
    total: json["total"],
    otAmount: json["ot_commission_amount"],
    commissionAmount: json["commission_amount"],
    employee: json["employee"],
    date: json["date"]??"",
  );

  Map<String, dynamic> toMap() => {
    "service_id": serviceId,
    "service_name": serviceName,
    "total": total,
    "ot_commission_amount": otAmount,
    "commission_amount": commissionAmount,
    "employee": employee,
    "date": date,
  };
}
