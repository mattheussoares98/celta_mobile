class ScheduleModel {
  final int? Code;
  final int? PriceType;
  final int? Origin;
  final double? OriginalPrice;
  final double? Price;
  final double? LastPrice;
  final String? User;
  final String? Date;
  final String? ExecutionDate;
  final String? PriceTypeString;
  final String? OriginString;
  final String? OfferSchedule;
  final bool? RoundedPrice;
  final bool? AlteredByEnterpriseGroup;
  final bool? AlteredByClass;
  final bool? AlteredByPackings;
  final bool? AlteredByGrid;
  final bool? UpdateClass;
  final bool? UpdateEnterpriseOperationalGroup;
  final bool? IsFather;
  final bool? IsBrother;
  final bool? IsExecuted;
  final bool? IsFinished;

  ScheduleModel({
    required this.Code,
    required this.PriceType,
    required this.Origin,
    required this.OriginalPrice,
    required this.Price,
    required this.LastPrice,
    required this.User,
    required this.Date,
    required this.ExecutionDate,
    required this.PriceTypeString,
    required this.OriginString,
    required this.OfferSchedule,
    required this.RoundedPrice,
    required this.AlteredByEnterpriseGroup,
    required this.AlteredByClass,
    required this.AlteredByPackings,
    required this.AlteredByGrid,
    required this.UpdateClass,
    required this.UpdateEnterpriseOperationalGroup,
    required this.IsFather,
    required this.IsBrother,
    required this.IsExecuted,
    required this.IsFinished,
  });

  factory ScheduleModel.fromJson(Map json) => ScheduleModel(
        Code: json["Code"],
        PriceType: json["PriceType"],
        Origin: json["Origin"],
        OriginalPrice: json["OriginalPrice"],
        Price: json["Price"],
        LastPrice: json["LastPrice"],
        User: json["User"],
        Date: json["Date"],
        ExecutionDate: json["ExecutionDate"],
        PriceTypeString: json["PriceTypeString"],
        OriginString: json["OriginString"],
        OfferSchedule: json["OfferSchedule"],
        RoundedPrice: json["RoundedPrice"],
        AlteredByEnterpriseGroup: json["AlteredByEnterpriseGroup"],
        AlteredByClass: json["AlteredByClass"],
        AlteredByPackings: json["AlteredByPackings"],
        AlteredByGrid: json["AlteredByGrid"],
        UpdateClass: json["UpdateClass"],
        UpdateEnterpriseOperationalGroup:
            json["UpdateEnterpriseOperationalGroup"],
        IsFather: json["IsFather"],
        IsBrother: json["IsBrother"],
        IsExecuted: json["IsExecuted"],
        IsFinished: json["IsFinished"],
      );

  Map<String, dynamic> toJson(ScheduleModel scheduleModel) => {
        "Code": Code,
        "PriceType": PriceType,
        "Origin": Origin,
        "OriginalPrice": OriginalPrice,
        "Price": Price,
        "LastPrice": LastPrice,
        "User": User,
        "Date": Date,
        "ExecutionDate": ExecutionDate,
        "PriceTypeString": PriceTypeString,
        "OriginString": OriginString,
        "OfferSchedule": OfferSchedule,
        "RoundedPrice": RoundedPrice,
        "AlteredByEnterpriseGroup": AlteredByEnterpriseGroup,
        "AlteredByClass": AlteredByClass,
        "AlteredByPackings": AlteredByPackings,
        "AlteredByGrid": AlteredByGrid,
        "UpdateClass": UpdateClass,
        "UpdateEnterpriseOperationalGroup": UpdateEnterpriseOperationalGroup,
        "IsFather": IsFather,
        "IsBrother": IsBrother,
        "IsExecuted": IsExecuted,
        "IsFinished": IsFinished,
      };
}
