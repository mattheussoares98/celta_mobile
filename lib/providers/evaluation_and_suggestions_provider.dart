import 'package:flutter/material.dart';

import '../utils/utils.dart';

class EvaluationAndSuggestionsProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<void> sendEvaluate() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      // await FirebaseHelper.sendEvaluate();
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoading = false;
  }
}
