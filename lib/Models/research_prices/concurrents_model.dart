import './research_prices.dart';

class ConcurrentsModel {
  final int ResearchOfPriceCode;
  final int ConcurrentCode;
  final String Name;
  final String Observation;
  final AdressModel Address;

  ConcurrentsModel({
    required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.Name,
    required this.Observation,
    required this.Address,
  });

  factory ConcurrentsModel.fromJson(Map<String, dynamic> json) {
    return ConcurrentsModel(
      ResearchOfPriceCode: json["ResearchOfPriceCode"],
      ConcurrentCode: json["ConcurrentCode"],
      Name: json["Name"],
      Observation: json["Observation"],
      Address: AdressModel.fromJson(json["Address"]),
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

  static void addConcurrentsWithResultAsList({
    required List resultAsList,
    required List<ConcurrentsModel> listToAdd,
  }) {
    resultAsList.forEach((element) {
      listToAdd.add(ConcurrentsModel.fromJson(element));
    });
  }
}
