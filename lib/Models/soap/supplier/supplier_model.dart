class SupplierModel {
  final int Code;
  final String Name;
  final String FantasizesName;
  final String CnpjCpfNumber;
  final String InscriptionRgNumber;
  final String SupplierType;
  final String SupplierRegimeType;
  final String Date;
  final List? Emails;
  final List? Telephones;
  final List? Addresses;

  SupplierModel({
    required this.Code,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjCpfNumber,
    required this.InscriptionRgNumber,
    required this.SupplierType,
    required this.SupplierRegimeType,
    required this.Date,
    this.Emails,
    this.Telephones,
    this.Addresses,
  });

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "Name": Name,
        "FantasizesName": FantasizesName,
        "CnpjCpfNumber": CnpjCpfNumber,
        "InscriptionRgNumber": InscriptionRgNumber,
        "SupplierType": SupplierType,
        "SupplierRegimeType": SupplierRegimeType,
        "Date": Date,
        "Emails": Emails,
        "Telephones": Telephones,
        "Addresses": Addresses,
      };

  factory SupplierModel.fromJson(Map json) => SupplierModel(
        Code: json["Code"],
        Name: json["Name"],
        FantasizesName: json["FantasizesName"],
        CnpjCpfNumber: json["CnpjCpfNumber"],
        InscriptionRgNumber: json["InscriptionRgNumber"],
        SupplierType: json["SupplierType"],
        SupplierRegimeType: json["SupplierRegimeType"],
        Date: json["Date"],
      );
}
