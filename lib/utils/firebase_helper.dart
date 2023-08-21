import 'package:celta_inventario/utils/base_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<void> addSoapCallInFirebase({
    required FirebaseCallEnum firebaseCallEnum,
  }) async {
    return;
    _codeOfSoapAction(firebaseCallEnum);
    QuerySnapshot? querySnapshot;

    querySnapshot = await _clientsCollection
        .where(
          'urlCCS',
          isEqualTo: BaseUrl.ccsUrl.trimRight().trimLeft().toLowerCase(),
        )
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

      DocumentReference documentReference =
          _clientsCollection.doc(documentSnapshot.id);

      QuerySnapshot querySnapshotSoapActions =
          await documentReference.collection("soapActions").get();

      Map<String, dynamic> soapCallsDetails = {
        "date": DateTime.now().toIso8601String(),
        "typeOfSearch": firebaseCallEnum.index,
      };

      await documentReference
          .collection("soapActions")
          .add(soapCallsDetails)
          .then((value) => print("adicionou contador"))
          .catchError((error) => print("erro pra adicionar o contador $error"));

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
    }
  }
}
