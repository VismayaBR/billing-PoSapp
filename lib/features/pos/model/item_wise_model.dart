// To parse this JSON data, do
//
//     final itemWiseModel = itemWiseModelFromMap(jsonString);

import 'dart:convert';

ItemWiseModel itemWiseModelFromMap(String str) => ItemWiseModel.fromMap(json.decode(str));

String itemWiseModelToMap(ItemWiseModel data) => json.encode(data.toMap());

class ItemWiseModel {
  bool? success;
  List<ItemWiseReportDatum>? data;
  String? message;

  ItemWiseModel({
    this.success,
    this.data,
    this.message,
  });

  factory ItemWiseModel.fromMap(Map<String, dynamic> json) => ItemWiseModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<ItemWiseReportDatum>.from(json["data"]!.map((x) => ItemWiseReportDatum.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class ItemWiseReportDatum {
  int? id;
  int? employeeId;
  String? employeeName;
  int? serviceId;
  String? serviceName;
  int? price;
  int? quantity;
  int? total;
  int? commissionPercentage;
  int? otCommissionPercentage;
  int? commission;
  int? otCommission;

  ItemWiseReportDatum({
    this.id,
    this.employeeId,
    this.employeeName,
    this.serviceId,
    this.serviceName,
    this.price,
    this.quantity,
    this.total,
    this.commissionPercentage,
    this.otCommissionPercentage,
    this.commission,
    this.otCommission,
  });

  factory ItemWiseReportDatum.fromMap(Map<String, dynamic> json) => ItemWiseReportDatum(
    id: json["id"],
    employeeId: json["employee_id"],
    employeeName: json["employee_name"],
    serviceId: json["service_id"],
    serviceName: json["service_name"],
    price: json["price"],
    quantity: json["quantity"],
    total: json["total"],
    commissionPercentage: json["commission_percentage"],
    otCommissionPercentage: json["ot_commission_percentage"],
    commission: json["commission"],
    otCommission: json["ot_commission"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "employee_id": employeeId,
    "employee_name": employeeName,
    "service_id": serviceId,
    "service_name": serviceName,
    "price": price,
    "quantity": quantity,
    "total": total,
    "commission_percentage": commissionPercentage,
    "ot_commission_percentage": otCommissionPercentage,
    "commission": commission,
    "ot_commission": otCommission,
  };
}
