import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/enterprise/enterprise.dart';
import '../utils/utils.dart';

class EnterpriseProvider with ChangeNotifier {
  List<EnterpriseModel> _enterprises = [];

  List<EnterpriseModel> get enterprises => [..._enterprises];
  int get enterpriseCount => _enterprises.length;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  static bool _isLoadingEnterprises = false;

  bool get isLoadingEnterprises => _isLoadingEnterprises;
  Future getEnterprises({
    bool? isConsultingAgain = false,
  }) async {
    if (_isLoadingEnterprises) {
      return;
    }
    _enterprises.clear();
    _errorMessage = '';
    _isLoadingEnterprises = true;
    if (isConsultingAgain!) notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "simpleSearchValue": "",
          "requestTypeCode": 0,
        },
        typeOfResponse: "GetEnterprisesResponse",
        SOAPAction: "GetEnterprises",
        serviceASMX: "CeltaEnterpriseService.asmx",
        typeOfResult: "GetEnterprisesResult",
      );

      EnterpriseModel.resultAsStringToEnterpriseModel(
        data: SoapHelperResponseParameters.responseAsMap["Empresas"],
        listToAdd: _enterprises,
      );

      _errorMessage = SoapHelperResponseParameters.errorMessage;
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingEnterprises = false;
      notifyListeners();
    }
  }
}
