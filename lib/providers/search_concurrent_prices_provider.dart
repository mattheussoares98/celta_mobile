import 'package:celta_inventario/api/soap_helper.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResearchConcurrentPricesProvider with ChangeNotifier {
  bool _isLoadingResearchPrices = false;
  bool get isLoadingResearchPrices => _isLoadingResearchPrices;
  String _errorResearchPrices = "";
  String get errorResearchPrices => _errorResearchPrices = "";

  Future<void> getResearchPrices({
    required BuildContext context,
  }) async {
    _isLoadingResearchPrices = true;
    _errorResearchPrices = "";
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "CrossIdentity": UserData.crossIdentity,
          "EnterpriseCode": 0,
          // "InitialCreationDate": DateTime.MinValue,
          // "FinalCreationDate": DateTime.Now,
          "SearchValue": "SearchTypeInt (ExactCode = 1, ApproximateName = 2)",
          "SearchTypeInt": 2
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorResearchPrices = SoapHelperResponseParameters.errorMessage;
      if (_errorResearchPrices != "") {
        ShowSnackbarMessage.showMessage(
          message: _errorResearchPrices,
          context: context,
        );
      } else {
        // Map resultAsMap =
        //     json.decode(SoapHelperResponseParameters.responseAsString);
      }
    } catch (e) {
      // _updateErrorMessage(e.toString());
      print('deu erro pra obter as pesquisas de preços: $e');
      _errorResearchPrices = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorResearchPrices,
        context: context,
      );
    }

    _isLoadingResearchPrices = false;
  }
}
