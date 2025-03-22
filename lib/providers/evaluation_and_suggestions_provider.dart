import 'package:flutter/material.dart';

import '../Models/evaluation_and_suggestions/evaluation_model.dart';
import '../utils/utils.dart';

class EvaluationAndSuggestionsProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<EvaluationModel> _evaluations = [
    EvaluationModel(name: "Ajuda na produtividade"),
    EvaluationModel(name: "Facilidade de uso"),
    EvaluationModel(name: "Desempenho"),
    EvaluationModel(name: "Aparência e design"),
    EvaluationModel(name: "Atualizações e melhorias"),
  ];
  List<EvaluationModel> get evaluations => _evaluations;

  Future<void> sendEvaluate() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      // await FirebaseHelper.sendEvaluate();
    } catch (e) {
      _errorMessage = DefaultErrorMessage.ERROR;
    }
    _isLoading = false;
  }
}
