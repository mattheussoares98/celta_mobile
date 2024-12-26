import '../../utils/utils.dart';
import '../models.dart';

class SaleRequestProcessCartModel {
  final String? crossId;
  final int? EnterpriseCode;
  final int? RequestTypeCode;
  final int? SellerCode;
  final int? CovenantCode;
  final int? CustomerCode;
  final List<SaleRequestProductProcessCartModel>? Products;

  SaleRequestProcessCartModel({
    required this.crossId,
    required this.EnterpriseCode,
    required this.RequestTypeCode,
    required this.SellerCode,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.Products,
  });

  factory SaleRequestProcessCartModel.fromJson(Map data) =>
      SaleRequestProcessCartModel(
        crossId: UserData.crossIdentity,
        EnterpriseCode: data["EnterpriseCode"],
        RequestTypeCode: data["RequestTypeCode"],
        SellerCode: data["SellerCode"],
        CovenantCode: data["CovenantCode"],
        CustomerCode: data["CustomerCode"],
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
        "Products": Products?.map((e) => e.toJson()).toList(),
      };
}
