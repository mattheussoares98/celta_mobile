class ExpeditionControlModel {
  final int? EnterpriseCode;
  final int? ExpeditionControlCode;
  final int? OriginCode;
  final int? OriginType;
  final int? StepCode;
  final String? DocumentNumber;
  final String? StepName;
  final String? OriginTypeString;

  ExpeditionControlModel({
    required this.EnterpriseCode,
    required this.ExpeditionControlCode,
    required this.OriginCode,
    required this.OriginType,
    required this.StepCode,
    required this.DocumentNumber,
    required this.StepName,
    required this.OriginTypeString,
  });

  factory ExpeditionControlModel.fromJson(Map<String, dynamic> json) =>
      ExpeditionControlModel(
        EnterpriseCode: json["EnterpriseCode"],
        ExpeditionControlCode: json["ExpeditionControlCode"],
        OriginCode: json["OriginCode"],
        OriginType: json["OriginType"],
        StepCode: json["StepCode"],
        DocumentNumber: json["DocumentNumber"],
        StepName: json["StepName"],
        OriginTypeString: json["OriginTypeString"],
      );

  Map<String, dynamic> toJson() => {
        "EnterpriseCode": EnterpriseCode,
        "ExpeditionControlCode": ExpeditionControlCode,
        "OriginCode": OriginCode,
        "OriginType": OriginType,
        "StepCode": StepCode,
        "DocumentNumber": DocumentNumber,
        "StepName": StepName,
        "OriginTypeString": OriginTypeString,
      };
}
