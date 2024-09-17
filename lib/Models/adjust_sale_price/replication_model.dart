class ReplicationModel {
  final ReplicationNames replicationName;
  bool selected;

  ReplicationModel({
    required this.replicationName,
    this.selected = false,
  });
}

enum ReplicationNames { Packings, OperationalGrouping, Class, Grid }

extension ReplicationNamesExtension on ReplicationNames {
  String get description {
    switch (this) {
      case ReplicationNames.Packings:
        return "Embalagens";
      case ReplicationNames.OperationalGrouping:
        return "Agrupamento operacional";
      case ReplicationNames.Class:
        return "Classe";
      case ReplicationNames.Grid:
        return "Grade";
    }
  }
}
