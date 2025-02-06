import 'customer.dart';

class CustomerRegisterBindedCovenantModel {
  final CustomerRegisterCovenantModel customerRegisterCovenantModel;
  final double limit;

  const CustomerRegisterBindedCovenantModel({
    required this.customerRegisterCovenantModel,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        "customerRegisterCovenantModel": customerRegisterCovenantModel,
        "limit": limit,
      };

  factory CustomerRegisterBindedCovenantModel.fromJson(Map data) =>
      CustomerRegisterBindedCovenantModel(
        customerRegisterCovenantModel: data["customerRegisterCovenantModel"],
        limit: data["limit"],
      );
}
