class ConfigurationsModel {
  bool isConfigurationOfSearch;
  String title;
  bool value;
  Function changeValue;
  String subtitle;
  bool showInWeb;

  ConfigurationsModel({
    required this.isConfigurationOfSearch,
    required this.title,
    required this.value,
    required this.changeValue,
    required this.subtitle,
    required this.showInWeb,
  });
}
