import 'package:celta_inventario/models/firebase/firebase.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';

class WebProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<FirebaseClientModel> _clients = [];
  List<FirebaseClientModel> get clients => [..._clients];

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      await FirebaseHelper.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllClients() async {
    _isLoading = true;
    _errorMessage = "";
    _clients.clear();

    try {
      final clients = await FirebaseHelper.getAllClients();

      _clients = clients
          .map(
            (element) => FirebaseClientModel.fromJson(
              json: element.data() as Map,
              id: element.id,
            ),
          )
          .toList();

      _clients.sort((a, b) => a.enterpriseName.compareTo(b.enterpriseName));
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
