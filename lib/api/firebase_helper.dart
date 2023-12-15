import 'package:celta_inventario/Models/firebase_client_model.dart';
import 'package:celta_inventario/firebase_options.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/api/prefs_instance.dart';
import 'package:intl/intl.dart';

enum FirebaseCallEnum {
  adjustStockConfirmQuantity,
  priceConferenceGetProductOrSendToPrint,
  inventoryEntryQuantity,
  receiptEntryQuantity,
  receiptLiberate,
  saleRequestSave,
  transferBetweenStocksConfirmAdjust,
  transferBetweenPackageConfirmAdjust,
  transferRequestSave,
  aboutUs,
  instagram,
  linkedin,
  facebook,
  callToCeltaNumber,
  pdvWhats,
  bsWhats,
  infrastructureWhats,
  administrativeWhats,
  customerRegister,
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

  static CollectionReference _cleckedLinkCollection =
      _firebaseFirestore.collection("clickedLinks");

  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> _updateCcsAndEnterpriseNameByDocument({
    required DocumentSnapshot documentSnapshot,
    required String enterpriseNameOrurlCCSControllerText,
  }) async {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    if (data.containsKey('urlCCS') && !kIsWeb) {
      enterpriseNameOrurlCCSControllerText = data['urlCCS'];
      UserData.urlCCS = data['urlCCS'];
    } else if (data.containsKey("urlCCSWeb") && kIsWeb) {
      enterpriseNameOrurlCCSControllerText = data['urlCCSWeb'];
      UserData.urlCCS = data['urlCCSWeb'];
    } else if (data.containsKey('urlCCS') && kIsWeb) {
      enterpriseNameOrurlCCSControllerText = data['urlCCS'];
      UserData.urlCCS = data['urlCCS'];

      if (!UserData.urlCCS.contains("https")) {
        UserData.urlCCS = UserData.urlCCS.replaceAll("http", "https");
        UserData.urlCCS = UserData.urlCCS.replaceAll("9092", "9093");
      }
    }

    if (data.containsKey('enterpriseName') &&
        data['enterpriseName'] != "undefined") {
      enterpriseNameOrurlCCSControllerText = data['enterpriseName'];
      UserData.enterpriseName = data['enterpriseName'];
    }
  }

  static Future<String> getUrlFromFirebaseAndReturnErrorIfHas(
    String enterpriseNameOrurlCCSControllerText,
  ) async {
    String errorMessage = "";
    enterpriseNameOrurlCCSControllerText = enterpriseNameOrurlCCSControllerText
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ''); //remove espaços em branco

    QuerySnapshot? querySnapshot;
    if (kIsWeb && ConvertString.isUrl(enterpriseNameOrurlCCSControllerText)) {
      querySnapshot = await _getQuerySnapshot(
        collection: _clientsCollection,
        fieldToSearch: 'urlCCSWeb',
        isEqualTo: enterpriseNameOrurlCCSControllerText,
      );
    }

    if (querySnapshot == null &&
        ConvertString.isUrl(enterpriseNameOrurlCCSControllerText)) {
      querySnapshot = await _getQuerySnapshot(
        collection: _clientsCollection,
        fieldToSearch: 'urlCCS',
        isEqualTo: enterpriseNameOrurlCCSControllerText,
      );
    }

    if (querySnapshot == null) {
      querySnapshot = await _getQuerySnapshot(
        collection: _clientsCollection,
        fieldToSearch: 'enterpriseName',
        isEqualTo: enterpriseNameOrurlCCSControllerText,
      );
    }

