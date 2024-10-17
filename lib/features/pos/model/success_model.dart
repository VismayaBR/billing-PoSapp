// To parse this JSON data, do
//
//     final successModel = successModelFromMap(jsonString);

import 'dart:convert';

SuccessModel successModelFromMap(String str) => SuccessModel.fromMap(json.decode(str));

String successModelToMap(SuccessModel data) => json.encode(data.toMap());

class SuccessModel {
  bool? success;
  List<dynamic>? data;
  String? message;

  SuccessModel({
    this.success,
    this.data,
    this.message,
  });

  factory SuccessModel.fromMap(Map<String, dynamic> json) => SuccessModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    "message": message,
  };
}
