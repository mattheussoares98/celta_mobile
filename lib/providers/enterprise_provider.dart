import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/enterprise/enterprise.dart';
import '../models/firebase/firebase.dart';
import '../utils/utils.dart';

class EnterpriseProvider with ChangeNotifier {
  List<EnterpriseModel> _enterprises = [];

  List<EnterpriseModel> get enterprises => [..._enterprises];
  int get enterpriseCount => _enterprises.length;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  static bool _isLoading = false;

  bool get isLoading => _isLoading;

  FirebaseEnterpriseModel? _firebaseEnterpriseModel;
  FirebaseEnterpriseModel? get firebaseEnterpriseModel =>
      _firebaseEnterpriseModel;

  bool _showedAdjustPriceAlert = false;
  bool get showedAdjustPriceAlert => _showedAdjustPriceAlert;
  set changeShowedAjustPriceAlert(_) => _showedAdjustPriceAlert = true;

  bool _showedExpeditionConferenteAlert = false;
  bool get showedExpeditionConferenteAlert => _showedExpeditionConferenteAlert;
  set changeShowedExpeditionConferenteAlert(_) =>
      _showedExpeditionConferenteAlert = true;

  Future getEnterprises() async {
    if (_isLoading) {
      return;
    }
    _enterprises.clear();
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      await SoapRequest.soapPost(
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
        data: SoapRequestResponse.responseAsMap["Empresas"],
        listToAdd: _enterprises,
      );

      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFirebaseEnterpriseModel() async {
    _errorMessage = "";
    _isLoading = true;
    _firebaseEnterpriseModel = null;
    notifyListeners();

    try {
      _firebaseEnterpriseModel =
          await FirebaseHelper.getFirebaseEnterpriseModel();
    } catch (e) {
      _errorMessage =
          "Ocorreu um erro não esperado para carregar as informações da empresa \n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearEnterprises() {
    _enterprises.clear();
    notifyListeners();
  }
}
