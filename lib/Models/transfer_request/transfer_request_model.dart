import '../../utils/utils.dart';

class TransferRequestModel {
  final int? Code;
  final int? OperationType;
  final int? UseWholePrice;
  final int? UnitValueType;
  final String? PersonalizedCode;
  final String? Name;
  final String? OperationTypeString;
  final String? UseWholePriceString;
  final String? UnitValueTypeString;
  final String? TransferUnitValueTypeString;
  final bool? AllowDiscount;
  final bool? AllowAlterCostOrSalePrice;

  TransferRequestModel({
    required this.Code,
    required this.OperationType,
    required this.UseWholePrice,
    required this.UnitValueType,
    required this.PersonalizedCode,
    required this.Name,
    required this.OperationTypeString,
    required this.UseWholePriceString,
    required this.UnitValueTypeString,
    required this.TransferUnitValueTypeString,
    required this.AllowDiscount,
    required this.AllowAlterCostOrSalePrice,
  });

  factory TransferRequestModel.fromJson(Map data) => TransferRequestModel(
        Code: data["Code"] == null ? null : data["Code"].toString().toInt(),
        OperationType: data["OperationType"] == null
            ? null
            : data["OperationType"].toString().toInt(),
        UseWholePrice: data["UseWholePrice"] == null
            ? null
            : data["UseWholePrice"].toString().toInt(),
        UnitValueType: data["UnitValueType"] == null
            ? null
            : data["UnitValueType"].toString().toInt(),
        PersonalizedCode: data["PersonalizedCode"],
        Name: data["Name"],
        OperationTypeString: data["OperationTypeString"],
        UseWholePriceString: data["UseWholePriceString"],
        UnitValueTypeString: data["UnitValueTypeString"],
        TransferUnitValueTypeString: data["TransferUnitValueTypeString"],
        AllowDiscount: data["AllowDiscount"] == true,
        AllowAlterCostOrSalePrice: data["AllowAlterCostOrSalePrice"] == true,
      );
}
