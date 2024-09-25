class ConfigurationsModel {
  bool showOnlyConfigurationOfSearchProducts;
  String title;
  bool value;
  Function updateValue;
  String subtitle;

  ConfigurationsModel({
    required this.showOnlyConfigurationOfSearchProducts,
    required this.title,
    required this.value,
    required this.updateValue,
    required this.subtitle,
  });
}
