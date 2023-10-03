class ConfigurationsModel {
  bool isConfigurationOfSearch;
  String title;
  bool value;
  Function changeValue;
  String subtitle;

  ConfigurationsModel({
    required this.isConfigurationOfSearch,
    required this.title,
    required this.value,
    required this.changeValue,
    required this.subtitle,
  });
}
