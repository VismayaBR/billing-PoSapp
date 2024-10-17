// To parse this JSON data, do
//
//     final singleLocalSaleModel = singleLocalSaleModelFromMap(jsonString);

import 'dart:convert';

SingleLocalSaleModel singleLocalSaleModelFromMap(String str) => SingleLocalSaleModel.fromMap(json.decode(str));

String singleLocalSaleModelToMap(SingleLocalSaleModel data) => json.encode(data.toMap());

class SingleLocalSaleModel {
  String? date;
  String? customerName;
  String? customerMobile;
  String? total;
  String? discount;
  String? grandTotal;
  String? overTimeFlag;
  int? createdBy;
  int? updatedBy;
  int? id;
  String? type;
  int? syncedId;
  String? counterInvoice;
  int? branchId;
  List<SingleLocalSaleProduct>? products;
  List<SingleLocalSaleService>? services;
  List<SingleLocalSalePayment>? payments;

  SingleLocalSaleModel({
    this.date,
    this.customerName,
    this.customerMobile,
    this.total,
    this.discount,
    this.grandTotal,
    this.overTimeFlag,
    this.createdBy,
    this.updatedBy,
    this.id,
    this.type,
    this.syncedId,
    this.branchId,
    this.counterInvoice,
    this.products,
    this.services,
    this.payments,
  });

  factory SingleLocalSaleModel.fromMap(Map<String, dynamic> json) => SingleLocalSaleModel(
    date: json["date"],
    customerName: json["customerName"],
    customerMobile: json["customerMobile"],
    total: json["total"],
    discount: json["discount"],
    grandTotal: json["grandTotal"],
    overTimeFlag: json["overTimeFlag"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    id: json["id"],
    type: json['type'],
    syncedId: json['syncedId'],
    counterInvoice: json['counter_invoice_no'],
    branchId: json['branch_id'],
    products: json["products"] == null ? [] : List<SingleLocalSaleProduct>.from(json["products"]!.map((x) => SingleLocalSaleProduct.fromMap(x))),
    services: json["services"] == null ? [] : List<SingleLocalSaleService>.from(json["services"]!.map((x) => SingleLocalSaleService.fromMap(x))),
    payments: json["payments"] == null ? [] : List<SingleLocalSalePayment>.from(json["payments"]!.map((x) => SingleLocalSalePayment.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "date": date,
    "customerName": customerName,
    "customerMobile": customerMobile,
    "total": total,
    "discount": discount,
    "grandTotal": grandTotal,
    "overTimeFlag": overTimeFlag,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "id": id,
    "type":type,
    "syncedId":syncedId,
    "counter_invoice_no":counterInvoice,
    "branch_id":branchId,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toMap())),
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toMap())),
    "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toMap())),
  };
}

class SingleLocalSalePayment {
  int? saleId;
  int? id;
  String? paymentMethod;
  String? amount;

  SingleLocalSalePayment({
    this.saleId,
    this.id,
    this.paymentMethod,
    this.amount,
  });

  factory SingleLocalSalePayment.fromMap(Map<String, dynamic> json) => SingleLocalSalePayment(
    saleId: json["saleId"],
    id:json["id"],
    paymentMethod: json["paymentMethod"],
    amount: json["amount"],
  );

  Map<String, dynamic> toMap() => {
    "saleId": saleId,
    "id":id,
    "paymentMethod": paymentMethod,
    "amount": amount,
  };
}

class SingleLocalSaleProduct {
  int? saleId;
  int? productId;
  int? employeeId;
  String? price;
  int? editId;

  SingleLocalSaleProduct({
    this.saleId,
    this.productId,
    this.employeeId,
    this.price,
    this.editId,
  });

  factory SingleLocalSaleProduct.fromMap(Map<String, dynamic> json) => SingleLocalSaleProduct(
    saleId: json["saleId"],
    productId: json["productId"],
    employeeId: json["employeeId"],
    price: json["price"],
    editId: json['editId'],

  );

  Map<String, dynamic> toMap() => {
    "saleId": saleId,
    "productId": productId,
    "employeeId": employeeId,
    "price": price,
    "editId":editId
  };
}

class SingleLocalSaleService {
  int? saleId;
  int? serviceId;
  int? employeeId;
  String? price;
  int? editId;

  SingleLocalSaleService({
    this.saleId,
    this.serviceId,
    this.employeeId,
    this.price,
    this.editId,
  });

  factory SingleLocalSaleService.fromMap(Map<String, dynamic> json) => SingleLocalSaleService(
    saleId: json["saleId"],
    serviceId: json["serviceId"],
    employeeId: json["employeeId"],
    price: json["price"],
    editId: json['editId'],
  );

  Map<String, dynamic> toMap() => {
    "saleId": saleId,
    "serviceId": serviceId,
    "employeeId": employeeId,
    "price": price,
    "editId":editId
  };
}
