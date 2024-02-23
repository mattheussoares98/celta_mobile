class CustomerRegisterModel {
  int? Code; // 2697,
  String crossId; // "crossId",
  String? PersonalizedCode; // "999",
  String Name; // "JavaScript Object Notation - JSON",
  String? ReducedName; // "JSON Obj",
  String CpfCnpjNumber; // "23696428078",
  String? RegistrationNumber; // "258842246",
  String? DateOfBirth; // "2001-01-01T00:00:00",
  String SexType; // "F",
  String PersonType; // "F",
  List<String>? Emails;
  List<Map<String, dynamic>>? Telephones;
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
    this.Code,
    required this.crossId,
    this.PersonalizedCode,
    required this.Name,
    this.ReducedName,
    required this.CpfCnpjNumber,
    this.RegistrationNumber,
    this.DateOfBirth,
    required this.SexType,
    required this.PersonType,
    this.Emails,
    this.Telephones,
    this.Addresses,
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
