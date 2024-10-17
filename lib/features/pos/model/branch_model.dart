// To parse this JSON data, do
//
//     final branchesModel = branchesModelFromMap(jsonString);

import 'dart:convert';

BranchesModel branchesModelFromMap(String str) => BranchesModel.fromMap(json.decode(str));

String branchesModelToMap(BranchesModel data) => json.encode(data.toMap());

class BranchesModel {
  bool success;
  List<BranchData> data;
  String message;

  BranchesModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory BranchesModel.fromMap(Map<String, dynamic> json) => BranchesModel(
    success: json["success"],
    data: List<BranchData>.from(json["data"].map((x) => BranchData.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "message": message,
  };
}

class BranchData {
  String name;
  int id;

  BranchData({
    required this.name,
    required this.id,
  });

  factory BranchData.fromMap(Map<String, dynamic> json) => BranchData(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "id": id,
  };
}
