import 'package:celta_inventario/models/firebase/firebase.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';

class WebProvider with ChangeNotifier {
  bool _isLoadingClients = false;
  bool get isLoadingClients => _isLoadingClients;

  String _errorMessageClients = "";
  String get errorMessageClients => _errorMessageClients;

  bool _isLoadingSoapActions = false;
  bool get isLoadingSoapActions => _isLoadingSoapActions;

  String _errorMessageSoapActions = "";
  String get errorMessageSoapActions => _errorMessageSoapActions;

  List<FirebaseClientModel> _clients = [];
  List<FirebaseClientModel> get clients => [..._clients];

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoadingClients = true;
    _errorMessageClients = "";
    notifyListeners();

    try {
      await FirebaseHelper.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      _errorMessageClients = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingClients = false;
      notifyListeners();
    }
  }

  Future<void> getAllClients() async {
    _isLoadingClients = true;
    _errorMessageClients = "";
    _clients.clear();
    notifyListeners();

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
      _errorMessageClients = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingClients = false;
      notifyListeners();
    }
  }

  Future<dynamic> getAllSoapActions() async {
    _isLoadingSoapActions = true;
    _errorMessageSoapActions = "";
    notifyListeners();
    try {
      final soapActions = await FirebaseHelper.getAllSoapActions();
      print(soapActions);

      if (soapActions != null) {
        for (var client in soapActions) {
          
          final clientData = client.data();
          print("${client.id} == $clientData");
        }
      }
    } catch (e) {
      _errorMessageSoapActions = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingSoapActions = false;
      notifyListeners();
    }
  }
}
