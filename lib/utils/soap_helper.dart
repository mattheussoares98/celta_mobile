import 'dart:convert';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class SoapHelperResponseParameters {
  static final SoapHelperResponseParameters _instance =
      SoapHelperResponseParameters._internal();

  factory SoapHelperResponseParameters() {
    return _instance;
  }

  SoapHelperResponseParameters._internal();

  static String responseAsString = '';
  static String errorMessage = '';
  static Map responseAsMap = {};
}

class SoapHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference _clientsCollection = _db.collection("clients");
  static _addCounterInFirebase({
    required String serviceASMX,
  }) async {
    serviceASMX = serviceASMX.replaceAll(RegExp(r'\.'), '-');
    QuerySnapshot? querySnapshot;

    querySnapshot = await _clientsCollection
        .where(
          'urlCCS',
          isEqualTo: BaseUrl.ccsUrl.trimRight().trimLeft().toLowerCase(),
        )
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      DocumentReference documentReference =
          _clientsCollection.doc(documentSnapshot.id);

      if (!data.containsKey(serviceASMX)) {
        await documentReference
            .update({
              serviceASMX: 1,
            })
            .then((value) => null)
            .catchError((error) => null);
      } else {
        await _clientsCollection
            .doc(documentSnapshot.id)
            .set({
              serviceASMX: FieldValue.increment(1),
            }, SetOptions(merge: true))
            .then((value) => null)
            .catchError((error) => null);
      }
    }
  }

  static soapPost({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    String? typeOfResult,
    required String SOAPAction,
    required String serviceASMX,
  }) async {
    SoapHelperResponseParameters.errorMessage = "";
    SoapHelperResponseParameters.responseAsString = "";
    final soapHeaders = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://celtaware.com.br/$SOAPAction',
      'Accept-Language': 'en-US',
    };

    String parameterTags = '';

    parameters.forEach((tag, value) {
      parameterTags += '<$tag>$value</$tag>\n';
    });

    final envelope = '''<?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <$SOAPAction xmlns="http://celtaware.com.br/">
          $parameterTags
          </$SOAPAction>
        </soap12:Body>
      </soap12:Envelope>''';

    final response = await http.post(
      Uri.parse('${BaseUrl.ccsUrl}/$serviceASMX'),
      headers: soapHeaders,
      body: envelope,
    );

    if (response.statusCode == 200) {
      _addCounterInFirebase(serviceASMX: serviceASMX);

      String result = response.body;

      final Xml2Json xml2json = Xml2Json();
      xml2json.parse(result);
      final getJustificationsResult = xml2json.toParker();
      Map parsedJson = json.decode(getJustificationsResult.toString());
      print("parsedJson: $parsedJson");

      if (parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]["status"] ==
          "OK") {
        if (typeOfResult != null) {
          if (parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                  [typeOfResult] !=
              null) {
            SoapHelperResponseParameters.responseAsString =
                parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                        [typeOfResult]
                    .toString();
          }

          if (_validateResultHasPatternNewDataSet(
            parsedJson: parsedJson,
            typeOfResponse: typeOfResponse,
            typeOfResult: typeOfResult,
          )) {
            //no login não retorna nesse padrão de tags, por isso estava ocorrendo erro e por isso precisei criar esse tratamento
            SoapHelperResponseParameters.responseAsMap =
                parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                    [typeOfResult]["diffgr:diffgram"]["NewDataSet"];
          }
        }
      } else {
        if (parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
            .toString()
            .contains("sucesso")) {
          SoapHelperResponseParameters.responseAsString =
              parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                  ["status"];
        } else {
          SoapHelperResponseParameters.errorMessage =
              parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                  ["status"];
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  var x = "y";
}

bool _validateResultHasPatternNewDataSet({
  required Map parsedJson,
  required String typeOfResponse,
  required String typeOfResult,
}) {
  return parsedJson.containsKey("soap:Envelope") &&
      parsedJson["soap:Envelope"] is Map &&
      parsedJson["soap:Envelope"].containsKey("soap:Body") &&
      parsedJson["soap:Envelope"]["soap:Body"] is Map &&
      parsedJson["soap:Envelope"]["soap:Body"].containsKey(typeOfResponse) &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse] is Map &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
          .containsKey(typeOfResult) &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
          is Map &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
          .containsKey("diffgr:diffgram") &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
          ["diffgr:diffgram"] is Map &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
              ["diffgr:diffgram"]
          .containsKey("NewDataSet");
}
