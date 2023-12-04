class BuyRequestEnterpriseSelectedModel {
  bool IsPrincipal;
  final int EnterpriseCode;

  BuyRequestEnterpriseSelectedModel({
    required this.IsPrincipal,
    required this.EnterpriseCode,
  });

  Map toJson() => {
        "IsPrincipal": IsPrincipal,
        "EnterpriseCode": EnterpriseCode,
      };

  static BuyRequestEnterpriseSelectedModel fromJson(Map json) =>
      BuyRequestEnterpriseSelectedModel(
        IsPrincipal: json["IsPrincipal"],
        EnterpriseCode: json["EnterpriseCode"],
      );
}
