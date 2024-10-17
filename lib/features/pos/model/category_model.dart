// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromMap(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromMap(String str) => CategoryModel.fromMap(json.decode(str));

String categoryModelToMap(CategoryModel data) => json.encode(data.toMap());

class CategoryModel {
  bool? success;
  List<Datum>? data;
  String? message;

  CategoryModel({
    this.success,
    this.data,
    this.message,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class Datum {
  int? id;
  String? name;
  String? arabicName;

  Datum({
    this.id,
    this.name,
    this.arabicName,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    arabicName: json["arabic_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "arabic_name": arabicName,
  };
}
