// To parse this JSON data, do
//
//     final loginModel = loginModelFromMap(jsonString);

import 'dart:convert';

LoginModel loginModelFromMap(String str) => LoginModel.fromMap(json.decode(str));

String loginModelToMap(LoginModel data) => json.encode(data.toMap());

class LoginModel {
  bool? success;
  Data? data;
  String? message;

  LoginModel({
    this.success,
    this.data,
    this.message,
  });

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromMap(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data?.toMap(),
    "message": message,
  };
}

class Data {
  User? user;

  Data({
    this.user,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromMap(json["user"]),
  );

  Map<String, dynamic> toMap() => {
    "user": user?.toMap(),
  };
}

class User {
  int? id;
  int? branchId;
  String? name;
  String? code;
  String? place;
  String? mobile;
  String? email;
  int? pin;
  String? nationality;
  int? salary;
  int? hra;
  int? allowance;
  int? designationId;
  String? dob;
  String? doj;
  int? flag;
  String? token;
  String? loggedAt;
  String? adminFlag;
  String? openingDate;
  int? salesCount;
  String? password;

  User({
    this.id,
    this.branchId,
    this.name,
    this.code,
    this.place,
    this.mobile,
    this.email,
    this.pin,
    this.nationality,
    this.salary,
    this.hra,
    this.allowance,
    this.designationId,
    this.dob,
    this.doj,
    this.flag,
    this.token,
    this.loggedAt,
    this.adminFlag,
    this.openingDate,
    this.salesCount,
    this.password
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    branchId: json["branch_id"],
    name: json["name"],
    code: json["code"],
    place: json["place"],
    mobile: json["mobile"],
    email: json["email"],
    pin: json["pin"],
    nationality: json["nationality"],
    salary: json["salary"],
    hra: json["hra"],
    allowance: json["allowance"],
    designationId: json["designation_id"],
    dob: json["dob"],
    doj: json["doj"],
    flag: json["flag"],
    token: json["token"],
    loggedAt: json["logged_at"],
    adminFlag: json['admin_flag'],
    openingDate: json['opening_date'],
    salesCount: json['total_no_of_sales']
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "branch_id":branchId,
    "name": name,
    "code": code,
    "place": place,
    "mobile": mobile,
    "email": email,
    "pin": pin,
    "nationality": nationality,
    "salary": salary,
    "hra": hra,
    "allowance": allowance,
    "designation_id": designationId,
    "dob": dob,
    "doj": doj,
   // "flag": flag,
    "token": token,
    "logged_at": loggedAt,
    "admin_flag":adminFlag,
    "opening_date":openingDate,
    "total_no_of_sales":salesCount,
    "password":password

  };
}
