import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import '../../utils/utils.dart';

class SoapRequestResponse {
  static final SoapRequestResponse _instance = SoapRequestResponse._internal();

  factory SoapRequestResponse() {
    return _instance;
  }

  SoapRequestResponse._internal();
  static String get responseAsString => _responseAsString;
  static set responseAsString(String value) {
    _responseAsString = value;
  }

  static String get errorMessage => _errorMessage;
  static set errorMessage(String value) {
    _errorMessage = value;
  }

  static String _responseAsString = '';
  static String _errorMessage = '';
  static Map responseAsMap = {};
}

class SoapRequest {
  static Future<void> soapPost({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    String? typeOfResult,
    required String SOAPAction,
    required String serviceASMX,
  }) async {
    try {
      SoapRequestResponse.errorMessage = "";
      SoapRequestResponse.responseAsString = "";
      final soapHeaders = {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://celtaware.com.br/$SOAPAction',
        'Accept-Language': 'en-US',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
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
        Uri.parse('${UserData.urlCCS}/$serviceASMX'),
        headers: soapHeaders,
        body: envelope,
      );

      if (response.statusCode == 200) {
        String result = response.body;

        final Xml2Json xml2json = Xml2Json();
        xml2json.parse(result);
        final getJustificationsResult = xml2json.toParker();
        Map parsedJson = json.decode(getJustificationsResult.toString());
        final parsedJsonResponse =
            parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse];

        if (parsedJsonResponse["status"] == "OK") {
          
          if (parsedJsonResponse[typeOfResult] != null) {
            SoapRequestResponse.responseAsString =
                parsedJsonResponse[typeOfResult].toString();
          }

          if (_validateResultHasPatternNewDataSet(
            parsedJson: parsedJson,
            typeOfResponse: typeOfResponse,
            typeOfResult: typeOfResult,
          )) {
            SoapRequestResponse.responseAsMap = parsedJsonResponse[typeOfResult]
                ["diffgr:diffgram"]["NewDataSet"];
          }
        } else if (parsedJsonResponse.toString().contains("sucesso")) {
          SoapRequestResponse.responseAsString = parsedJsonResponse["status"];
        } else {
          SoapRequestResponse.errorMessage = parsedJsonResponse["status"];
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      SoapRequestResponse.errorMessage = DefaultErrorMessage.ERROR;
    }
  }
}

bool _validateResultHasPatternNewDataSet({
  required Map parsedJson,
  required String typeOfResponse,
  required String? typeOfResult,
}) {
  try {
    return parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
        [typeOfResult]["diffgr:diffgram"]["NewDataSet"] is Map;
  } catch (e) {
    return false;
  }
}
