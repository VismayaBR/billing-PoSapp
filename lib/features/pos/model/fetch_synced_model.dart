// To parse this JSON data, do
//
//     final fetchedSyncedModel = fetchedSyncedModelFromMap(jsonString);

import 'dart:convert';

FetchedSyncedModel fetchedSyncedModelFromMap(String str) => FetchedSyncedModel.fromMap(json.decode(str));

String fetchedSyncedModelToMap(FetchedSyncedModel data) => json.encode(data.toMap());

class FetchedSyncedModel {
  bool? success;
  List<FetchedSyncedDatum>? data;
  String? message;

  FetchedSyncedModel({
    this.success,
    this.data,
    this.message,
  });

  factory FetchedSyncedModel.fromMap(Map<String, dynamic> json) => FetchedSyncedModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<FetchedSyncedDatum>.from(json["data"]!.map((x) => FetchedSyncedDatum.fromMap(x))),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "message": message,
  };
}

class FetchedSyncedDatum {
  int? id;
  int? customerId;
  String? customer;
  String? customerName;
  String? customerMobile;
  String? invoiceNo;
  String? date;
  dynamic itemDiscount;
  int? total;
  int? discount;
  int? grandTotal;
  dynamic paid;
  int? balance;
  dynamic tip;
  dynamic receivedAmount;
  int? overTimeFlag;
  int? datumCreatedBy;
  String? createdBy;
  int? datumUpdatedBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  List<Product>? products;
  List<Service>? services;
  List<Payment>? payments;

  FetchedSyncedDatum({
    this.id,
    this.customerId,
    this.customer,
    this.customerName,
    this.customerMobile,
    this.invoiceNo,
    this.date,
    this.itemDiscount,
    this.total,
    this.discount,
    this.grandTotal,
    this.paid,
    this.balance,
    this.tip,
    this.receivedAmount,
    this.overTimeFlag,
    this.datumCreatedBy,
    this.createdBy,
    this.datumUpdatedBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.products,
    this.services,
    this.payments,
  });

  factory FetchedSyncedDatum.fromMap(Map<String, dynamic> json) => FetchedSyncedDatum(
    id: json["id"],
    customerId: json["customer_id"],
    customer: json["customer"],
    customerName: json["customer_name"],
    customerMobile: json["customer_mobile"],
    invoiceNo: json["invoice_no"],
    date: json["date"],
    itemDiscount: json["item_discount"],
    total: json["total"],
    discount: json["discount"],
    grandTotal: json["grand_total"],
    paid: json["paid"],
    balance: json["balance"],
    tip: json["tip"],
    receivedAmount: json["received_amount"],
    overTimeFlag: json["over_time_flag"],
    datumCreatedBy: json["created_by"],
    createdBy: json["createdBy"],
    datumUpdatedBy: json["updated_by"],
    updatedBy: json["updatedBy"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromMap(x))),
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromMap(x))),
    payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"]!.map((x) => Payment.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "customer_id": customerId,
    "customer": customer,
    "customer_name": customerName,
    "customer_mobile": customerMobile,
    "invoice_no": invoiceNo,
    "date": date,
    "item_discount": itemDiscount,
    "total": total,
    "discount": discount,
    "grand_total": grandTotal,
    "paid": paid,
    "balance": balance,
    "tip": tip,
    "received_amount": receivedAmount,
    "over_time_flag": overTimeFlag,
    "created_by": datumCreatedBy,
    "createdBy": createdBy,
    "updated_by": datumUpdatedBy,
    "updatedBy": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toMap())),
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toMap())),
    "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toMap())),
  };
}

class Payment {
  int? id;
  int? methodId;
  String? methodName;
  int? amount;

  Payment({
    this.id,
    this.methodId,
    this.methodName,
    this.amount,
  });

  factory Payment.fromMap(Map<String, dynamic> json) => Payment(
    id: json["id"],
    methodId: json["method_id"],
    methodName: json["method_name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "method_id": methodId,
    "method_name": methodName,
    "amount": amount,
  };
}

class Product {
  int? id;
  int? employeeId;
  String? employeeName;
  int? productId;
  String? productName;
  int? price;
  int? quantity;
  int? total;

  Product({
    this.id,
    this.employeeId,
    this.employeeName,
    this.productId,
    this.productName,
    this.price,
    this.quantity,
    this.total,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],
    employeeId: json["employee_id"],
    employeeName: json["employee_name"],
    productId: json["product_id"],
    productName: json["product_name"],
    price: json["price"],
    quantity: json["quantity"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "employee_id": employeeId,
    "employee_name": employeeName,
    "product_id": productId,
    "product_name": productName,
    "price": price,
    "quantity": quantity,
    "total": total,
  };
}

class Service {
  int? id;
  int? employeeId;
  String? employeeName;
  int? serviceId;
  String? serviceName;
  int? price;
  int? quantity;
  int? total;

  Service({
    this.id,
    this.employeeId,
    this.employeeName,
    this.serviceId,
    this.serviceName,
    this.price,
    this.quantity,
    this.total,
  });

  factory Service.fromMap(Map<String, dynamic> json) => Service(
    id: json["id"],
    employeeId: json["employee_id"],
    employeeName: json["employee_name"],
    serviceId: json["service_id"],
    serviceName: json["service_name"],
    price: json["price"],
    quantity: json["quantity"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "employee_id": employeeId,
    "employee_name": employeeName,
    "service_id": serviceId,
    "service_name": serviceName,
    "price": price,
    "quantity": quantity,
    "total": total,
  };
}
