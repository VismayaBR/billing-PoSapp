// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromMap(jsonString);

import 'dart:convert';

import 'package:saloon_pos/features/account/model/login_model.dart';


AddEmployeeResponse addEmployeeModelFromMap(String str) => AddEmployeeResponse.fromMap(json.decode(str));

String addEmployeeModelToMap(AddEmployeeResponse data) => json.encode(data.toMap());

class AddEmployeeResponse {
  bool? success;
  User? data;
  String? message;

  AddEmployeeResponse({
    this.success,
    this.data,
    this.message,
  });

  factory AddEmployeeResponse.fromMap(Map<String, dynamic> json) => AddEmployeeResponse(
    success: json["success"],
    data: json["data"] == null ? null :  User.fromMap(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data,
    "message": message,
  };
}

