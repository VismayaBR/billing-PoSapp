// To parse this JSON data, do
//
//     final customerFetchByMobileModel = customerFetchByMobileModelFromMap(jsonString);

import 'dart:convert';

CustomerFetchByMobileModel customerFetchByMobileModelFromMap(String str) => CustomerFetchByMobileModel.fromMap(json.decode(str));

String customerFetchByMobileModelToMap(CustomerFetchByMobileModel data) => json.encode(data.toMap());

class CustomerFetchByMobileModel {
  bool? success;
  Data? data;
  String? message;

  CustomerFetchByMobileModel({
    this.success,
    this.data,
    this.message,
  });

  factory CustomerFetchByMobileModel.fromMap(Map<String, dynamic> json) => CustomerFetchByMobileModel(
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
  int? id;
  String? name;
  String? mobile;

  Data({
    this.id,
    this.name,
    this.mobile,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "mobile": mobile,
  };
}
