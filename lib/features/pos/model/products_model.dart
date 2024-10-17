// To parse this JSON data, do
//
//     final productsModel = productsModelFromMap(jsonString);

import 'dart:convert';

ProductsModel productsModelFromMap(String str) => ProductsModel.fromMap(json.decode(str));

String productsModelToMap(ProductsModel data) => json.encode(data.toMap());

class ProductsModel {
  bool? success;
  List<ProductDatum>? data;
  String? message;

  ProductsModel({
    this.success,
    this.data,
    this.message,
  });

  factory ProductsModel.fromMap(Map<String, dynamic> json) => ProductsModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<ProductDatum>.from(json["data"]!.map((x) => ProductDatum.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class ProductDatum {
  int? id;
  String? name;
  String? arabicName;
  int? groupId;
  String? group;
  int? price;
  int? time;
  String? description;
  int? servicedById;
  String? productType;
  int? editId;
  String? image;
  String? category_id;
  int? quantity;
  ProductDatum({
    this.id,
    this.name,
    this.arabicName,
    this.groupId,
    this.group,
    this.price,
    this.time,
    this.description,
    this.servicedById,
    this.image, 
    this.quantity,
    this.category_id,
  });

  factory ProductDatum.fromMap(Map<String, dynamic> json) => ProductDatum(
    id: json["id"],
    name: json["name"],
    arabicName: json["arabic_name"],
    groupId: json["group_id"],
    group: json["group"],
    price: json["price"],
    time: json["time"],
    description: json["description"],
    image: json["image_path"],
    quantity: json["quantity"],
    category_id: json["category_id"].toString()
  );



  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "arabic_name": arabicName,
    "group_id": groupId,
    "group": group,
    "price": price,
    "time": time,
    "description": description,
    "serviced_by":servicedById,
    "product_type":productType,
    "edit_id":editId,
    "image_path":image,
    "category_id":category_id
  };
  
}
