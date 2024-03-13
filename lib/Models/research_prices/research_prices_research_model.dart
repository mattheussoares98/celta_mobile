import 'dart:convert';

import 'package:celta_inventario/models/research_prices/research_prices.dart';

import '../../api/api.dart';
// import '../../models/research_prices/research_prices.dart';

class ResearchPricesResearchModel {
  final int Code;
  final DateTime CreationDate;
  final String Observation;
  final String EnterpriseName;
  final int EnterpriseCode;
  final String? Name;
  final bool RestrictProducts;
  final bool IsAssociatingConcurrents;
  final List<ResearchPricesConcurrentsModel> Concurrents;
  final List? Products;

  ResearchPricesResearchModel({
    required this.Code,
    required this.IsAssociatingConcurrents,
    required this.EnterpriseName,
    required this.EnterpriseCode,
    this.Name,
    required this.CreationDate,
    required this.Observation,
    required this.Concurrents,
    required this.Products,
    required this.RestrictProducts,
  });

  static List<ResearchPricesResearchModel> convertResultToResearchModel() {
    List resultAsList =
        json.decode(SoapHelperResponseParameters.responseAsString);

    return resultAsList
        .map((e) => ResearchPricesResearchModel.fromJson(e))
        .toList();
  }

  factory ResearchPricesResearchModel.fromJson(Map<String, dynamic> json) {
    return ResearchPricesResearchModel(
      Code: json["Code"],
      IsAssociatingConcurrents: json["IsAssociatingConcurrents"],
      EnterpriseCode: json["EnterpriseCode"],
      RestrictProducts: json["RestrictProducts"],
      EnterpriseName: json["EnterpriseName"],
      CreationDate: DateTime.parse(json["CreationDate"]),
      Observation: json["Observation"],
      Name: json["Name"],
      Concurrents: ResearchPricesConcurrentsModel.convertToConcurrents(
        json["Concurrents"],
      ),
      Products: json["Products"],
    );
  }
}
