import 'dart:convert';

import '../../Models/research_prices/research_prices.dart';

class ResearchModel {
  final int Code;
  final DateTime CreationDate;
  final String Observation;
  final List<ConcurrentsModel> Concurrents;
  final List? Products;

  ResearchModel({
    required this.Code,
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
          Code: element["Code"],
          CreationDate: DateTime.parse(element["CreationDate"]),
          Observation: element["Observation"],
          Concurrents: convertConcurrents(element["Concurrents"]),
          Products: element["Products"],
        ),
      );
    });
  }

  static List<ConcurrentsModel> convertConcurrents(List concurrents) {
    List<ConcurrentsModel> list = [];
    concurrents.forEach((element) {
      list.add(ConcurrentsModel.fromJson(element));
    });

    return list;
  }
}
