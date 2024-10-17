// To parse this JSON data, do
//
//     final productsModel = productsModelFromMap(jsonString);

import 'dart:convert';

ServiceResponseModel serviceModelFromMap(String str) => ServiceResponseModel.fromMap(json.decode(str));

String serviceModelToMap(ServiceResponseModel data) => json.encode(data.toMap());

class ServiceResponseModel {
  bool? success;
  ServiceData? data;
  String? message;

  ServiceResponseModel({
    this.success,
    this.data,
    this.message,
  });

  factory ServiceResponseModel.fromMap(Map<String, dynamic> json) => ServiceResponseModel(
    success: json["success"],
    data: json["data"] == null ? null : ServiceData.fromMap(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data,
    "message": message,
  };
}

class ServiceData {
  int? id;
  String? name;
  String? arabicName;
  int? groupId;
  int? price;
  int? time;
  String? description;
  String? type;
  String? image;
  int? branchId;

  ServiceData({
    this.id,
    this.name,
    this.arabicName,
    this.groupId,
    this.price,
    this.time,
    this.description,
    this.type,
    this.image,
    this.branchId
  });

  factory ServiceData.fromMap(Map<String, dynamic> json) => ServiceData(
    id: json["id"],
    name: json["name"],
    arabicName: json["arabic_name"],
    groupId: json["group_id"],
    price: json["price"],
    time: json["time"],
    description: json["description"],
    type: json["type"],
    image: json["image_path"],
    branchId: json["branch_id"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "arabic_name": arabicName,
    "spa_service_group_id": groupId,
    "price": price,
    "time": time,
    "description": description,
    "type": type,
    "image_path":image,
    "branch_id":branchId
  };
}
