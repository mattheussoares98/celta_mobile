class SaleRequestConvenantsModel {
  int code;
  String personalizedCode;
  String name;
  bool selected;

  SaleRequestConvenantsModel({
    required this.code,
    required this.personalizedCode,
    required this.name,
    this.selected = false,
  });

  factory SaleRequestConvenantsModel.fromJson(Map<String, dynamic> json) {
    return SaleRequestConvenantsModel(
      code: json['Code'],
      personalizedCode: json['PersonalizedCode'],
      name: json['Name'],
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'PersonalizedCode': personalizedCode,
      'Name': name,
      'selected': selected,
    };
  }
}
