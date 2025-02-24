class TransferRequestEnterpriseModel {
  final int? Code;
  final int? SaleRequestTypeCode;
  final String? PersonalizedCode;
  final String? Name;
  final String? FantasizesName;
  final String? CnpjNumber;
  final String? InscriptionNumber;

  TransferRequestEnterpriseModel({
    required this.Code,
    required this.SaleRequestTypeCode,
    required this.PersonalizedCode,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjNumber,
    required this.InscriptionNumber,
  });

  factory TransferRequestEnterpriseModel.fromJson(Map data) =>
      TransferRequestEnterpriseModel(
        Code: data["Code"],
        SaleRequestTypeCode: data["SaleRequestTypeCode"],
        PersonalizedCode: data["PersonalizedCode"],
        Name: data["Name"],
        FantasizesName: data["FantasizesName"],
        CnpjNumber: data["CnpjNumber"],
        InscriptionNumber: data["InscriptionNumber"],
      );
}
