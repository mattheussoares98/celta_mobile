import 'dart:convert';

class TransferOriginEnterpriseModel {
  final int Code; /*  2, */
  final int SaleRequestTypeCode; /*  1 */
  final String PersonalizedCode; /*  "1", */
  final String Name; /*  "DISTRIBUIDORA E IMPORTADORA SÃO JOSÉ LTDA - EPP", */
  final String FantasizesName; /*  "MEGA SÃO JOSÉ - 1 RUA ORIENTE", */
  final String CnpjNumber; /*  "01150157000166", */
  final String InscriptionNumber; /*  "114630883118", */

  TransferOriginEnterpriseModel({
    required this.Code,
    required this.SaleRequestTypeCode,
    required this.PersonalizedCode,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjNumber,
    required this.InscriptionNumber,
  });

  static resultAsStringToOriginEnterpriseModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        TransferOriginEnterpriseModel(
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
