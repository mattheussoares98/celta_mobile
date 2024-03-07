import 'dart:convert';

import '../../api/api.dart';
// import '../../models/research_prices/research_prices.dart';

class ResearchPricesResearchModel {
  final int Code;
  final DateTime CreationDate;
  final String Observation;
  final String? EnterpriseName;
  final String? Name;
  // final List<ConcurrentsModel> Concurrents;
  final List? Products;

  ResearchPricesResearchModel({
    required this.Code,
    this.EnterpriseName,
    this.Name,
    required this.CreationDate,
    required this.Observation,
    // required this.Concurrents,
    required this.Products,
  });

  static List<ResearchPricesResearchModel> convertResultToResearchModel() {
    List resultAsList =
        json.decode(SoapHelperResponseParameters.responseAsString);

    return resultAsList.map((e) => ResearchPricesResearchModel.fromJson(e)).toList();
  }

  factory ResearchPricesResearchModel.fromJson(Map<String, dynamic> json) {
    return ResearchPricesResearchModel(
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
