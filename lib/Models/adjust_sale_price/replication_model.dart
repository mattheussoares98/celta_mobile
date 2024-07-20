class ReplicationModel {
  final ReplicationNames replicationName;
  bool selected;

  ReplicationModel({
    required this.replicationName,
    this.selected = false,
  });
}

enum ReplicationNames {
  Embalagens,
  AgrupamentoOperacional,
  Classe,
  Grade,
}

extension ReplicationNamesExtension on ReplicationNames {
  String get description {
    switch (this) {
      case ReplicationNames.Embalagens:
        return "Embalagens";
      case ReplicationNames.AgrupamentoOperacional:
        return "Agrupamento operacional";
      case ReplicationNames.Classe:
        return "Classe";
      case ReplicationNames.Grade:
        return "Grade";
    }
  }
}
