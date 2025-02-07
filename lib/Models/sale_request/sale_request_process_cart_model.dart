import '../../utils/utils.dart';
import '../models.dart';

class SaleRequestProcessCartModel {
  final String? crossId;
  final int? EnterpriseCode;
  final int? RequestTypeCode;
  final int? SellerCode;
  final int? CovenantCode;
  final int? CustomerCode;
  final String? Instructions;
  final String? Observations;
  final List<SaleRequestProductProcessCartModel>? Products;

  SaleRequestProcessCartModel({
    required this.crossId,
    required this.EnterpriseCode,
    required this.RequestTypeCode,
    required this.SellerCode,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.Products,
    required this.Instructions,
    required this.Observations,
  });

  factory SaleRequestProcessCartModel.fromJson(Map data) =>
      SaleRequestProcessCartModel(
        crossId: UserData.crossIdentity,
        EnterpriseCode: data["EnterpriseCode"],
        RequestTypeCode: data["RequestTypeCode"],
        SellerCode: data["SellerCode"],
        CovenantCode: data["CovenantCode"],
        CustomerCode: data["CustomerCode"],
        Instructions: data["Instructions"],
        Observations: data["Observations"],
        Products: data["Products"] != null
            ? (data["Products"] as List)
                .map<SaleRequestProductProcessCartModel>(
                  (e) => SaleRequestProductProcessCartModel.fromJson(e),
                )
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "crossId": crossId,
        "EnterpriseCode": EnterpriseCode,
        "RequestTypeCode": RequestTypeCode,
        "SellerCode": SellerCode,
        "CovenantCode": CovenantCode,
        "CustomerCode": CustomerCode,
        "Instructions": Instructions,
        "Observations": Observations,
        "Products": Products?.map((e) => e.toJson()).toList(),
      };
}
