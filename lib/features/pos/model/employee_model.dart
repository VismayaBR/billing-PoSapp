// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromMap(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromMap(String str) => EmployeeModel.fromMap(json.decode(str));

String employeeModelToMap(EmployeeModel data) => json.encode(data.toMap());

class EmployeeModel {
  bool? success;
  List<EmployeeDatum>? data;
  String? message;

  EmployeeModel({
    this.success,
    this.data,
    this.message,
  });

  factory EmployeeModel.fromMap(Map<String, dynamic> json) => EmployeeModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<EmployeeDatum>.from(json["data"]!.map((x) => EmployeeDatum.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class EmployeeDatum {
  int? id;
  String? name;

  EmployeeDatum({
    this.id,
    this.name,
  });

  factory EmployeeDatum.fromMap(Map<String, dynamic> json) => EmployeeDatum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}
