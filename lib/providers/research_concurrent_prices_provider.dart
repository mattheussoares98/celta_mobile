import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/global_widgets/global_widgets.dart';
import '../models/research_prices/research_prices.dart';
import '../utils/utils.dart';

class ResearchConcurrentPricesProvider with ChangeNotifier {
  bool _isLoadingResearchPrices = false;
  bool get isLoadingResearchPrices => _isLoadingResearchPrices;
  String _errorResearchPrices = "";
  String get errorResearchPrices => _errorResearchPrices = "";
  final List<ResearchPriceModel> _researchPrices = [];
  List<ResearchPriceModel> get researchPrices => [..._researchPrices];
  int get researchPricesCount => _researchPrices.length;

  Future<void> _getResearchPrices({required bool isExactCode}) async {
    try {
      await SoapHelper.soapPost(
        parameters: {
          "CrossIdentity": UserData.crossIdentity,
          // "EnterpriseCode": 0,
          // "InitialCreationDate": DateTime.MinValue,
          // "FinalCreationDate": DateTime.Now,
          "SearchValue": isExactCode
              //ExactCode = 1, ApproximateName = 2
              ? 1
              : 2,
          "SearchTypeInt": 2
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorResearchPrices = SoapHelperResponseParameters.errorMessage;
    } catch (e) {}
  }

  Future<void> getResearchPrices({
    required BuildContext context,
  }) async {
    _errorResearchPrices = "";
    _isLoadingResearchPrices = true;
    notifyListeners();

    await _getResearchPrices(isExactCode: true);
    if (researchPricesCount == 0) {
      await _getResearchPrices(isExactCode: false);
    }

    if (_errorResearchPrices != "") {
      ShowSnackbarMessage.showMessage(
        message: _errorResearchPrices,
        context: context,
      );
    } else {
      //converter os dados para ResearchPricesModel
      // Map resultAsMap =
      //     json.decode(SoapHelperResponseParameters.responseAsString);
    }

    _isLoadingResearchPrices = false;
  }
}
