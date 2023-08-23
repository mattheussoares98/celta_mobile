import 'package:celta_inventario/Models/firebase_client_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference _clientsCollection = _db.collection("clients");

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
    required String enterpriseNameOrCCSUrlControllerText,
  }) async {
    DocumentReference documentRef = _clientsCollection.doc(documentId);
    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data.containsKey('urlCCS')) {
        enterpriseNameOrCCSUrlControllerText = data['urlCCS'];
        BaseUrl.ccsUrl = data['urlCCS'];
        await prefs.setString('urlCCS', data['urlCCS']);
      }

      if (data.containsKey('enterpriseName') &&
          data['enterpriseName'] != "undefined") {
        enterpriseNameOrCCSUrlControllerText = data['enterpriseName'];
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
    String enterpriseNameOrCCSUrlControllerText,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String errorMessage = "";
    if (_isUrl(enterpriseNameOrCCSUrlControllerText)) {
      await prefs.setString('enterpriseName', "");
      //como está informando uma URL, precisa excluir o nome da empresa do banco
      //de dados pra não carregar o nome da empresa errado depois
      BaseUrl.ccsUrl = enterpriseNameOrCCSUrlControllerText;

      QuerySnapshot? querySnapshot;
      querySnapshot = await _clientsCollection
          .where(
            'urlCCS',
            isEqualTo: enterpriseNameOrCCSUrlControllerText
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
          enterpriseNameOrCCSUrlControllerText:
              enterpriseNameOrCCSUrlControllerText,
        );
      }
    } else {
      QuerySnapshot? querySnapshot;
      querySnapshot = await _clientsCollection
          .where(
            'enterpriseName',
            isEqualTo: enterpriseNameOrCCSUrlControllerText
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
          enterpriseNameOrCCSUrlControllerText:
              enterpriseNameOrCCSUrlControllerText,
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
    //       isEqualTo: BaseUrl.ccsUrl.trimRight().trimLeft().toLowerCase(),
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
      urlCCS: BaseUrl.ccsUrl,
    );

    QuerySnapshot? querySnapshot;
    querySnapshot = await _clientsCollection
        .where(
          'urlCCS',
          isEqualTo: BaseUrl.ccsUrl
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
}
