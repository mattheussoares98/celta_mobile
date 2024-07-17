class ScheduleModel {
  final int? code;
  final int? priceType;
  final int? origin;
  final double? originalPrice;
  final double? price;
  final double? lastPrice;
  final String? user;
  final String? date;
  final String? executionDate;
  final String? priceTypeString;
  final String? originString;
  final String? offerSchedule;
  final bool? roundedPrice;
  final bool? alteredByEnterpriseGroup;
  final bool? alteredByClass;
  final bool? alteredByPackings;
  final bool? alteredByGrid;
  final bool? updateClass;
  final bool? updateEnterpriseOperationalGroup;
  final bool? isFather;
  final bool? isBrother;
  final bool? isExecuted;
  final bool? isFinished;

  ScheduleModel({
    required this.code,
    required this.priceType,
    required this.origin,
    required this.originalPrice,
    required this.price,
    required this.lastPrice,
    required this.user,
    required this.date,
    required this.executionDate,
    required this.priceTypeString,
    required this.originString,
    required this.offerSchedule,
    required this.roundedPrice,
    required this.alteredByEnterpriseGroup,
    required this.alteredByClass,
    required this.alteredByPackings,
    required this.alteredByGrid,
    required this.updateClass,
    required this.updateEnterpriseOperationalGroup,
    required this.isFather,
    required this.isBrother,
    required this.isExecuted,
    required this.isFinished,
  });

  factory ScheduleModel.fromJson(Map json) => ScheduleModel(
        code: json["code"],
        priceType: json["priceType"],
        origin: json["origin"],
        originalPrice: json["originalPrice"],
        price: json["price"],
        lastPrice: json["lastPrice"],
        user: json["user"],
        date: json["date"],
        executionDate: json["executionDate"],
        priceTypeString: json["priceTypeString"],
        originString: json["originString"],
        offerSchedule: json["offerSchedule"],
        roundedPrice: json["roundedPrice"],
        alteredByEnterpriseGroup: json["alteredByEnterpriseGroup"],
        alteredByClass: json["alteredByClass"],
        alteredByPackings: json["alteredByPackings"],
        alteredByGrid: json["alteredByGrid"],
        updateClass: json["updateClass"],
        updateEnterpriseOperationalGroup:
            json["updateEnterpriseOperationalGroup"],
        isFather: json["isFather"],
        isBrother: json["isBrother"],
        isExecuted: json["isExecuted"],
        isFinished: json["isFinished"],
      );

  Map<String, dynamic> toJson(ScheduleModel scheduleModel) => {
        "code": code,
        "priceType": priceType,
        "origin": origin,
        "originalPrice": originalPrice,
        "price": price,
        "lastPrice": lastPrice,
        "user": user,
        "date": date,
        "executionDate": executionDate,
        "priceTypeString": priceTypeString,
        "originString": originString,
        "offerSchedule": offerSchedule,
        "roundedPrice": roundedPrice,
        "alteredByEnterpriseGroup": alteredByEnterpriseGroup,
        "alteredByClass": alteredByClass,
        "alteredByPackings": alteredByPackings,
        "alteredByGrid": alteredByGrid,
        "updateClass": updateClass,
        "updateEnterpriseOperationalGroup": updateEnterpriseOperationalGroup,
        "isFather": isFather,
        "isBrother": isBrother,
        "isExecuted": isExecuted,
        "isFinished": isFinished,
      };
}
