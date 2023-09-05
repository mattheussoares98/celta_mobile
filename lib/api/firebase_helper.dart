import 'package:celta_inventario/Models/firebase_client_model.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/api/prefs_instance.dart';
import 'package:intl/intl.dart';

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

  static CollectionReference _soapActionsCollection =
      _firebaseFirestore.collection("soapActions");

  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> _updateCcsAndEnterpriseNameByDocumentId({
    required String documentId,
    required String enterpriseNameOrurlCCSControllerText,
  }) async {
    DocumentReference documentRef = _clientsCollection.doc(documentId);
    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('urlCCS')) {
        enterpriseNameOrurlCCSControllerText = data['urlCCS'];
        UserData.urlCCS = data['urlCCS'];

        await PrefsInstance.setUrlCcs(data['urlCCS']);
      }

      if (data.containsKey('enterpriseName') &&
          data['enterpriseName'] != "undefined") {
        enterpriseNameOrurlCCSControllerText = data['enterpriseName'];
        await PrefsInstance.setEnterpriseName(data['enterpriseName']);
        UserData.enterpriseName = data['enterpriseName'];
      } else {
        //como não tem o nome da empresa no firebase, precisa zerar no banco local
        await PrefsInstance.setEnterpriseName("");
      }
    } else {
      print('Documento não encontrado.');
    }
  }

  static Future<String> getUrlFromFirebaseAndReturnErrorIfHas(
    String enterpriseNameOrurlCCSControllerText,
  ) async {
    String errorMessage = "";
    enterpriseNameOrurlCCSControllerText = enterpriseNameOrurlCCSControllerText
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ''); //remove espaços em branco

    if (_isUrl(enterpriseNameOrurlCCSControllerText)) {
      await PrefsInstance.setEnterpriseName("");

      //como está informando uma URL, precisa excluir o nome da empresa do banco
      //de dados pra não carregar o nome da empresa errado depois
      UserData.urlCCS = enterpriseNameOrurlCCSControllerText;
      await PrefsInstance.setUrlCcs(enterpriseNameOrurlCCSControllerText);

      QuerySnapshot? querySnapshot;
      querySnapshot = await _clientsCollection
          .where(
            'urlCCS',
            isEqualTo: enterpriseNameOrurlCCSControllerText,
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
            isEqualTo: enterpriseNameOrurlCCSControllerText,
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
    Map<String, dynamic> newSoapAction = {
      "typeOfSearch": firebaseCallEnum.name,
    };
    List mySoaps = await PrefsInstance.getSoaps();
    mySoaps.add(newSoapAction);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (mySoaps.length < 2) {
      await PrefsInstance.setSoaps(mySoaps);
    } else {
      WriteBatch batch = firestore.batch();

      mySoaps.forEach((soapAction) {
        DocumentReference docRef = _soapActionsCollection
            .doc(DateFormat('yyyy-MM').format(DateTime.now()))
            .collection(UserData.enterpriseName)
            .doc(soapAction["typeOfSearch"]);

        batch.set(
          docRef,
          {
            'timesUsed': FieldValue.increment(1),
            'users': FieldValue.arrayUnion([UserData.userName.toLowerCase()]),
            'datesUsed': FieldValue.arrayUnion(
                [DateFormat('yyyy-MM-dd').format(DateTime.now())]),
          },
          SetOptions(merge: true),
        );
      });

      batch
          .commit()
          .then((value) async => {
                await PrefsInstance.clearSoaps(),
              })
          .catchError((error) => error);
    }
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
      urlCCS: UserData.urlCCS,
    );

    QuerySnapshot? querySnapshot;
    querySnapshot = await _clientsCollection
        .where(
          'urlCCS',
          isEqualTo: UserData.urlCCS
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
