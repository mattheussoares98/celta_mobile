import 'package:celta_inventario/Models/firebase_client_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FirebaseCallEnum {
  adjustStockConfirmQuantity,
  priceConferenceGetProduct,
  priceConferenceSendToPrint,
  inventoryEntryQuantity,
  inventoryAnullQuantity,
  receiptEntryQuantity,
  receiptAnullQuantity,
  receiptLiberate,
  saleRequestSave,
  transferBetweenStocksConfirmAdjust,
  transferBetweenPackageConfirmAdjust,
  transferRequestSave,
}

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper._internal();

  factory FirebaseHelper() {
    return _instance;
  }

  FirebaseHelper._internal();

  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _clientsCollection =
      _firebaseFirestore.collection("clients");
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static int _codeOfSoapAction(FirebaseCallEnum firebaseCallEnum) {
    int index = -1;
    for (var value in FirebaseCallEnum.values) {
      if (value.index == firebaseCallEnum.index) {
        print(value);
        print(value.index);
        index = value.index;
      }
    }
    return index;
  }

  static Future<void> _updateCcsAndEnterpriseNameByDocumentId({
    required String documentId,
    required String enterpriseNameOrurlCCSControllerText,
  }) async {
    DocumentReference documentRef = _clientsCollection.doc(documentId);
    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data.containsKey('urlCCS')) {
        enterpriseNameOrurlCCSControllerText = data['urlCCS'];
        BaseUrl.urlCCS = data['urlCCS'];
        await prefs.setString('urlCCS', data['urlCCS']);
      }

      if (data.containsKey('enterpriseName') &&
          data['enterpriseName'] != "undefined") {
        enterpriseNameOrurlCCSControllerText = data['enterpriseName'];
        await prefs.setString('enterpriseName', data['enterpriseName']);
      } else {
        //como não tem o nome da empresa no firebase, precisa zerar no banco local
        await prefs.setString('enterpriseName', "");
      }
    } else {
      print('Documento não encontrado.');
    }
  }

  static Future<String> getUrlFromFirebaseAndReturnErrorIfHas(
    String enterpriseNameOrurlCCSControllerText,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String errorMessage = "";
    if (_isUrl(enterpriseNameOrurlCCSControllerText)) {
      await prefs.setString('enterpriseName', "");
      //como está informando uma URL, precisa excluir o nome da empresa do banco
      //de dados pra não carregar o nome da empresa errado depois
      BaseUrl.urlCCS = enterpriseNameOrurlCCSControllerText;

      QuerySnapshot? querySnapshot;
      querySnapshot = await _clientsCollection
          .where(
            'urlCCS',
            isEqualTo: enterpriseNameOrurlCCSControllerText
                .toLowerCase()
                .replaceAll(RegExp(r'\s+'), ''), //remove espaços em branco
          )
          .get();

      if (querySnapshot.size > 0) {
        errorMessage = "";

        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        String documentId = documentSnapshot.id;
        await _updateCcsAndEnterpriseNameByDocumentId(
          documentId: documentId,
          enterpriseNameOrurlCCSControllerText:
              enterpriseNameOrurlCCSControllerText,
        );
      }
    } else {
      QuerySnapshot? querySnapshot;
      querySnapshot = await _clientsCollection
          .where(
            'enterpriseName',
            isEqualTo: enterpriseNameOrurlCCSControllerText
                .toLowerCase()
                .replaceAll(RegExp(r'\s+'), ''), //remove espaços em branco
          )
          .get();

      if (querySnapshot.size > 0) {
        errorMessage = "";

        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        String documentId = documentSnapshot.id;
        await _updateCcsAndEnterpriseNameByDocumentId(
          documentId: documentId,
          enterpriseNameOrurlCCSControllerText:
              enterpriseNameOrurlCCSControllerText,
        );
      } else {
        errorMessage =
            "A empresa não foi encontrada no banco de dados. Entre em contato com o suporte e solicite a URL do CCS para fazer o login";
      }
    }
    return errorMessage;
  }

  static Future<void> addSoapCallInFirebase({
    required FirebaseCallEnum firebaseCallEnum,
  }) async {
    return;
    // _codeOfSoapAction(firebaseCallEnum);
    // QuerySnapshot? querySnapshot;

    // querySnapshot = await _clientsCollection
    //     .where(
    //       'urlCCS',
    //       isEqualTo: BaseUrl.urlCCS.trimRight().trimLeft().toLowerCase(),
    //     )
    //     .get();

    // if (querySnapshot.size > 0) {
    //   DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

    //   DocumentReference documentReference =
    //       _clientsCollection.doc(documentSnapshot.id);

    //   QuerySnapshot querySnapshotSoapActions =
    //       await documentReference.collection("soapActions").get();

    //   Map<String, dynamic> soapCallsDetails = {
    //     "date": DateTime.now().toIso8601String(),
    //     "typeOfSearch": firebaseCallEnum.index,
    //   };

    //   await documentReference
    //       .collection("soapActions")
    //       .add(soapCallsDetails)
    //       .then((value) => print("adicionou contador"))
    //       .catchError((error) => print("erro pra adicionar o contador $error"));

    // if (querySnapshotSoapActions.size > 0) {
    //   DocumentSnapshot documentSnapshotSoapActions =
    //       querySnapshotSoapActions.docs[0];

    //   Map<String, dynamic> dataSoapActions =
    //       documentSnapshotSoapActions.data() as Map<String, dynamic>;

    //   if (dataSoapActions.containsKey("soapActions")) {
    //     await documentReference
    //         .collection("soapActions")
    //         .add(soapCallsDetails)
    //         .then((value) => print("adicionou contador"))
    //         .catchError(
    //             (error) => print("erro pra adicionar o contador $error"));
    //   } else {
    //     await documentReference
    //         .collection("soapActions")
    //         .add(soapCallsDetails)
    //         .then((value) => print("adicionou coleção"))
    //         .catchError((error) => print("erro pra adicionar a coleção"));
    //   }
    // }
    // }
  }

  static bool _isUrl(String text) {
    return text.toLowerCase().contains('http') &&
        text.toLowerCase().contains('//') &&
        text.toLowerCase().contains(':') &&
        text.toLowerCase().contains('ccs');
  }

  static addCcsClientInFirebase() async {
    // QuerySnapshot querySnapshot;

    FirebaseClientModel firebaseClientModel = FirebaseClientModel(
      urlCCS: BaseUrl.urlCCS,
    );

    QuerySnapshot? querySnapshot;
    querySnapshot = await _clientsCollection
        .where(
          'urlCCS',
          isEqualTo: BaseUrl.urlCCS
              .toLowerCase()
              .replaceAll(RegExp(r'\s+'), ''), //remove espaços em branco
        )
        .get();

    if (querySnapshot.size == 0) {
      //só adiciona o cliente se não encontrar urlCCS com a que está sendo
      //utilizada
      _clientsCollection
          .add(firebaseClientModel.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // print("title: ${message.notification?.title}");
    // print("body: ${message.notification?.body}");
    // print("data: ${message.data}");
  }

  static Future<void> initNotifications(BuildContext context) async {
    await _firebaseMessaging.requestPermission();
    // final fcmToken = await _firebaseMessaging.getToken();
    // print("Token: $fcmToken"); //precisa usar esse token pra fazer testes de
    // mensagens pelo site do firebase

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    //sempre que chegar uma mensagem e o aplicativo estiver EM SEGUNDO PLANO,
    //vai aparecer a notificação pro cliente. Quando o aplicativo estiver em
    //primeiro plano, vai executar a função abaixo

    //abaixo recebe a notificação em primeiro plano
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print(
    //         'Título da notificação: ${message.notification!.title.toString()}');
    //     print('Texto da notificação: ${message.notification!.body}');
    //   }
    // });
  }
}
