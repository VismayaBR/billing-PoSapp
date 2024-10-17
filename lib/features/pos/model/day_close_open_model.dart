// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromMap(jsonString);

import 'dart:convert';

DayCloseOpenModel DayCloseOpenModelFromMap(String str) => DayCloseOpenModel.fromMap(json.decode(str));

String DayCloseOpenModelToMap(DayCloseOpenModel data) => json.encode(data.toMap());

class DayCloseOpenModel {
  bool? success;
  DayData? data;
  String? message;

  DayCloseOpenModel({
    this.success,
     this.data,
    this.message,
  });

  factory DayCloseOpenModel.fromMap(Map<String, dynamic> json) => DayCloseOpenModel(
    success: json["success"],
    data: json["data"] == null ? null : DayData.fromMap(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data,
    "message": message,
  };
}

class DayData {
  String? date;
  String? status;

  DayData({
    this.date,
    this.status,
  });

  factory DayData.fromMap(Map<String, dynamic> json) => DayData(
    date: json["date"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "date": date,
    "status": status,
  };
}
