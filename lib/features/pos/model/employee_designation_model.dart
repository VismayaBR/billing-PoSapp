// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromMap(jsonString);

import 'dart:convert';

EmployeeDesignationModel employeeDesignationModelFromMap(String str) => EmployeeDesignationModel.fromMap(json.decode(str));

String employeeDesignationModelToMap(EmployeeDesignationModel data) => json.encode(data.toMap());

class EmployeeDesignationModel {
  bool? success;
  List<DesignationData>? data;
  String? message;

  EmployeeDesignationModel({
    this.success,
    this.data,
    this.message,
  });

  factory EmployeeDesignationModel.fromMap(Map<String, dynamic> json) => EmployeeDesignationModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<DesignationData>.from(json["data"]!.map((x) => DesignationData.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class DesignationData {
  int? id;
  String? name;

  DesignationData({
    this.id,
    this.name,
  });

  factory DesignationData.fromMap(Map<String, dynamic> json) => DesignationData(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}
