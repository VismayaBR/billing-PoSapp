// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromMap(jsonString);

import 'dart:convert';

PaymentMethodModel paymentModelFromMap(String str) => PaymentMethodModel.fromMap(json.decode(str));

String paymentModelToMap(PaymentMethodModel data) => json.encode(data.toMap());

class PaymentMethodModel {
  bool? success;
  List<PaymentDatum>? data;
  String? message;

  PaymentMethodModel({
    this.success,
    this.data,
    this.message,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> json) => PaymentMethodModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<PaymentDatum>.from(json["data"]!.map((x) => PaymentDatum.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class PaymentDatum {
  int? id;
  String? name;

  PaymentDatum({
    this.id,
    this.name,
  });

  factory PaymentDatum.fromMap(Map<String, dynamic> json) => PaymentDatum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}
