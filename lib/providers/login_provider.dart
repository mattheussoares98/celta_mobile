import 'dart:async';
import 'dart:convert';
import 'package:celta_inventario/Models/firebase_client_model.dart';
import 'package:celta_inventario/utils/soap_helper.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import '../utils/base_url.dart';
import '../utils/default_error_message_to_find_server.dart';
import '../Components/Global_widgets/show_error_message.dart';

class LoginProvider with ChangeNotifier {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference clientsCollection = _db.collection("clients");

  String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  static MultiStreamController<bool>? _loginController;
  //esse stream está sendo usado no AuthOrHomePage
  //quando da certo o login, ele adiciona o _isAuth no controller
  static final _isAuthStream = Stream<bool>.multi((controller) {
    _loginController = controller;
  });

  Stream<bool> get authStream {
    return _isAuthStream;
  }

  _saveUserAndEnterpriseNameOrCCSUrlInLocalDatabase({
    required String enterpriseNameOrCCSUrl,
    required String user,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('user', user);

    if (_isUrl(enterpriseNameOrCCSUrl)) {
      BaseUrl.ccsUrl = enterpriseNameOrCCSUrl;
      await prefs.setString('enterpriseName', "");
      await prefs.setString('ccsUrl', BaseUrl.ccsUrl);
    } else {
      await prefs.setString('enterpriseName', enterpriseNameOrCCSUrl);
    }
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('user')!;
  }

  Future<void> verifyIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userIdentity') != "" &&
        prefs.getString('userIdentity') != null) {
      UserIdentity.identity = await prefs.getString('userIdentity')!;
      _loginController!.add(true);
    }
  }

  Future<void> restoreBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('ccsUrl') != null && prefs.getString('ccsUrl') != "") {
      BaseUrl.ccsUrl = prefs.getString('ccsUrl')!;
    }
  }

  restoreUserAndEnterpriseNameOrCCSUrl({
    required TextEditingController enterpriseNameOrCCSUrlController,
    required TextEditingController userController,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('user') != null) {
      userController.text = prefs.getString('user')!;
    }

    if (prefs.getString('enterpriseName') != null &&
        prefs.getString('enterpriseName') != "") {
      enterpriseNameOrCCSUrlController.text =
          prefs.getString('enterpriseName')!;
    } else if (prefs.getString('ccsUrl') != null &&
        prefs.getString('ccsUrl') != "") {
      enterpriseNameOrCCSUrlController.text = prefs.getString('ccsUrl')!;
    }
  }

  login({
    required String user,
    required String password,
    required TextEditingController enterpriseNameOrCCSUrlController,
    required BuildContext context,
  }) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    await _saveUserAndEnterpriseNameOrCCSUrlInLocalDatabase(
      enterpriseNameOrCCSUrl: enterpriseNameOrCCSUrlController.text,
      user: user,
    );

    bool? canTryLogin;
    if (_isUrl(enterpriseNameOrCCSUrlController.text)) {
      canTryLogin = await _hasUrlCcsInFirebase(
        enterpriseNameOrCCSUrlController: enterpriseNameOrCCSUrlController,
      );
    } else {
      canTryLogin = await _hasEnterpriseInFirebase(
        enterpriseNameOrCCSUrlController: enterpriseNameOrCCSUrlController,
      );
    }

    if (!canTryLogin) {
      ShowErrorMessage.showErrorMessage(
        error: _errorMessage,
        context: context,
      );
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await SoapHelper.soapPost(
        parameters: {
          "user": user,
          "password": password,
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorMessage = SoapHelperResponseParameters.errorMessage;
      if (SoapHelperResponseParameters.errorMessage != "") {
        ShowErrorMessage.showErrorMessage(
          error: _errorMessage,
          context: context,
        );
      } else {
        Map resultAsMap =
            json.decode(SoapHelperResponseParameters.responseAsString);
        // Map resultAsMap = resultAsList.asMap();

        final myTransformer = Xml2Json();
        myTransformer
            .parse(resultAsMap["Usuarios"][0]['CrossIdentity_Usuario']);
        String toParker = myTransformer.toParker();
        Map toParker2 = json.decode(toParker);
        UserIdentity.identity = toParker2['string'];

        _loginController?.add(true);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userIdentity', UserIdentity.identity);

        await _addClientInFirebase(
          firebaseClientModel: FirebaseClientModel(
            urlCCS: BaseUrl.ccsUrl,
          ),
        );
      }
    } catch (e) {
      // _updateErrorMessage(e.toString());
      print('deu erro no login: $e');
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessage,
        context: context,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userIdentity', "");
    _loginController?.add(false);
  }

  _addClientInFirebase({
    required FirebaseClientModel firebaseClientModel,
  }) async {
    QuerySnapshot querySnapshot;

    if (_isUrl(firebaseClientModel.urlCCS)) {
      querySnapshot = await clientsCollection
          .where(
            'urlCCS',
            isEqualTo: firebaseClientModel.urlCCS,
          )
          .get();
      if (querySnapshot.size > 0) {
        print("já existe documento com essa URL, não precisa adicionar");
      } else {
        clientsCollection
            .add(firebaseClientModel.toJson())
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    }
  }

  bool _isUrl(String text) {
    return text.toLowerCase().contains('http') &&
        text.toLowerCase().contains('//') &&
        text.toLowerCase().contains(':') &&
        text.toLowerCase().contains('ccs');
  }

  Future<bool> _hasEnterpriseInFirebase({
    required TextEditingController enterpriseNameOrCCSUrlController,
  }) async {
    bool canTryLogin = false;
    QuerySnapshot? querySnapshot;
    querySnapshot = await clientsCollection
        .where('enterpriseName',
            isEqualTo: enterpriseNameOrCCSUrlController.text.toLowerCase())
        .get();

    if (querySnapshot.size > 0) {
      canTryLogin = true;

      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      String documentId = documentSnapshot.id;
      await _getUrlCCSFromDocumentId(
        documentId: documentId,
        enterpriseNameOrCCSUrlController: enterpriseNameOrCCSUrlController,
      );
      print("já existe documento com esse nome de empresa");
    } else {
      _errorMessage =
          "A empresa não foi encontrada no banco de dados. Entre em contato com o suporte e solicite a URL do CCS para fazer o login";
    }

    return canTryLogin;
  }

  Future<bool> _hasUrlCcsInFirebase({
    required TextEditingController enterpriseNameOrCCSUrlController,
  }) async {
    bool canTryLogin = false;
    QuerySnapshot? querySnapshot;
    if (_isUrl(enterpriseNameOrCCSUrlController.text
        .trimRight()
        .trimLeft()
        .toLowerCase())) {
      canTryLogin = true;
    }
    querySnapshot = await clientsCollection
        .where(
          'urlCCS',
          isEqualTo: enterpriseNameOrCCSUrlController.text
              .trimRight()
              .trimLeft()
              .toLowerCase(),
        )
        .get();

    if (querySnapshot.size > 0) {
      canTryLogin = true;

      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      String documentId = documentSnapshot.id;
      await _getUrlCCSFromDocumentId(
        documentId: documentId,
        enterpriseNameOrCCSUrlController: enterpriseNameOrCCSUrlController,
      );
    } else {
      _errorMessage =
          "A empresa não foi encontrada no banco de dados. Entre em contato com o suporte e solicite a URL do CCS para fazer o login";
    }
    return canTryLogin;
  }

  Future<void> _getUrlCCSFromDocumentId({
    required String documentId,
    required TextEditingController enterpriseNameOrCCSUrlController,
  }) async {
    DocumentReference documentRef = clientsCollection.doc(documentId);
    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('urlCCS')) {
        BaseUrl.ccsUrl = data['urlCCS'];
        print(BaseUrl.ccsUrl);
      }

      if (data.containsKey('enterpriseName')) {
        if (data['enterpriseName'] != "undefined") {
          //se for "undefined" é porque ainda não adicionou o nome do cliente no banco de banco
          SharedPreferences prefs = await SharedPreferences.getInstance();
          enterpriseNameOrCCSUrlController.text = data['enterpriseName'];
          await prefs.setString('enterpriseName', data['enterpriseName']);
        }
      } else {
        enterpriseNameOrCCSUrlController.text = data['urlCCS'];
      }
    } else {
      print('Documento não encontrado.');
    }
  }
}
