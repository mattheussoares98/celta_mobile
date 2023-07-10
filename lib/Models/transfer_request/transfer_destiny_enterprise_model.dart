import 'dart:convert';

class TransferDestinyEnterpriseModel {
  final int Code; /*  3, */
  final int SaleRequestTypeCode; /*  7 */
  final String PersonalizedCode; /* "2" */
  final String Name; /* "Celtaware" */
  final String FantasizesName; /* "Celtaware" */
  final String CnpjNumber; /* "01150157000247" */
  final String InscriptionNumber; /* "114716120113" */

  TransferDestinyEnterpriseModel({
    required this.Code,
    required this.SaleRequestTypeCode,
    required this.PersonalizedCode,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjNumber,
    required this.InscriptionNumber,
  });

  static resultAsStringToDestinyEnterpriseModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        TransferDestinyEnterpriseModel(
          Code: data["Code"],
          SaleRequestTypeCode: data["SaleRequestTypeCode"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          FantasizesName: data["FantasizesName"],
          CnpjNumber: data["CnpjNumber"],
          InscriptionNumber: data["InscriptionNumber"],
        ),
      );
    });
  }
}
