import 'dart:convert';

import '../../api/api.dart';
// import '../../models/research_prices/research_prices.dart';

class ResearchModel {
  final int Code;
  final DateTime CreationDate;
  final String Observation;
  final String? EnterpriseName;
  final String? Name;
  // final List<ConcurrentsModel> Concurrents;
  final List? Products;

  ResearchModel({
    required this.Code,
    this.EnterpriseName,
    this.Name,
    required this.CreationDate,
    required this.Observation,
    // required this.Concurrents,
    required this.Products,
  });

  static List<ResearchModel> convertResultToResearchModel() {
    List resultAsList =
        json.decode(SoapHelperResponseParameters.responseAsString);

    return resultAsList.map((e) => ResearchModel.fromJson(e)).toList();
  }

  factory ResearchModel.fromJson(Map<String, dynamic> json) {
    return ResearchModel(
      Code: json["Code"],
      CreationDate: DateTime.parse(json["CreationDate"]),
      Observation: json["Observation"],
      // Concurrents: ConcurrentsModel.convertToConcurrents(
      //   json["Concurrents"],
      // ),
      Products: json["Products"],
    );
  }
}
