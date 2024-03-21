import 'dart:convert';

import '../../api/api.dart';
import '../../models/address/address.dart';

class ResearchPricesConcurrentsModel {
  // final int ResearchOfPriceCode;
  final int ConcurrentCode;
  String? Name;
  String? Observation;
  AddressModel? Address;

  ResearchPricesConcurrentsModel({
    // required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.Name,
    required this.Observation,
    required this.Address,
  });

  factory ResearchPricesConcurrentsModel.fromJson(Map<String, dynamic> json) {
    return ResearchPricesConcurrentsModel(
      // // ResearchOfPriceCode: json["ResearchOfPriceCode"],
      ConcurrentCode: json["ConcurrentCode"],
      Name: json["Name"],
      Observation: json["Observation"],
      Address: AddressModel.fromJson(json["Address"]),
    );
  }

  static List<ResearchPricesConcurrentsModel> convertToConcurrents(
    List concurrents,
  ) {
    return concurrents
        .map(
          (concurrent) => ResearchPricesConcurrentsModel.fromJson(concurrent),
        )
        .toList();
  }

  static List<ResearchPricesConcurrentsModel>
      convertResultToListOfConcurrents() {
    List resultAsList =
        json.decode(SoapHelperResponseParameters.responseAsString);

    return resultAsList
        .map((e) => ResearchPricesConcurrentsModel.fromJson(e))
        .toList();
  }
}
