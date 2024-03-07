import 'dart:convert';

import '../../api/api.dart';
import '../../models/address/address.dart';

class ResearchPricesConcurrentsModel {
  // final int ResearchOfPriceCode;
  final int ConcurrentCode;
  final String Name;
  final String Observation;
  final AddressModel Address;

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
    List<ResearchPricesConcurrentsModel> list = [];
    concurrents.forEach((element) {
      list.add(ResearchPricesConcurrentsModel.fromJson(element));
    });

    return list;
  }

  static List<ResearchPricesConcurrentsModel> convertResultToListOfConcurrents() {
    List<ResearchPricesConcurrentsModel> concurrents = [];
    if (SoapHelperResponseParameters.errorMessage != "") {
      return concurrents;
    }
    List resultAsList =
        json.decode(SoapHelperResponseParameters.responseAsString);

    resultAsList.forEach((element) {
      concurrents.add(ResearchPricesConcurrentsModel.fromJson(element));
    });
    return concurrents;
  }
}
