// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromMap(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromMap(String str) => PaymentModel.fromMap(json.decode(str));

String paymentModelToMap(PaymentModel data) => json.encode(data.toMap());

class PaymentModel {
  int? id;
  String? type;
  String? amount;

  PaymentModel({
    this.id,
    this.type,
    this.amount,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> json) => PaymentModel(
    id:json["id"],
    type: json["type"],
    amount: json["amount"],
  );

  Map<String, dynamic> toMap() => {
    "id":id,
    "type": type,
    "amount": amount,
  };
}