    if (querySnapshot.size > 0) {
      await _updateCcsAndEnterpriseNameByDocument(
        documentSnapshot: querySnapshot.docs[0],
        enterpriseNameOrurlCCSControllerText:
            enterpriseNameOrurlCCSControllerText,
      );

      errorMessage = "";
    } else {
      errorMessage =
          "A empresa não foi encontrada no banco de dados. Entre em contato com o suporte e solicite a URL do CCS para fazer o login";
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

    if (mySoaps.length < 5) {
      await PrefsInstance.setSoaps(mySoaps);
    } else {
      try {
        WriteBatch batch = firestore.batch();

        mySoaps.forEach((soapAction) {
          DocumentReference docRef = _soapActionsCollection
              .doc(DateFormat('yyyy-MM').format(DateTime.now()))
              .collection("soapInformations")
              .doc(UserData.enterpriseName);

          batch.set(
            docRef,
            {
              firebaseCallEnum.name: {
                kIsWeb ? "webTimesUsed" : "timesUsed": FieldValue.increment(1),
              },
              'users': FieldValue.arrayUnion([UserData.userName.toLowerCase()]),
              'datesUsed': FieldValue.arrayUnion(
                  [DateFormat('yyyy-MM-dd').format(DateTime.now())]),
            },
            SetOptions(merge: true),
          );
        });

        batch.commit().then(
          (value) async {
            await PrefsInstance.clearSoaps();
            //print("soapInformation adicionada");
          },
        ).catchError((error) {
          //print("Erro para adicionar a soapInformation: $error");
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static addCcsClientInFirebase() async {
    FirebaseClientModel firebaseClientModel = FirebaseClientModel(
      urlCCS: UserData.urlCCS,
    );

    QuerySnapshot? querySnapshotCcs;
    QuerySnapshot? querySnapshotCcsWeb;
    QuerySnapshot? querySnapshotEnterpriseName;

    querySnapshotEnterpriseName = await _getQuerySnapshot(
      collection: _clientsCollection,
      fieldToSearch: 'enterpriseName',
      isEqualTo: UserData.enterpriseName,
    );

    querySnapshotCcs = await _getQuerySnapshot(
      collection: _clientsCollection,
      fieldToSearch: 'urlCCS',
      isEqualTo: UserData.urlCCS,
    );

    if (kIsWeb) {
      querySnapshotCcsWeb = await _getQuerySnapshot(
        collection: _clientsCollection,
        fieldToSearch: 'urlCCSWeb',
        isEqualTo: UserData.urlCCS,
      );

      if (querySnapshotCcsWeb.size > 0) {
        return;
      } else if (querySnapshotCcsWeb.size == 0 &&
          querySnapshotEnterpriseName.size > 0) {
        await _addUrlCCSWeb(querySnapshot: querySnapshotEnterpriseName);
      } else if (querySnapshotCcsWeb.size == 0 && querySnapshotCcs.size > 0) {
        await _addUrlCCSWeb(querySnapshot: querySnapshotCcs);
      }
    }

    if (querySnapshotCcs.size == 0 &&
        querySnapshotCcsWeb?.size == 0 &&
        querySnapshotEnterpriseName.size == 0) {
      //só adiciona o cliente se não encontrar urlCCS com a que está sendo
      //utilizada
      _clientsCollection
          .add(firebaseClientModel.toJson())
          .then((value) => value)
          .catchError((error) => error);
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Got a message whilst in the background!');
    print("title: ${message.notification?.title}");
    print("body: ${message.notification?.body}");
    print("data: ${message.data}");
  }

  static Future<void> initNotifications(BuildContext context) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("Token: $fcmToken"); //precisa usar esse token pra fazer testes de
    // mensagens pelo site do firebase

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    //sempre que chegar uma mensagem e o aplicativo estiver EM SEGUNDO PLANO,
    //vai aparecer a notificação pro cliente. Quando o aplicativo estiver em
    //primeiro plano, vai executar a função abaixo

    //abaixo recebe a notificação em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Título da notificação: ${message.notification!.title.toString()}');
        print('Texto da notificação: ${message.notification!.body}');
      }
    });
  }

  static Future<void> addClickedInLink({
    required FirebaseCallEnum firebaseCallEnum,
  }) async {
    DocumentReference docRef =
        _cleckedLinkCollection.doc(UserData.enterpriseName);

    await docRef
        .set(
          {
            firebaseCallEnum.name: {
              "timesClicked": FieldValue.increment(1),
              'users': FieldValue.arrayUnion([UserData.userName.toLowerCase()]),
              'datesClicked': FieldValue.arrayUnion(
                  [DateFormat('yyyy-MM-dd').format(DateTime.now())]),
            },
          },
          SetOptions(merge: true),
        )
        .then((value) => value)
        .catchError((error) => error);
  }

  static Future<QuerySnapshot<Object?>> _getQuerySnapshot({
    required CollectionReference<Object?> collection,
    required Object fieldToSearch,
    required String isEqualTo,
  }) async {
    return await collection
        .where(
          fieldToSearch,
          isEqualTo: isEqualTo
              .toLowerCase()
              .replaceAll(RegExp(r'\s+'), ''), //remove espaços em branco
        )
        .get();
  }

  static _addUrlCCSWeb({required QuerySnapshot querySnapshot}) async {
    _clientsCollection
        .doc(querySnapshot.docs[0].id)
        .set(
          {
            "urlCCSWeb": UserData.urlCCS,
          },
          SetOptions(merge: true),
        )
        .then((value) => value)
        .catchError((error) => error);
  }
}
