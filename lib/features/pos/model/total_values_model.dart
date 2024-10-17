// To parse this JSON data, do
//
//     final totalValuesModel = totalValuesModelFromMap(jsonString);

import 'dart:convert';

TotalValuesModel totalValuesModelFromMap(String str) => TotalValuesModel.fromMap(json.decode(str));

String totalValuesModelToMap(TotalValuesModel data) => json.encode(data.toMap());

class TotalValuesModel {
  bool? success;
  Data? data;
  String? message;

  TotalValuesModel({
    this.success,
    this.data,
    this.message,
  });

  factory TotalValuesModel.fromMap(Map<String, dynamic> json) => TotalValuesModel(
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
  int? sales;
  int? otBill;
  int? commission;
  int? otCommission;

  Data({
    this.sales,
    this.otBill,
    this.commission,
    this.otCommission,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    sales: json["sales"],
    otBill: json["ot_bill"],
    commission: json["commission"],
    otCommission: json["ot_commission"],
  );

  Map<String, dynamic> toMap() => {
    "sales": sales,
    "ot_bill": otBill,
    "commission": commission,
    "ot_commission": otCommission,
  };
}
