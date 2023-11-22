class BuyRequestEnterpriseSelectedModel {
  final bool IsPrincipal;
  final int EnterpriseCode;

  BuyRequestEnterpriseSelectedModel({
    required this.IsPrincipal,
    required this.EnterpriseCode,
  });

  Map toJson() => {
        "IsPrincipal": IsPrincipal,
        "EnterpriseCode": EnterpriseCode,
      };
}
