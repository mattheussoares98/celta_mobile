import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platform_plus/platform_plus.dart';

import '../models/firebase/firebase.dart';
import '../firebase_options.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';
import './api.dart';

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
  buyRequestSave,
  researchPricesInsertPrice,
}

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper._internal();

  factory FirebaseHelper() {
    return _instance;
  }

  FirebaseHelper._internal();

  static FirebaseAuth _firebaseauth = FirebaseAuth.instance;

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

    if (data.containsKey('urlCCS')) {
      enterpriseNameOrurlCCSControllerText = data['urlCCS'];
      UserData.urlCCS = data['urlCCS'];
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

    if (ConvertString.isUrl(enterpriseNameOrurlCCSControllerText)) {
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
        await _addUserInformations();
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
                PlatformPlus.platform.isIOSNative ||
                        PlatformPlus.platform.isIOSWeb
                    ? "iOS"
                    : "android": FieldValue.increment(1),
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
            ////print("soapInformation adicionada");
          },
        ).catchError((error) {
          ////print("Erro para adicionar a soapInformation: $error");
        });
      } catch (e) {
        //print(e);
      }
    }
  }

  static addCcsClientInFirebase() async {
    FirebaseClientModel firebaseClientModel = FirebaseClientModel(
      urlCCS: UserData.urlCCS,
      id: null,
      usersInformations: null,
    );

    QuerySnapshot? querySnapshotCcs;
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

    if (querySnapshotCcs.size == 0 && querySnapshotEnterpriseName.size == 0) {
      _clientsCollection
          .add(firebaseClientModel.toJson())
          .then((value) => value)
          .catchError((error) => error);
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    //print('Got a message whilst in the background!');
    //print("title: ${message.notification?.title}");
    //print("body: ${message.notification?.body}");
    //print("data: ${message.data}");
  }

  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> initNotifications(
      NotificationsProvider notificationsProvider) async {
    if (kIsWeb) {
      return;
    }
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("Token: $fcmToken"); //precisa usar esse token pra fazer testes de
    // mensagens pelo site do firebase
    UserData.fcmToken = fcmToken;

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("Mensagem inicial: ${initialMessage}");
    }

    //quando clica na notificação pra abrir o aplicativo
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
          .pushNamed(APPROUTES.NOTIFICATIONS);
    });

    //mensagens em segundo plano
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    //abaixo recebe a notificação em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        notificationsProvider.setHasUnreadNotifications(
            newValue: true, notify: false);
      } catch (e) {
        print(e);
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

  static Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseauth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> getAllClients() async {
    try {
      final value = await _clientsCollection.get();

      return value.docs;
    } catch (e) {
      throw Exception();
    }
  }

  static Future<void> _addUserInformations() async {
    if (UserData.alreadyInsertedUsersInformations) return;

    try {
      final value = await PrefsInstance.getUsersInformations();

      if (value.isNotEmpty) {
        UserData.alreadyInsertedUsersInformations = true;

        final userInformations = UserInformationsModel.fromJson(
          json.decode(value),
        );
        int diferenceBetweenAtualDateAndLastUpdated = userInformations
            .dateOfLastUpdatedInFirebase
            .difference(DateTime.now())
            .inDays;
        if (diferenceBetweenAtualDateAndLastUpdated <= 7) {
          return;
        }
      }

      final result = await _clientsCollection
          .where(
            "enterpriseName",
            isEqualTo: UserData.enterpriseName,
          )
          .get();

      if (result.docs.isNotEmpty) {
        final userInformations = UserInformationsModel(
          fcmToken: UserData.fcmToken,
          userName: UserData.userName,
          deviceType: PlatformPlus.platform.isIOSNative ? "iOS" : "android",
          dateOfLastUpdatedInFirebase: DateTime.now(),
        );

        await _clientsCollection.doc(result.docs.first.id).set(
          {
            "usersInformations": FieldValue.arrayUnion([
              userInformations.toJson(),
            ]),
          },
          SetOptions(merge: true),
        );

        UserData.alreadyInsertedUsersInformations = true;

        await PrefsInstance.setUsersInformations(json.encode(userInformations));
      }
    } catch (e) {
      print("erro para adicionar as informações do usuário ==== $e");
    }
  }

  static Future<List<QueryDocumentSnapshot>?> getAllSoapActions(
      yearAndMonth) async {
    try {
      final soapActions = await _firebaseFirestore
          .collection("soapActions")
          .doc(yearAndMonth)
          .collection("soapInformations")
          .get();

      if (soapActions.docs.isNotEmpty) {
        return soapActions.docs;
      }
    } catch (e) {
      debugPrint("Erro para obter as requisições: $e");
    }
    return null;
  }

  static Future<void> deleteEnterprise(String id) async {
    try {
      await _clientsCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateUrlCcs({
    required String newUrl,
    required FirebaseClientModel client,
  }) async {
    try {
      if (client.urlCCS == newUrl) {
        throw "Ajuda aí poxa kkkk tá colocando a mesma URL";
      }
      await _clientsCollection.doc(client.id).update({"urlCCS": newUrl});
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> addNewEnterprise(FirebaseClientModel clientModel) async {
    try {
      await _clientsCollection
          .doc(clientModel.enterpriseName)
          .set(clientModel.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
