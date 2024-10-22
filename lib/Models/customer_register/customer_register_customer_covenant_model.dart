class CustomerRegisterCustomerCovenantModel {
  final int Code;
  // final String Matriculate; //não usa
  final double LimitOfPurchase;

  CustomerRegisterCustomerCovenantModel({
    required this.Code,
    // required this.Matriculate,
    required this.LimitOfPurchase,
  });

  Map<String, dynamic> toJson() => {
        "Covenant": {"Code": Code},
        // "Matriculate": Matriculate,
        "LimitOfPurchase": LimitOfPurchase
      };
}
