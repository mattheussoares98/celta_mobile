import 'dart:convert';

import '../../api/api.dart';
import '../../models/address/address.dart';

class ConcurrentsModel {
  // final int ResearchOfPriceCode;
  final int ConcurrentCode;
  final String Name;
  final String Observation;
  final AddressModel Address;

  ConcurrentsModel({
    // required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.Name,
    required this.Observation,
    required this.Address,
  });

  factory ConcurrentsModel.fromJson(Map<String, dynamic> json) {
    return ConcurrentsModel(
      // // ResearchOfPriceCode: json["ResearchOfPriceCode"],
      ConcurrentCode: json["ConcurrentCode"],
      Name: json["Name"],
      Observation: json["Observation"],
      Address: AddressModel.fromJson(json["Address"]),
    );
  }

  static List<ConcurrentsModel> convertToConcurrents(
    List concurrents,
  ) {
    List<ConcurrentsModel> list = [];
    concurrents.forEach((element) {
      list.add(ConcurrentsModel.fromJson(element));
    });

    return list;
  }

  static List<ConcurrentsModel> convertResultToListOfConcurrents() {
    List<ConcurrentsModel> concurrents = [];
    if (SoapHelperResponseParameters.errorMessage != "") {
      return concurrents;
    }
    List resultAsList =
        json.decode(SoapHelperResponseParameters.responseAsString);

    resultAsList.forEach((element) {
      concurrents.add(ConcurrentsModel.fromJson(element));
    });
    return concurrents;
  }
}
