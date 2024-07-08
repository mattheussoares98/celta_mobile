class ConfigurationsModel {
  bool isConfigurationOfSearch;
  String title;
  bool value;
  Function updateValue;
  String subtitle;

  ConfigurationsModel({
    required this.isConfigurationOfSearch,
    required this.title,
    required this.value,
    required this.updateValue,
    required this.subtitle,
  });
}
