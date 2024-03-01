import 'dart:convert';

import '../../models/research_prices/research_prices.dart';

class ResearchModel {
  final int Code;
  final DateTime CreationDate;
  final String Observation;
  final String? EnterpriseName;
  final String? Name;
  final List<ConcurrentsModel> Concurrents;
  final List? Products;

  ResearchModel({
    required this.Code,
    this.EnterpriseName,
    this.Name,
    required this.CreationDate,
    required this.Observation,
    required this.Concurrents,
    required this.Products,
  });

  static resultAsStringToResearchModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    resultAsList.forEach((element) {
      listToAdd.add(
        ResearchModel(
          EnterpriseName: element["EnterpriseName"],
          Name: element["Name"],
          Code: element["Code"],
          CreationDate: DateTime.parse(element["CreationDate"]),
          Observation: element["Observation"],
          Concurrents: ConcurrentsModel.convertToConcurrents(element["Concurrents"]),
          Products: element["Products"],
        ),
      );
    });
  }


}
