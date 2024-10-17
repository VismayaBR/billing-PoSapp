import 'dart:convert';


LogoModel logoModelFromMap(String str) => LogoModel.fromMap(json.decode(str));

String logoModelToMap(LogoModel data) => json.encode(data.toMap());

class LogoModel {
  bool? success;
  Data? data;
  String? message;

  LogoModel({
    this.success,
    this.data,
    this.message,
  });

  factory LogoModel.fromMap(Map<String, dynamic> json) => LogoModel(
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
  String? companyLogo;
  String? printLogo;

  Data({
    this.companyLogo,
    this.printLogo,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    companyLogo: json["company_logo"],
    printLogo: json["print_logo"],
  );

  Map<String, dynamic> toMap() => {
    "company_logo": companyLogo,
    "print_logo": printLogo,
  };
}
