class SaleRequestCovenantsModel {
  int code;
  String personalizedCode;
  String name;
  bool selected;

  SaleRequestCovenantsModel({
    required this.code,
    required this.personalizedCode,
    required this.name,
    this.selected = false,
  });

  factory SaleRequestCovenantsModel.fromJson(Map<String, dynamic> json) {
    return SaleRequestCovenantsModel(
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
