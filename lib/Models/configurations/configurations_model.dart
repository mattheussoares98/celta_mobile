class ConfigurationsModel {
  ConfigurationType configurationType;
  String title;
  bool value;
  Function updateValue;
  String subtitle;

  ConfigurationsModel({
    required this.configurationType,
    required this.title,
    required this.value,
    required this.updateValue,
    required this.subtitle,
  });
}

enum ConfigurationType {
  autoScan,
  legacyCode,
  personalizedCode,
  personalizedCodeCustomer,
}
