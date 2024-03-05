import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import '../utils/utils.dart';

class SoapHelperResponseParameters {
  static final SoapHelperResponseParameters _instance =
      SoapHelperResponseParameters._internal();

  factory SoapHelperResponseParameters() {
    return _instance;
  }

  SoapHelperResponseParameters._internal();
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

class SoapHelper {
  static Future<void> soapPost({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    String? typeOfResult,
    required String SOAPAction,
    required String serviceASMX,
  }) async {
    try {
      SoapHelperResponseParameters.errorMessage = "";
      SoapHelperResponseParameters.responseAsString = "";
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
        print("parsedJson: $parsedJson");

        if (parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                ["status"] ==
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
        SoapHelperResponseParameters.errorMessage =
            DefaultErrorMessageToFindServer.ERROR_MESSAGE;
        print(response.body);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("erro para fazer a requisição http: $e");
      SoapHelperResponseParameters.errorMessage =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
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
