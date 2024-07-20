class ReplicationModel {
  final ReplicationNames replicationName;
  bool? selected = false;

  ReplicationModel._({
    required this.replicationName,
    required this.selected,
  });

  factory ReplicationModel.fromReplicationName(ReplicationNames replicationName) {
    return ReplicationModel._(
      replicationName: replicationName,
      selected: false,
    );
  }
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
