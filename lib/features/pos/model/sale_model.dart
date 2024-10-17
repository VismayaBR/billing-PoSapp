// To parse this JSON data, do
//
//     final saleModel = saleModelFromMap(jsonString);

import 'dart:convert';

SaleModel saleModelFromMap(String str) => SaleModel.fromMap(json.decode(str));

String saleModelToMap(SaleModel data) => json.encode(data.toMap());

class SaleModel {
  List<SaleDatum>? data;

  SaleModel({
    this.data,
  });

  factory SaleModel.fromMap(Map<String, dynamic> json) => SaleModel(
    data: json["data"] == null ? [] : List<SaleDatum>.from(json["data"]!.map((x) => SaleDatum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class SaleDatum {
  String? date;
  String? customerName;
  String? customerMobile;
  String? total;
  String? discount;
  String? grandTotal;
  String? overTimeFlag;
  String? createdBy;
  String? updatedBy;
  String? id;
  String? counterInvoice;
  int? branchId;
  List<SaleProduct>? products;
  List<SaleService>? services;
  List<SalePayment>? payments;

  SaleDatum({
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
    this.counterInvoice,
    this.branchId,
    this.products,
    this.services,
    this.payments,
  });

  factory SaleDatum.fromMap(Map<String, dynamic> json) => SaleDatum(
    date: json["date"],
    customerName: json["customer_name"],
    customerMobile: json["customer_mobile"],
    total: json["total"],
    discount: json["discount"],
    grandTotal: json["grand_total"],
    overTimeFlag: json["over_time_flag"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    id: json['id'],
    counterInvoice: json['counter_invoice_no'],
    branchId: json['branch_id'],
    products: json["products"] == null ? [] : List<SaleProduct>.from(json["products"]!.map((x) => SaleProduct.fromMap(x))),
    services: json["services"] == null ? [] : List<SaleService>.from(json["services"]!.map((x) => SaleService.fromMap(x))),
    payments: json["payments"] == null ? [] : List<SalePayment>.from(json["payments"]!.map((x) => SalePayment.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "date": date,
    "customer_name": customerName,
    "customer_mobile": customerMobile,
    "total": total,
    "discount": discount,
    "grand_total": grandTotal,
    "over_time_flag": overTimeFlag,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "id":id,
    "counter_invoice_no":counterInvoice,
    "branch_id":branchId,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toMap())),
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toMap())),
    "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toMap())),
  };
}

class SalePayment {

  int? method;
  int? amount;

  SalePayment({
    this.method,
    this.amount,
  });

  factory SalePayment.fromMap(Map<String, dynamic> json) => SalePayment(
    method: json["method"],
    amount: json["amount"],
  );

  Map<String, dynamic> toMap() => {
    "method": method,
    "amount": amount,
  };
}

class SaleProduct {
  int? productId;
  int? employeeId;
  int? price;
  int? id;

  SaleProduct({
    this.productId,
    this.employeeId,
    this.price,
    this.id
  });

  factory SaleProduct.fromMap(Map<String, dynamic> json) => SaleProduct(
    productId: json["product_id"],
    employeeId: json["employee_id"],
    price: json["price"],
    id:json["id"]
  );

  Map<String, dynamic> toMap() => {
    "product_id": productId,
    "employee_id": employeeId,
    "price": price,
    "id":id
  };
}

class SaleService {
  int? serviceId;
  int? employeeId;
  int? price;
  int? id;

  SaleService({
    this.serviceId,
    this.employeeId,
    this.price,
    this.id
  });

  factory SaleService.fromMap(Map<String, dynamic> json) => SaleService(
    serviceId: json["service_id"],
    employeeId: json["employee_id"],
    price: json["price"],
    id:json["id"]
  );

  Map<String, dynamic> toMap() => {
    "service_id": serviceId,
    "employee_id": employeeId,
    "price": price,
    "id":id
  };
}
