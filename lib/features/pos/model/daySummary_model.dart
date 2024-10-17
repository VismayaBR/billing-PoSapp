// To parse this JSON data, do
//
//     final daySummaryModel = daySummaryModelFromJson(jsonString);

import 'dart:convert';

DaySummaryModel daySummaryModelFromJson(String str) => DaySummaryModel.fromJson(json.decode(str));

String daySummaryModelToJson(DaySummaryModel data) => json.encode(data.toJson());

class DaySummaryModel {
  bool success;
  Data data;
  String message;

  DaySummaryModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory DaySummaryModel.fromJson(Map<String, dynamic> json) => DaySummaryModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Summary summary;
  List<Payment> payments;
  List<Service> services;
  List<dynamic> products;

  Data({
    required this.summary,
    required this.payments,
    required this.services,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    summary: Summary.fromJson(json["summary"]),
    payments: List<Payment>.from(json["payments"].map((x) => Payment.fromJson(x))),
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
    products: List<dynamic>.from(json["products"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "summary": summary.toJson(),
    "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "products": List<dynamic>.from(products.map((x) => x)),
  };
}

class Payment {
  String debit;
  int total;

  Payment({
    required this.debit,
    required this.total,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    debit: json["debit"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "debit": debit,
    "total": total,
  };
}

class Service {
  int employeeId;
  String employee;
  int spaServiceId;
  String service;
  int total;

  Service({
    required this.employeeId,
    required this.employee,
    required this.spaServiceId,
    required this.service,
    required this.total,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    employeeId: json["employee_id"],
    employee: json["employee"],
    spaServiceId: json["spa_service_id"],
    service: json["service"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "employee_id": employeeId,
    "employee": employee,
    "spa_service_id": spaServiceId,
    "service": service,
    "total": total,
  };
}

class Summary {
  int noOfServices;
  int services;
  int noOfProducts;
  int products;
  int noOfBills;
  int sale;
  String firstBillTime;
  String lastBillTime;

  Summary({
    required this.noOfServices,
    required this.services,
    required this.noOfProducts,
    required this.products,
    required this.noOfBills,
    required this.sale,
    required this.firstBillTime,
    required this.lastBillTime,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    noOfServices: json["no_of_services"],
    services: json["services"],
    noOfProducts: json["no_of_products"],
    products: json["products"],
    noOfBills: json["no_of_bills"],
    sale: json["sale"],
    firstBillTime: json["first_bill_time"],
    lastBillTime: json["last_bill_time"],
  );

  Map<String, dynamic> toJson() => {
    "no_of_services": noOfServices,
    "services": services,
    "no_of_products": noOfProducts,
    "products": products,
    "no_of_bills": noOfBills,
    "sale": sale,
    "first_bill_time": firstBillTime,
    "last_bill_time": lastBillTime,
  };
}
