import '../models.dart';

class CustomerRegisterModel {
  final int? Code; // 2697,
  final String crossId; // "crossId",
  final String? PersonalizedCode; // "999",
  final String Name; // "JavaScript Object Notation - JSON",
  final String? ReducedName; // "JSON Obj",
  final String CpfCnpjNumber; // "23696428078",
  final String? RegistrationNumber; // "258842246",
  final String? DateOfBirth; // "2001-01-01T00:00:00",
  final String SexType; // "F",
  final String PersonType; // "F",
  final List<String>? Emails;
  final List<Map<String, dynamic>>? Telephones;
  bool? selected;
  final List<SaleRequestCovenantsModel> /* TODO fix */ Covenants;
// "Telephones": [
// {
// "AreaCode": "11",
// "PhoneNumber": "97497-7385"
// },
// {
// "AreaCode": "11",
// "PhoneNumber": "99707-5834"
// }
// ],
  List<Map<String, String>>? Addresses;
// "Addresses": [
// {
// "Zip": "01047020",
// "Address": "Doutor Bráulio Gomes",
// "Number": "141",
// "District": "República",
// "City": "São Paulo",
// "State": "SP",
// "Complement": "1º Andar",
// "Reference": "Ao lado da galeria"
// },
// {
// "Zip": "07082560",
// "Address": "Annunciato Thomeu",
// "Number": "304",
// "District": "Jardim City",
// "City": "Guarulhos",
// "State": "SP",
// "Complement": "",
// "Reference": ""
// }
// ],
// "Covenants": null

  CustomerRegisterModel({
    required this.crossId,
    required this.Name,
    required this.Code,
    required this.PersonalizedCode,
    required this.ReducedName,
    required this.CpfCnpjNumber,
    required this.RegistrationNumber,
    required this.DateOfBirth,
    required this.SexType,
    required this.PersonType,
    required this.Emails,
    required this.Telephones,
    required this.Addresses,
    required this.selected,
    required this.Covenants,
  });

  static resultAsStringToCustomerRegisterModel({
    required dynamic data,
    required List listToAdd,
  }) {
    if (data == null) {
      return;
    }
    List dataList = [];
    if (data is Map) {
      dataList.add(data);
    } else {
      dataList = data;
    }

    dataList.forEach((element) {
      // listToAdd.add(
      // CustomerRegisterModel(
      //   codigoInternoEmpresa: int.parse(element['CodigoInterno_Empresa']),
      //   codigoEmpresa: element['Codigo_Empresa'],
      //   nomeEmpresa: element['Nome_Empresa'],
      //   cnpj: element['Cnpj_Empresa'],
      //   CodigoInternoVendaMobile_ModeloPedido:
      //       element["CodigoInternoVendaMobile_ModeloPedido"] ?? "-1",
      // ),
      // );
    });
  }
}
