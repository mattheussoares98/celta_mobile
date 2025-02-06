class CustomerTelephoneModel {
  final String? AreaCode;
  final String? PhoneNumber;

  CustomerTelephoneModel({
    required this.AreaCode,
    required this.PhoneNumber,
  });

  factory CustomerTelephoneModel.fromJson(Map<String, dynamic> json) {
    return CustomerTelephoneModel(
      AreaCode: json['AreaCode'],
      PhoneNumber: json['PhoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'AreaCode': AreaCode,
        'PhoneNumber': PhoneNumber,
      };
}
